package com.company.hrms.audit.application;

import com.company.hrms.audit.domain.AuditLog;
import com.company.hrms.audit.infrastructure.AuditLogRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuditService {
    private final AuditLogRepository repository;

    public AuditService(AuditLogRepository repository) { this.repository = repository; }

    @Transactional
    public AuditLog log(UUID actorId, String action, String entityType, UUID entityId, String details, String ipAddress) {
        return repository.save(new AuditLog(UUID.randomUUID(), TenantContext.get(), actorId, action, entityType, entityId, details, ipAddress));
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> list(Pageable pageable) {
        return repository.findByTenantIdOrderByCreatedAtDesc(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> listByEntity(String entityType, UUID entityId, Pageable pageable) {
        return repository.findByTenantIdAndEntityTypeAndEntityIdOrderByCreatedAtDesc(TenantContext.get(), entityType, entityId, pageable);
    }
}
