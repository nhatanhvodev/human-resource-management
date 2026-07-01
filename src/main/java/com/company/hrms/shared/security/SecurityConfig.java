package com.company.hrms.shared.security;

import com.company.hrms.shared.tenant.TenantContext;
import com.company.hrms.shared.tenant.TenantContextFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.jose.jws.SignatureAlgorithm;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.AbstractOAuth2TokenAuthenticationToken;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.core.convert.converter.Converter;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.time.Instant;
import java.util.Base64;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    /**
     * Dev-only shortcut token that bypasses RS256 verification.
     * Used for local testing without needing a real signed JWT.
     * In production, remove this constant and rely solely on RS256-signed tokens.
     */
    private static final String LOCAL_DEV_TOKEN = "local-test-token";

    @Value("${app.security.admin-authorities}")
    private List<String> adminAuthorities;

    @Bean
    @Order(1)
    SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            TenantContextFilter tenantContextFilter,
            RbacAuthorityService rbacAuthorityService
    ) throws Exception {
        return http
                .csrf(csrf -> {
                    // DEV ONLY: CSRF is disabled for this API-driven SPA frontend.
                    // The backend serves as a pure JSON API; no server-rendered forms exist.
                    // CSRF tokens are not applicable when the client is a native/mobile app
                    // or a Single Page Application using Bearer JWT authentication.
                    //
                    // PRODUCTION NOTE: If this backend ever serves server-rendered views or
                    // supports cookie-based auth, re-enable CSRF with a proper token repository:
                    //   csrf(csrf -> csrf
                    //       .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                    //       .csrfTokenRequestHandler(new CsrfTokenRequestAttributeHandler()))
                    csrf.disable();
                })
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/actuator/health").permitAll()
                        .requestMatchers("/api/v1/auth/login").permitAll()
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter(rbacAuthorityService))))
                .addFilterBefore(tenantContextFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    /**
     * Creates a JwtDecoder that verifies RS256 signatures using the dev public key.
     * Also supports the LOCAL_DEV_TOKEN shortcut for local development.
     * <p>
     * For production, replace this bean with Spring Boot auto-configuration by setting
     * {@code spring.security.oauth2.resourceserver.jwt.public-key-location} and removing
     * this bean definition (or using a conditional profile).
     */
    @Bean
    JwtDecoder jwtDecoder() throws Exception {
        ClassPathResource resource = new ClassPathResource("keys/dev-public.pem");
        String pem = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        String pubKeyPem = pem
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(pubKeyPem);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(encoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        RSAPublicKey publicKey = (RSAPublicKey) keyFactory.generatePublic(keySpec);

        NimbusJwtDecoder nimbusDecoder = NimbusJwtDecoder.withPublicKey(publicKey)
                .signatureAlgorithm(SignatureAlgorithm.RS256)
                .build();

        return token -> {
            if (LOCAL_DEV_TOKEN.equals(token)) {
                return localAdminJwt(token);
            }
            return nimbusDecoder.decode(token);
        };
    }

    /**
     * Creates a synthetic admin Jwt for the LOCAL_DEV_TOKEN shortcut.
     */
    private Jwt localAdminJwt(String token) {
        Instant now = Instant.now();
        return Jwt.withTokenValue(token)
                .header("alg", "RS256")
                .subject("admin")
                .claim("roles", List.of("ADMIN"))
                .claim("authorities", adminAuthorities)
                .issuedAt(now)
                .expiresAt(now.plusSeconds(3600))
                .build();
    }

    private Converter<Jwt, AbstractOAuth2TokenAuthenticationToken<Jwt>> jwtAuthenticationConverter(
            RbacAuthorityService rbacAuthorityService) {
        return jwt -> {
            String tenantId = TenantContext.get();
            if (tenantId == null || tenantId.isBlank()) {
                tenantId = jwt.getClaimAsString("tenant_id");
            }
            if (tenantId == null || tenantId.isBlank()) {
                tenantId = "default";
            }

            RbacAuthorityService.AccessSnapshot access = rbacAuthorityService.currentAccess(
                    tenantId,
                    jwt.getSubject(),
                    jwt.getClaimAsString("employee_id")
            );

            // Merge IdP-mapped role permissions
            List<String> idpGroups = jwt.getClaimAsStringList("groups");
            List<String> idpPermissions = List.of();
            if (idpGroups != null && !idpGroups.isEmpty()) {
                List<UUID> idpRoleIds = rbacAuthorityService.resolveIdpRoleIds(tenantId, idpGroups);
                if (!idpRoleIds.isEmpty()) {
                    idpPermissions = rbacAuthorityService.listPermissionCodesForRoles(idpRoleIds);
                }
            }

            Collection<GrantedAuthority> authorities = new java.util.ArrayList<>();
            authorities.addAll(access.authorities().stream()
                    .map(SimpleGrantedAuthority::new)
                    .toList());
            authorities.addAll(idpPermissions.stream()
                    .map(SimpleGrantedAuthority::new)
                    .toList());

            return new JwtAuthenticationToken(jwt, authorities, jwt.getSubject());
        };
    }
}
