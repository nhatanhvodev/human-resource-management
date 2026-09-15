package com.company.hrms.shared.security;

import com.company.hrms.shared.tenant.TenantContext;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.HexFormat;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    static final String REFRESH_COOKIE = "hrms_refresh";
    private static final int MAX_ATTEMPTS = 10;
    private static final long WINDOW_MS = 60_000L;
    private static final Duration REFRESH_TTL = Duration.ofDays(7);

    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final RSAPrivateKey privateKey;
    private final long accessTokenTtlSeconds;
    private final boolean cookieSecure;
    private final Map<String, Attempt> attempts = new ConcurrentHashMap<>();
    private final SecureRandom secureRandom = new SecureRandom();

    public AuthController(JdbcTemplate jdbcTemplate,
                          PasswordEncoder passwordEncoder,
                          @Value("${app.security.private-key-location:classpath:keys/dev-private.pem}") Resource privateKeyResource,
                          @Value("${app.security.access-token-ttl-seconds:900}") long accessTokenTtlSeconds,
                          @Value("${app.security.cookie-secure:false}") boolean cookieSecure) throws Exception {
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
        this.privateKey = readPrivateKey(privateKeyResource);
        this.accessTokenTtlSeconds = accessTokenTtlSeconds;
        this.cookieSecure = cookieSecure;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        if (request.username() == null || request.username().isBlank() || request.password() == null || request.password().isBlank()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS");
        }
        if (request.username().trim().length() > 128 || request.password().length() > 256) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS");
        }

        String tenantId = TenantContext.get();
        if (tenantId == null || tenantId.isBlank()) {
            tenantId = request.tenantId() == null || request.tenantId().isBlank() ? "default" : request.tenantId().trim();
        }

        checkRateLimit(tenantId, request.username().trim());

        LoginUser user = findUser(tenantId, request.username().trim())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS"));

        if (user.passwordHash() == null || user.passwordHash().isBlank() || !passwordEncoder.matches(request.password(), user.passwordHash())) {
            recordFailure(tenantId, request.username().trim());
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS");
        }
        attempts.remove(rateKey(tenantId, request.username().trim()));

        String refreshToken = newRefreshToken(tenantId, user.id());
        String accessToken = signedJwt(tenantId, user.id(), user.employeeId());
        return withRefreshCookie(
            new LoginResponse(accessToken, tenantId, user.id(), user.username(), user.displayName()),
            refreshToken
        );
    }

    /**
     * Rotating refresh: the presented token is revoked and a new pair issued.
     * Reuse of a revoked token yields 401 (reuse detection logs the user out).
     */
    @PostMapping("/refresh")
    public ResponseEntity<LoginResponse> refresh(
            @CookieValue(value = REFRESH_COOKIE, required = false) String refreshToken) {
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_REFRESH_TOKEN");
        }
        String hash = sha256Hex(refreshToken);
        checkRateLimit("refresh", hash.substring(0, 8));

        RefreshRow row = findRefreshRow(hash).orElseThrow(() ->
            new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_REFRESH_TOKEN"));
        if (row.revoked() || row.expiresAt().isBefore(Instant.now())) {
            recordFailure("refresh", hash.substring(0, 8));
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_REFRESH_TOKEN");
        }

        LoginUser user = findUserById(row.tenantId(), row.userId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "INVALID_REFRESH_TOKEN"));

        revokeRefresh(hash);
        String nextRefresh = newRefreshToken(row.tenantId(), row.userId());
        String accessToken = signedJwt(row.tenantId(), user.id(), user.employeeId());
        return withRefreshCookie(
            new LoginResponse(accessToken, row.tenantId(), user.id(), user.username(), user.displayName()),
            nextRefresh
        );
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(
            @CookieValue(value = REFRESH_COOKIE, required = false) String refreshToken) {
        if (refreshToken != null && !refreshToken.isBlank()) {
            revokeRefresh(sha256Hex(refreshToken));
        }
        return ResponseEntity.noContent()
            .header(HttpHeaders.SET_COOKIE, clearRefreshCookie().toString())
            .build();
    }

    private void checkRateLimit(String tenantId, String username) {
        String key = rateKey(tenantId, username);
        Attempt a = attempts.get(key);
        long now = System.currentTimeMillis();
        if (a != null && now - a.windowStart() < WINDOW_MS && a.count() >= MAX_ATTEMPTS) {
            throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, "TOO_MANY_ATTEMPTS");
        }
    }

    private void recordFailure(String tenantId, String username) {
        String key = rateKey(tenantId, username);
        long now = System.currentTimeMillis();
        attempts.compute(key, (k, a) -> {
            if (a == null || now - a.windowStart() >= WINDOW_MS) {
                return new Attempt(1, now);
            }
            return new Attempt(a.count() + 1, a.windowStart());
        });
    }

    private static String rateKey(String tenantId, String username) {
        return tenantId + "|" + username.toLowerCase();
    }

    private record Attempt(int count, long windowStart) {}

    private String newRefreshToken(String tenantId, UUID userId) {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        jdbcTemplate.update(
            "insert into auth_refresh_token (id, tenant_id, user_id, token_hash, expires_at, revoked, created_at) values (?, ?, ?, ?, ?, false, now())",
            UUID.randomUUID(), tenantId, userId, sha256Hex(token),
            Timestamp.from(Instant.now().plus(REFRESH_TTL))
        );
        return token;
    }

    private void revokeRefresh(String hash) {
        jdbcTemplate.update("update auth_refresh_token set revoked = true where token_hash = ?", hash);
    }

    private Optional<RefreshRow> findRefreshRow(String hash) {
        return jdbcTemplate.query(
            "select tenant_id, user_id, expires_at, revoked from auth_refresh_token where token_hash = ?",
            rs -> rs.next()
                ? Optional.of(new RefreshRow(
                    rs.getString("tenant_id"),
                    rs.getObject("user_id", UUID.class),
                    rs.getTimestamp("expires_at").toInstant(),
                    rs.getBoolean("revoked")))
                : Optional.<RefreshRow>empty(),
            hash
        );
    }

    private static String sha256Hex(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(digest.digest(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new IllegalStateException("SHA-256 unavailable", e);
        }
    }

    private ResponseEntity<LoginResponse> withRefreshCookie(LoginResponse body, String refreshToken) {
        ResponseCookie cookie = ResponseCookie.from(REFRESH_COOKIE, refreshToken)
            .httpOnly(true)
            .secure(cookieSecure)
            .path("/api/v1/auth")
            .maxAge(REFRESH_TTL)
            .sameSite("Lax")
            .build();
        return ResponseEntity.ok()
            .header(HttpHeaders.SET_COOKIE, cookie.toString())
            .body(body);
    }

    private ResponseCookie clearRefreshCookie() {
        return ResponseCookie.from(REFRESH_COOKIE, "")
            .httpOnly(true)
            .secure(cookieSecure)
            .path("/api/v1/auth")
            .maxAge(0)
            .sameSite("Lax")
            .build();
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

    private Optional<LoginUser> findUserById(String tenantId, UUID userId) {
        return jdbcTemplate.query("""
            select id, username, display_name, employee_id, password_hash
            from app_user
            where tenant_id = ?
              and id = ?
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
        }, tenantId, userId);
    }

    /**
     * Creates an RS256-signed JWT for the authenticated user.
     * The signature is computed using the configured RSA private key
     * (classpath dev key by default, file/env-managed in production).
     */
    private String signedJwt(String tenantId, UUID subject, UUID employeeId) {
        try {
            Instant now = Instant.now();
            JWTClaimsSet.Builder builder = new JWTClaimsSet.Builder()
                    .subject(subject.toString())
                    .claim("tenant_id", tenantId)
                    .issueTime(Date.from(now))
                    .expirationTime(Date.from(now.plusSeconds(accessTokenTtlSeconds)));
            // System users (e.g. seed admin) may have no employee row yet.
            if (employeeId != null) {
                builder.claim("employee_id", employeeId.toString());
            }
            JWTClaimsSet claimsSet = builder.build();

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
        // Strip PEM headers and decode base64 (supports values with \n literals too)
        String privKeyPem = pem
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replace("\\n", "")
                .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(privKeyPem);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return (RSAPrivateKey) keyFactory.generatePrivate(keySpec);
    }

    public record LoginRequest(String username, String password, String tenantId) {}
    public record LoginResponse(String token, String tenantId, UUID userId, String username, String displayName) {}
    private record LoginUser(UUID id, String username, String displayName, UUID employeeId, String passwordHash) {}
    private record RefreshRow(String tenantId, UUID userId, Instant expiresAt, boolean revoked) {}
}
