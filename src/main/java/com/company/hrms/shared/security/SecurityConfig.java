package com.company.hrms.shared.security;

import com.company.hrms.shared.tenant.TenantContext;
import com.company.hrms.shared.tenant.TenantContextFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.Resource;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jose.jws.SignatureAlgorithm;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.AbstractOAuth2TokenAuthenticationToken;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.core.convert.converter.Converter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

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

    @Value("${app.security.dev-token:}")
    private String devToken;

    @Value("${app.security.allow-dev-token:false}")
    private boolean allowDevToken;

    @Value("${app.security.public-key-location:classpath:keys/dev-public.pem}")
    private Resource publicKeyResource;

    @Value("${app.security.csrf-enabled:false}")
    private boolean csrfEnabled;

    @Value("${app.cors.allowed-origins:http://localhost:5173}")
    private List<String> allowedOrigins;

    @Value("${app.security.admin-authorities}")
    private List<String> adminAuthorities;

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(allowedOrigins);
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("Authorization", "Content-Type", "X-Tenant-Id"));
        // Refresh flow uses an httpOnly cookie: credentialed requests need an
        // explicit (non-wildcard) origin list, which we already enforce above.
        config.setAllowCredentials(true);
        config.setMaxAge(3600L);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", config);
        return source;
    }

    @Bean
    @Order(1)
    SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            TenantContextFilter tenantContextFilter,
            RbacAuthorityService rbacAuthorityService
    ) throws Exception {
        return http
                .cors(cors -> {})
                .csrf(csrf -> {
                    if (!csrfEnabled) {
                        csrf.disable();
                    }
                })
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/actuator/health").permitAll()
                        .requestMatchers("/api/v1/auth/login", "/api/v1/auth/refresh", "/api/v1/auth/logout").permitAll()
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter(rbacAuthorityService))))
                .addFilterBefore(tenantContextFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    /**
     * Creates a JwtDecoder that verifies RS256 signatures using the configured
     * public key (classpath dev key by default; file path or secret in prod via
     * {@code app.security.public-key-location}).
     * The LOCAL_DEV_TOKEN shortcut is only honored when
     * {@code app.security.allow-dev-token=true} (local/test profiles).
     * Production must set it to false and use a real JWKS/issuer instead.
     */
    @Bean
    JwtDecoder jwtDecoder() throws Exception {
        String pem = new String(publicKeyResource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        String pubKeyPem = pem
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replace("\\n", "")
                .replaceAll("\\s", "");
        byte[] encoded = Base64.getDecoder().decode(pubKeyPem);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(encoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        RSAPublicKey publicKey = (RSAPublicKey) keyFactory.generatePublic(keySpec);

        NimbusJwtDecoder nimbusDecoder = NimbusJwtDecoder.withPublicKey(publicKey)
                .signatureAlgorithm(SignatureAlgorithm.RS256)
                .build();

        return token -> {
            if (allowDevToken && devToken != null && !devToken.isBlank() && devToken.equals(token)) {
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
            // P0 tenant hardening: JWT claim is authoritative. A mismatched
            // X-Tenant-Id header is ignored (and TenantContext is corrected)
            // so one token cannot hop across tenants.
            String jwtTenant = jwt.getClaimAsString("tenant_id");
            String headerTenant = TenantContext.get();
            String tenantId = (jwtTenant != null && !jwtTenant.isBlank())
                    ? jwtTenant.trim().toLowerCase()
                    : (headerTenant != null && !headerTenant.isBlank() ? headerTenant : "default");
            TenantContext.set(tenantId);

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
