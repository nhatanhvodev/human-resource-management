package com.company.hrms.onboarding.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "onboarding_template")
public class OnboardingTemplate extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", length = 1000)
    private String description;

    protected OnboardingTemplate() {}

    public OnboardingTemplate(UUID id, String tenantId, String name, String description) {
        this.id = id; this.tenantId = tenantId; this.name = name; this.description = description;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public String getName() { return name; }
    public String getDescription() { return description; }
}
