package com.company.hrms.shared.security;

import com.company.hrms.shared.tenant.TenantContext;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    private final JdbcTemplate jdbcTemplate;
    private final RSAPrivateKey privateKey;

    public AuthController(JdbcTemplate jdbcTemplate,
                          @Value("classpath:keys/dev-private.pem") Resource privateKeyResource) throws Exception {
        this.jdbcTemplate = jdbcTemplate;
        this.privateKey = readPrivateKey(privateKeyResource);
    }

    @PostMapping("/login")
    public LoginResponse login(@RequestBody LoginRequest request) {
        if (request.username() == null || request.username().isBlank() || request.password() == null || request.password().isBlank()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS");
        }

        String tenantId = TenantContext.get();
        if (tenantId == null || tenantId.isBlank()) {
            tenantId = request.tenantId() == null || request.tenantId().isBlank() ? "default" : request.tenantId().trim();
        }

        LoginUser user = findUser(tenantId, request.username().trim())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS"));

        if (user.passwordHash() == null || user.passwordHash().isBlank() || !BCrypt.checkpw(request.password(), user.passwordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS");
        }

        String token = signedJwt(tenantId, user.id(), user.employeeId());
        return new LoginResponse(token, tenantId, user.id(), user.username(), user.displayName());
    }

    private Optional<LoginUser> findUser(String tenantId, String username) {
        return jdbcTemplate.query("""
            select id, username, display_name, employee_id, password_hash
            from app_user
            where tenant_id = ?
              and lower(username) = lower(?)
              and enabled = true
            """, rs -> {
            if (!rs.next()) {
                return Optional.empty();
            }
            return Optional.of(new LoginUser(
                    rs.getObject("id", UUID.class),
                    rs.getString("username"),
                    rs.getString("display_name"),
                    rs.getObject("employee_id", UUID.class),
                    rs.getString("password_hash")
            ));
        }, tenantId, username);
    }

    /**
     * Creates an RS256-signed JWT for the authenticated user.
     * The signature is computed using the dev RSA private key.
     */
    private String signedJwt(String tenantId, UUID subject, UUID employeeId) {
        try {
            Instant now = Instant.now();
            JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
                    .subject(subject.toString())
                    .claim("employee_id", employeeId.toString())
                    .claim("tenant_id", tenantId)
                    .issueTime(Date.from(now))
                    .expirationTime(Date.from(now.plusSeconds(3600)))
                    .build();

            SignedJWT signedJWT = new SignedJWT(
                    new JWSHeader(JWSAlgorithm.RS256),
                    claimsSet
            );
            signedJWT.sign(new RSASSASigner(privateKey));
            return signedJWT.serialize();
        } catch (Exception e) {
            throw new RuntimeException("Failed to sign JWT", e);
        }
    }

    private static RSAPrivateKey readPrivateKey(Resource resource) throws Exception {
        String pem = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        // Strip PEM headers and decode base64
        String privKeyPem = pem
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(privKeyPem);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return (RSAPrivateKey) keyFactory.generatePrivate(keySpec);
    }

    public record LoginRequest(String username, String password, String tenantId) {}
    public record LoginResponse(String token, String tenantId, UUID userId, String username, String displayName) {}
    private record LoginUser(UUID id, String username, String displayName, UUID employeeId, String passwordHash) {}
}
