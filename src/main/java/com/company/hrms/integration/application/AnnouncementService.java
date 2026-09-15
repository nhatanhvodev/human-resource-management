package com.company.hrms.integration.application;

import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.integration.domain.Announcement;
import com.company.hrms.integration.domain.AnnouncementPriority;
import com.company.hrms.integration.infrastructure.AnnouncementRepository;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.security.SecurityUtils;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class AnnouncementService {
    private final AnnouncementRepository repository;
    private final EmployeeRepository employeeRepository;
    private final NotificationService notificationService;

    public AnnouncementService(AnnouncementRepository repository,
                               EmployeeRepository employeeRepository,
                               NotificationService notificationService) {
        this.repository = repository;
        this.employeeRepository = employeeRepository;
        this.notificationService = notificationService;
    }

    @Transactional
    public Announcement create(String title, String content, Instant publishAt, Instant expireAt, String priority) {
        UUID authorId = SecurityUtils.getCurrentEmployeeId().orElse(null);
        Announcement announcement = repository.save(new Announcement(UUID.randomUUID(), TenantContext.get(), authorId,
            title, content, publishAt, expireAt, AnnouncementPriority.valueOf(priority)));

        employeeRepository.findAllByTenantId(TenantContext.get(), Pageable.unpaged())
            .forEach(employee -> notificationService.create(employee.getId(),
                "New Announcement: " + title,
                content != null && content.length() > 200 ? content.substring(0, 200) + "..." : content,
                "ANNOUNCEMENT", announcement.getId().toString(), null, null));

        return announcement;
    }

    @Transactional
    public Announcement update(UUID id, String title, String content, Instant publishAt, Instant expireAt, String priority) {
        Announcement a = repository.findById(id).orElseThrow(() -> new NotFoundException("Announcement not found: " + id));
        a.update(title, content, publishAt, expireAt, AnnouncementPriority.valueOf(priority));
        return repository.save(a);
    }

    @Transactional(readOnly = true)
    public Page<Announcement> list(Pageable pageable) {
        return repository.findByTenantIdOrderByCreatedAtDesc(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public List<Announcement> listActive() {
        return repository.findActive(TenantContext.get(), Instant.now());
    }

    @Transactional
    public void delete(UUID id) { repository.deleteById(id); }
}
