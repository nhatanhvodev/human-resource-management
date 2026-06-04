package com.company.hrms.employee.domain;

import com.company.hrms.organization.domain.Department;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "position")
public class Position extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "code", nullable = false, length = 50)
    private String code;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    protected Position() {}

    public Position(UUID id, String tenantId, String code, String title, Department department) {
        this.id = id;
        this.tenantId = tenantId;
        this.code = code;
        this.title = title;
        this.department = department;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public String getCode() { return code; }
    public String getTitle() { return title; }
    public Department getDepartment() { return department; }
}
