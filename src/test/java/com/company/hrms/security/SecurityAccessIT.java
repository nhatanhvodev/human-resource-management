package com.company.hrms.security;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
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
        String token = unsignedJwt(
            "b1000000-0000-4000-8000-000000000002",
            "b1000000-0000-4000-8000-000000000002",
            "[\"employee:read\"]"
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
    void employeeDeleteRequiresDeletePermission() throws Exception {
        String employeeToken = unsignedJwt(
            "b1000000-0000-4000-8000-000000000002",
            "b1000000-0000-4000-8000-000000000002",
            "[\"employee:read\"]"
        );

        mvc.perform(delete("/api/v1/employees/b1000000-0000-4000-8000-000000000002")
                .header("Authorization", "Bearer " + employeeToken))
            .andExpect(status().isForbidden());
    }

    @Test
    void lineManagerCannotApproveLeaveOutsideScope() throws Exception {
        String managerToken = unsignedJwt(
            "b1000000-0000-4000-8000-000000000020",
            "b1000000-0000-4000-8000-000000000020",
            "[\"leave:approve\"]"
        );

        mvc.perform(post("/api/v1/leave-requests/{id}/approve", "00000000-0000-0000-0000-000000000000")
                .header("Authorization", "Bearer " + managerToken))
            .andExpect(status().isNotFound());
    }

    private static String unsignedJwt(String subject, String employeeId, String authoritiesJson) {
        long now = Instant.now().getEpochSecond();
        String claims = """
            {"sub":"%s","employee_id":"%s","authorities":%s,"iat":%d,"exp":%d}
            """.formatted(subject, employeeId, authoritiesJson, now, now + 3600).trim();
        return base64Url("{\"alg\":\"none\"}") + "." + base64Url(claims) + ".signature";
    }

    private static String base64Url(String value) {
        return Base64.getUrlEncoder()
            .withoutPadding()
            .encodeToString(value.getBytes(StandardCharsets.UTF_8));
    }
}
