package com.company.hrms.shared.tenant;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

@Component
public class TenantContextFilter extends OncePerRequestFilter {
    static final int MAX_TENANT_LEN = 64;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        // P0 hardening: sanitize the client-supplied tenant. Authenticated
        // requests have their tenant re-asserted from JWT claims in
        // SecurityConfig's jwtAuthenticationConverter (JWT wins on mismatch).
        String tenantId = sanitize(request.getHeader("X-Tenant-Id"));
        if (tenantId == null) {
            tenantId = "default";
        }
        TenantContext.set(tenantId);
        // P1 observability: every log line carries tenant + request id.
        MDC.put("tenantId", tenantId);
        MDC.put("requestId", UUID.randomUUID().toString().substring(0, 8));
        try {
            filterChain.doFilter(request, response);
        } finally {
            TenantContext.clear();
            MDC.clear();
        }
    }

    static String sanitize(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String t = raw.trim().toLowerCase();
        if (t.length() > MAX_TENANT_LEN || !t.matches("[a-z0-9][a-z0-9_-]*")) {
            return null;
        }
        return t;
    }
}
