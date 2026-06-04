package com.company.hrms.integration.application;

import com.company.hrms.integration.domain.Notification;
import com.company.hrms.integration.infrastructure.NotificationRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class NotificationService {
    private final NotificationRepository repository;

    public NotificationService(NotificationRepository repository) { this.repository = repository; }

    @Transactional
    public Notification create(UUID recipientId, String title, String body, String type) {
        return repository.save(new Notification(UUID.randomUUID(), TenantContext.get(), recipientId, title, body, type));
    }

    @Transactional(readOnly = true)
    public Page<Notification> listMine(UUID recipientId, Boolean unreadOnly, Pageable pageable) {
        String tenantId = TenantContext.get();
        if (Boolean.TRUE.equals(unreadOnly))
            return repository.findByTenantIdAndRecipientIdAndIsReadOrderByCreatedAtDesc(tenantId, recipientId, false, pageable);
        return repository.findByTenantIdAndRecipientIdOrderByCreatedAtDesc(tenantId, recipientId, pageable);
    }

    @Transactional(readOnly = true)
    public long unreadCount(UUID recipientId) {
        return repository.countByTenantIdAndRecipientIdAndIsRead(TenantContext.get(), recipientId, true);
    }

    @Transactional
    public void markRead(UUID id) {
        repository.findById(id).ifPresent(Notification::markRead);
    }
}
