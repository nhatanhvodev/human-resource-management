package com.company.hrms.audit.interfaces.api;

import com.company.hrms.audit.application.AuditService;
import com.company.hrms.audit.domain.AuditLog;
import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/audit-logs")
public class AuditController {
    private final AuditService service;
    private final JdbcTemplate jdbcTemplate;

    public AuditController(AuditService service, JdbcTemplate jdbcTemplate) {
        this.service = service;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('audit:read')")
    public PageResponse<AuditLogResponse> list(Pageable pageable) {
        return PageResponse.from(service.list(pageable).map(this::toResponse));
    }

    @GetMapping("/entity")
    @PreAuthorize("hasAuthority('audit:read')")
    public PageResponse<AuditLogResponse> listByEntity(@RequestParam String entityType, @RequestParam UUID entityId, Pageable pageable) {
        return PageResponse.from(service.listByEntity(entityType, entityId, pageable).map(this::toResponse));
    }

    private AuditLogResponse toResponse(AuditLog a) {
        return new AuditLogResponse(a.getId(), a.getActorId(), actorName(a.getActorId()), a.getAction(), a.getEntityType(),
            a.getEntityId(), a.getDetails(), a.getIpAddress(), a.getCreatedAt());
    }

    private String actorName(UUID actorId) {
        if (actorId == null) {
            return null;
        }
        return jdbcTemplate.query("""
            select coalesce(e.full_name, u.display_name)
            from app_user u
            left join employee e on e.id = u.employee_id
            where u.tenant_id = ?
              and u.id = ?
            """, rs -> rs.next() ? rs.getString(1) : null, TenantContext.get(), actorId);
    }

    public record AuditLogResponse(UUID id, UUID actorId, String actorName, String action, String entityType,
                                    UUID entityId, String details, String ipAddress, Instant createdAt) {}
}
