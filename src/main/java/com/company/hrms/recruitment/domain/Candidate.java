package com.company.hrms.recruitment.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "candidate")
public class Candidate extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    protected Candidate() {
    }

    public Candidate(UUID id, String tenantId, String fullName) {
        this.id = id;
        this.tenantId = tenantId;
        this.fullName = fullName;
    }

    public UUID getId() {
        return id;
    }

    public String getTenantId() {
        return tenantId;
    }

    public String getFullName() {
        return fullName;
    }

    public void updateFullName(String fullName) {
        this.fullName = fullName;
    }
}
