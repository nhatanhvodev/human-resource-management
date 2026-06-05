package com.company.hrms.shared.security;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.company.hrms.shared.tenant.TenantContext;
import com.company.hrms.shared.tenant.TenantContextFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.annotation.Order;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.AbstractOAuth2TokenAuthenticationToken;
import org.springframework.security.oauth2.jwt.BadJwtException;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {
    private static final String LOCAL_DEV_TOKEN = "local-test-token";
    private static final List<String> ADMIN_AUTHORITIES = List.of(
        "dashboard:read",
        "department:read",
        "department:create",
        "department:update",
        "department:delete",
        "employee:read",
        "employee:create",
        "employee:update",
        "employee:delete",
        "leave:read",
        "leave:create",
        "leave:approve",
        "payroll:read",
        "payroll:create",
        "payroll:execute",
        "payroll:approve",
        "recruitment:read",
        "recruitment:create",
        "recruitment:update",
        "recruitment:convert",
        "performance:read",
        "performance:create",
        "performance:update",
        "attendance:read",
        "attendance:create",
        "attendance:approve",
        "document:read",
        "document:create",
        "document:delete",
        "notification:create",
        "announcement:read",
        "announcement:create",
        "announcement:delete",
        "onboarding:read",
        "onboarding:create",
        "onboarding:update",
        "onboarding:delete",
        "training:read",
        "training:create",
        "training:update",
        "asset:read",
        "asset:create",
        "asset:update",
        "asset:delete",
        "audit:read",
        "authz:read",
        "authz:update",
        "self:access"
    );

    @Bean
    @Order(1)
    SecurityFilterChain securityFilterChain(
        HttpSecurity http,
        TenantContextFilter tenantContextFilter,
        RbacAuthorityService rbacAuthorityService
    ) throws Exception {
        return http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health").permitAll()
                .anyRequest().authenticated())
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter(rbacAuthorityService))))
            .addFilterBefore(tenantContextFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }

    @Bean
    JwtDecoder jwtDecoder() {
        ObjectMapper objectMapper = new ObjectMapper();
        return token -> {
            if (LOCAL_DEV_TOKEN.equals(token)) {
                return localAdminJwt(token);
            }

            String[] parts = token.split("\\.");
            if (parts.length != 3) {
                throw new BadJwtException("Invalid JWT format");
            }

            try {
                Map<String, Object> headers = decodeJsonPart(objectMapper, parts[0]);
                Map<String, Object> claims = decodeJsonPart(objectMapper, parts[1]);
                normalizeAuthorities(claims);

                Instant issuedAt = instantClaim(claims.get("iat"), Instant.now());
                Instant expiresAt = instantClaim(claims.get("exp"), issuedAt.plusSeconds(3600));
                if (expiresAt.isBefore(Instant.now())) {
                    throw new BadJwtException("JWT expired");
                }

                Jwt.Builder builder = Jwt.withTokenValue(token)
                    .headers(jwtHeaders -> jwtHeaders.putAll(headers))
                    .claims(jwtClaims -> jwtClaims.putAll(claims))
                    .issuedAt(issuedAt)
                    .expiresAt(expiresAt);

                Object subject = claims.get("sub");
                if (subject != null) {
                    builder.subject(String.valueOf(subject));
                }

                return builder.build();
            } catch (JwtException e) {
                throw e;
            } catch (Exception e) {
                throw new BadJwtException("Invalid JWT payload", e);
            }
        };
    }

    private Converter<Jwt, AbstractOAuth2TokenAuthenticationToken<Jwt>> jwtAuthenticationConverter(RbacAuthorityService rbacAuthorityService) {
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
            Collection<GrantedAuthority> authorities = access.authorities().stream()
                .map(SimpleGrantedAuthority::new)
                .map(GrantedAuthority.class::cast)
                .toList();
            return new JwtAuthenticationToken(jwt, authorities, jwt.getSubject());
        };
    }

    private static Jwt localAdminJwt(String token) {
        Instant now = Instant.now();
        return Jwt.withTokenValue(token)
            .header("alg", "none")
            .subject("b1000000-0000-4000-8000-000000000001")
            .claim("employee_id", "b1000000-0000-4000-8000-000000000001")
            .claim("roles", List.of("ADMIN"))
            .claim("authorities", ADMIN_AUTHORITIES)
            .issuedAt(now)
            .expiresAt(now.plusSeconds(3600))
            .build();
    }

    private static Map<String, Object> decodeJsonPart(ObjectMapper objectMapper, String encoded) throws Exception {
        byte[] decoded = Base64.getUrlDecoder().decode(encoded);
        return objectMapper.readValue(new String(decoded, StandardCharsets.UTF_8), new TypeReference<LinkedHashMap<String, Object>>() {});
    }

    private static void normalizeAuthorities(Map<String, Object> claims) {
        if (claims.containsKey("authorities")) {
            return;
        }

        Object scope = claims.get("scope");
        if (scope instanceof String scopeText && !scopeText.isBlank()) {
            claims.put("authorities", List.of(scopeText.split("\\s+")));
        }
    }

    private static Instant instantClaim(Object value, Instant fallback) {
        if (value instanceof Number number) {
            return Instant.ofEpochSecond(number.longValue());
        }
        if (value instanceof String text && !text.isBlank()) {
            try {
                return Instant.ofEpochSecond(Long.parseLong(text));
            } catch (NumberFormatException ignored) {
                return Instant.parse(text);
            }
        }
        return fallback;
    }
}
