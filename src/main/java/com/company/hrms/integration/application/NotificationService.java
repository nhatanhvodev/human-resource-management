package com.company.hrms.integration.application;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.integration.domain.Notification;
import com.company.hrms.integration.infrastructure.NotificationRepository;
import com.company.hrms.shared.security.SecurityUtils;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class NotificationService {
    private final NotificationRepository repository;
    private final EmployeeRepository employeeRepository;

    public NotificationService(NotificationRepository repository,
                               EmployeeRepository employeeRepository) {
        this.repository = repository;
        this.employeeRepository = employeeRepository;
    }

    @Transactional
    public Notification create(UUID recipientId, String title, String body, String type,
                                String detail, String fileUrl, String fileName) {
        UUID creatorId = resolveCreatorId();
        String creatorName = resolveCreatorName(creatorId);
        return repository.save(new Notification(UUID.randomUUID(), TenantContext.get(), recipientId,
            title, body, type, creatorId, creatorName, detail, fileUrl, fileName));
    }

    private UUID resolveCreatorId() {
        return SecurityUtils.getCurrentEmployeeId()
            .or(() -> SecurityUtils.getCurrentUserId())
            .orElse(null);
    }

    private String resolveCreatorName(UUID creatorEmployeeId) {
        String fromJwt = SecurityUtils.getCurrentUserDisplayName().orElse(null);
        if (fromJwt != null && !fromJwt.isBlank()) return fromJwt;
        if (creatorEmployeeId != null) {
            return employeeRepository.findByIdAndTenantId(creatorEmployeeId, TenantContext.get())
                .map(Employee::getFullName)
                .orElse(null);
        }
        return null;
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
        return repository.countByTenantIdAndRecipientIdAndIsRead(TenantContext.get(), recipientId, false);
    }

    @Transactional(readOnly = true)
    public Page<Notification> listAll(Pageable pageable) {
        return repository.findByTenantIdOrderByCreatedAtDesc(TenantContext.get(), pageable);
    }

    @Transactional
    public void markRead(UUID id, UUID recipientId) {
        String tenantId = TenantContext.get();
        Notification notification = repository.findById(id)
            .filter(n -> tenantId.equals(n.getTenantId()))
            .orElse(null);
        if (notification == null) return;
        if (!notification.getRecipientId().equals(recipientId)) {
            throw new AccessDeniedException("NOT_YOUR_NOTIFICATION");
        }
        notification.markRead();
    }
}
