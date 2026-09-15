package com.company.hrms.audit.interfaces.api;

import com.company.hrms.audit.application.AuditService;
import com.company.hrms.audit.domain.AuditLog;
import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

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
        Page<AuditLog> page = service.list(pageable);
        return buildResponse(page);
    }

    @GetMapping("/entity")
    @PreAuthorize("hasAuthority('audit:read')")
    public PageResponse<AuditLogResponse> listByEntity(@RequestParam String entityType, @RequestParam UUID entityId, Pageable pageable) {
        Page<AuditLog> page = service.listByEntity(entityType, entityId, pageable);
        return buildResponse(page);
    }

    private PageResponse<AuditLogResponse> buildResponse(Page<AuditLog> page) {
        Map<UUID, String> actorNames = loadActorNames(page.getContent());
        return PageResponse.from(page.map(a -> toResponse(a, actorNames.getOrDefault(a.getActorId(), null))));
    }

    private AuditLogResponse toResponse(AuditLog a, String actorName) {
        return new AuditLogResponse(a.getId(), a.getActorId(), actorName, a.getAction(), a.getEntityType(),
            a.getEntityId(), a.getDetails(), a.getIpAddress(), a.getCreatedAt());
    }

    private Map<UUID, String> loadActorNames(List<AuditLog> logs) {
        Set<UUID> actorIds = logs.stream()
            .map(AuditLog::getActorId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
        if (actorIds.isEmpty()) return Map.of();

        List<UUID> ids = new ArrayList<>(actorIds);
        String placeholders = ids.stream().map(id -> "?").collect(Collectors.joining(","));
        String sql = "select u.id, coalesce(e.full_name, u.display_name) " +
            "from app_user u left join employee e on e.id = u.employee_id " +
            "where u.tenant_id = ? and u.id in (" + placeholders + ")";

        Object[] params = new Object[ids.size() + 1];
        params[0] = TenantContext.get();
        for (int i = 0; i < ids.size(); i++) {
            params[i + 1] = ids.get(i);
        }

        return jdbcTemplate.query(sql, rs -> {
            Map<UUID, String> map = new HashMap<>();
            while (rs.next()) {
                map.put((UUID) rs.getObject("id"), rs.getString(2));
            }
            return map;
        }, params);
    }

    public record AuditLogResponse(UUID id, UUID actorId, String actorName, String action, String entityType,
                                    UUID entityId, String details, String ipAddress, Instant createdAt) {}
}
