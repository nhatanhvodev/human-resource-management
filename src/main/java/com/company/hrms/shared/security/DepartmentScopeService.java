package com.company.hrms.shared.security;

import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class DepartmentScopeService {
    private final JdbcTemplate jdbcTemplate;

    public DepartmentScopeService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<UUID> currentScopedDepartmentIds() {
        return currentUserId()
            .map(userId -> jdbcTemplate.queryForList(
                "select department_id from security_role_scope where user_id = ? order by department_id",
                UUID.class,
                userId
            ))
            .orElse(List.of());
    }

    private Optional<UUID> currentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!(authentication instanceof JwtAuthenticationToken jwtAuthentication)) {
            return Optional.empty();
        }

        String tenantId = TenantContext.get();
        String subject = jwtAuthentication.getToken().getSubject();
        Object employeeId = jwtAuthentication.getToken().getClaims().get("employee_id");

        return jdbcTemplate.query("""
            select id
            from app_user
            where tenant_id = ?
              and enabled = true
              and (
                id::text = ?
                or employee_id::text = ?
              )
            """, rs -> rs.next() ? Optional.of(rs.getObject("id", UUID.class)) : Optional.empty(),
            tenantId,
            subject,
            employeeId == null ? null : employeeId.toString()
        );
    }
}
