package com.company.hrms.security;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.core.io.ClassPathResource;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

@SpringBootTest
@ActiveProfiles("test")
class SecurityAccessIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void protectedEndpointRequiresAuth() throws Exception {
        mvc.perform(get("/api/v1/employees"))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void invalidBearerTokenIsRejected() throws Exception {
        mvc.perform(get("/api/v1/employees")
                .header("Authorization", "Bearer anything-at-all"))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void localDevTokenKeepsDeveloperAccess() throws Exception {
        mvc.perform(get("/api/v1/employees")
                .header("Authorization", "Bearer local-test-token"))
            .andExpect(status().isOk());
    }

    @Test
    void databaseRolePermissionsOverrideTokenClaimedAuthorities() throws Exception {
        String token = signedJwt(
            "b1000000-0000-4000-8000-000000000002",
            "b1000000-0000-4000-8000-000000000002",
            List.of("employee:read")
        );

        mvc.perform(get("/api/v1/employees")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isForbidden());
    }

    @Test
    void currentAccessEndpointReturnsDatabaseRoles() throws Exception {
        mvc.perform(get("/api/v1/authz/me")
                .header("Authorization", "Bearer local-test-token"))
            .andExpect(status().isOk());
    }

    @Test
    void loginWithSeededAccountReturnsToken() throws Exception {
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"username":"line-manager","password":"manager123","tenantId":"default"}
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.token").isNotEmpty())
            .andExpect(jsonPath("$.username").value("line-manager"));
    }

    @Test
    void loginRejectsInvalidPassword() throws Exception {
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"username":"line-manager","password":"wrong","tenantId":"default"}
                    """))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void employeeDeleteRequiresDeletePermission() throws Exception {
        String employeeToken = signedJwt(
            "b1000000-0000-4000-8000-000000000002",
            "b1000000-0000-4000-8000-000000000002",
            List.of("employee:read")
        );

        mvc.perform(delete("/api/v1/employees/b1000000-0000-4000-8000-000000000002")
                .header("Authorization", "Bearer " + employeeToken))
            .andExpect(status().isForbidden());
    }

    @Test
    void seededLineManagerCanReadEmployeesButCannotManageAuthorization() throws Exception {
        String managerToken = signedJwt(
            "b1000000-0000-4000-8000-000000000011",
            "b1000000-0000-4000-8000-000000000011",
            List.of("employee:read", "authz:read")
        );

        mvc.perform(get("/api/v1/employees")
                .header("Authorization", "Bearer " + managerToken))
            .andExpect(status().isOk());

        mvc.perform(get("/api/v1/authz/roles")
                .header("Authorization", "Bearer " + managerToken))
            .andExpect(status().isForbidden());
    }

    @Test
    void lineManagerCannotApproveLeaveOutsideScope() throws Exception {
        String managerToken = signedJwt(
            "b1000000-0000-4000-8000-000000000020",
            "b1000000-0000-4000-8000-000000000020",
            List.of("leave:approve")
        );

        mvc.perform(post("/api/v1/leave-requests/{id}/approve", "00000000-0000-0000-0000-000000000000")
                .header("Authorization", "Bearer " + managerToken))
            .andExpect(status().isNotFound());
    }

    private static String signedJwt(String subject, String employeeId, List<String> authorities) throws Exception {
        ClassPathResource resource = new ClassPathResource("keys/dev-private.pem");
        String pem = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        String keyContent = pem
            .replace("-----BEGIN PRIVATE KEY-----", "")
            .replace("-----END PRIVATE KEY-----", "")
            .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(keyContent);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        RSAPrivateKey privateKey = (RSAPrivateKey) keyFactory.generatePrivate(keySpec);

        Instant now = Instant.now();
        JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
            .subject(subject)
            .claim("employee_id", employeeId)
            .claim("authorities", authorities)
            .issueTime(Date.from(now))
            .expirationTime(Date.from(now.plusSeconds(3600)))
            .build();

        SignedJWT signedJWT = new SignedJWT(new JWSHeader(JWSAlgorithm.RS256), claimsSet);
        signedJWT.sign(new RSASSASigner(privateKey));
        return signedJWT.serialize();
    }
}
