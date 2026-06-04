package com.company.hrms.audit.infrastructure;

import com.company.hrms.audit.domain.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface AuditLogRepository extends JpaRepository<AuditLog, UUID> {
    Page<AuditLog> findByTenantIdOrderByCreatedAtDesc(String tenantId, Pageable pageable);
    Page<AuditLog> findByTenantIdAndEntityTypeAndEntityIdOrderByCreatedAtDesc(String tenantId, String entityType, UUID entityId, Pageable pageable);
}
