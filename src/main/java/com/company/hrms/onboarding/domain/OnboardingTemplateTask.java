package com.company.hrms.onboarding.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "onboarding_template_task")
public class OnboardingTemplateTask extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "template_id", nullable = false)
    private UUID templateId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", length = 1000)
    private String description;

    @Column(name = "order_index", nullable = false)
    private int orderIndex;

    protected OnboardingTemplateTask() {}

    public OnboardingTemplateTask(UUID id, String tenantId, UUID templateId, String title, String description, int orderIndex) {
        this.id = id; this.tenantId = tenantId; this.templateId = templateId;
        this.title = title; this.description = description; this.orderIndex = orderIndex;
    }

    public UUID getId() { return id; }
    public UUID getTemplateId() { return templateId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public int getOrderIndex() { return orderIndex; }
}
