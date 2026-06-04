package com.company.hrms.employee.domain;

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
@Table(name = "emergency_contact")
public class EmergencyContact extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    @Column(name = "relationship", nullable = false, length = 50)
    private String relationship;

    @Column(name = "phone", nullable = false, length = 20)
    private String phone;

    protected EmergencyContact() {}

    public EmergencyContact(UUID id, String tenantId, Employee employee, String fullName, String relationship, String phone) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.fullName = fullName;
        this.relationship = relationship;
        this.phone = phone;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public String getFullName() { return fullName; }
    public String getRelationship() { return relationship; }
    public String getPhone() { return phone; }
}
