package com.company.hrms.audit.interfaces.api;

import com.company.hrms.audit.application.AuditService;
import com.company.hrms.audit.domain.AuditLog;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/audit-logs")
public class AuditController {
    private final AuditService service;

    public AuditController(AuditService service) { this.service = service; }

    @GetMapping
    @PreAuthorize("hasAuthority('audit:read')")
    public PageResponse<AuditLogResponse> list(Pageable pageable) {
        return PageResponse.from(service.list(pageable).map(AuditController::toResponse));
    }

    @GetMapping("/entity")
    @PreAuthorize("hasAuthority('audit:read')")
    public PageResponse<AuditLogResponse> listByEntity(@RequestParam String entityType, @RequestParam UUID entityId, Pageable pageable) {
        return PageResponse.from(service.listByEntity(entityType, entityId, pageable).map(AuditController::toResponse));
    }

    private static AuditLogResponse toResponse(AuditLog a) {
        return new AuditLogResponse(a.getId(), a.getActorId(), a.getAction(), a.getEntityType(),
            a.getEntityId(), a.getDetails(), a.getIpAddress(), a.getCreatedAt());
    }

    public record AuditLogResponse(UUID id, UUID actorId, String action, String entityType,
                                    UUID entityId, String details, String ipAddress, Instant createdAt) {}
}
