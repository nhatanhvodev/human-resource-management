package com.company.hrms.shared.security;

import com.company.hrms.shared.tenant.TenantContextFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.time.Instant;
import java.util.List;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {
    @Bean
    @Order(1)
    SecurityFilterChain securityFilterChain(HttpSecurity http, TenantContextFilter tenantContextFilter) throws Exception {
        return http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health").permitAll()
                .anyRequest().authenticated())
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter())))
            .addFilterBefore(tenantContextFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }

    @Bean
    JwtDecoder jwtDecoder() {
        return token -> Jwt.withTokenValue(token)
            .header("alg", "none")
            .claim("authorities", List.of(
                "dashboard:read",
                "department:read",
                "department:create",
                "department:update",
                "department:delete",
                "employee:read",
                "employee:create",
                "employee:update",
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
                "self:access"))
            .subject("local-user")
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
    }

    private JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter authoritiesConverter = new JwtGrantedAuthoritiesConverter();
        authoritiesConverter.setAuthoritiesClaimName("authorities");
        authoritiesConverter.setAuthorityPrefix("");

        JwtAuthenticationConverter authenticationConverter = new JwtAuthenticationConverter();
        authenticationConverter.setJwtGrantedAuthoritiesConverter(authoritiesConverter);
        return authenticationConverter;
    }
}
