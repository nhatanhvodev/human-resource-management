package com.company.hrms.organization.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "department")
public class Department extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "code", nullable = false, length = 50)
    private String code;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    protected Department() {
    }

    public Department(UUID id, String tenantId, String code, String name) {
        this.id = id;
        this.tenantId = tenantId;
        this.code = code;
        this.name = name;
    }

    public UUID getId() {
        return id;
    }

    public String getTenantId() {
        return tenantId;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public void update(String code, String name) {
        this.code = code;
        this.name = name;
    }
}
