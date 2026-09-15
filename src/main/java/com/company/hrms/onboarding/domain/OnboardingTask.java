package com.company.hrms.onboarding.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "onboarding_task")
public class OnboardingTask extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private OnboardingStatus status;

    @Column(name = "completed_at")
    private Instant completedAt;

    protected OnboardingTask() {}

    public OnboardingTask(UUID id, String tenantId, UUID employeeId, String title, String description) {
        this.id = id; this.tenantId = tenantId; this.employeeId = employeeId;
        this.title = title; this.description = description;
        this.status = OnboardingStatus.TODO;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public UUID getEmployeeId() { return employeeId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public OnboardingStatus getStatus() { return status; }
    public Instant getCompletedAt() { return completedAt; }

    public void start() { this.status = OnboardingStatus.IN_PROGRESS; }
    public void complete() { this.status = OnboardingStatus.DONE; this.completedAt = Instant.now(); }
}
