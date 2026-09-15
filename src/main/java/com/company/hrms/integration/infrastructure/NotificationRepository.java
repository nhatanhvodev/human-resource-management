package com.company.hrms.integration.infrastructure;

import com.company.hrms.integration.domain.Notification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface NotificationRepository extends JpaRepository<Notification, UUID> {
    Page<Notification> findByTenantIdOrderByCreatedAtDesc(String tenantId, Pageable pageable);
    Page<Notification> findByTenantIdAndRecipientIdOrderByCreatedAtDesc(String tenantId, UUID recipientId, Pageable pageable);
    Page<Notification> findByTenantIdAndRecipientIdAndIsReadOrderByCreatedAtDesc(String tenantId, UUID recipientId, boolean isRead, Pageable pageable);
    long countByTenantIdAndRecipientIdAndIsRead(String tenantId, UUID recipientId, boolean isRead);
}
