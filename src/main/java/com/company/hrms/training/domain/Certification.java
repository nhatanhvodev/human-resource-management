package com.company.hrms.training.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "certification")
public class Certification extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "course_id")
    private UUID courseId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "issued_at", nullable = false)
    private LocalDate issuedAt;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    @Column(name = "credential_url", length = 500)
    private String credentialUrl;

    protected Certification() {}

    public Certification(UUID id, String tenantId, UUID employeeId, UUID courseId, String name,
                         LocalDate issuedAt, LocalDate expiryDate, String credentialUrl) {
        this.id = id; this.tenantId = tenantId; this.employeeId = employeeId;
        this.courseId = courseId; this.name = name; this.issuedAt = issuedAt;
        this.expiryDate = expiryDate; this.credentialUrl = credentialUrl;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public UUID getCourseId() { return courseId; }
    public String getName() { return name; }
    public LocalDate getIssuedAt() { return issuedAt; }
    public LocalDate getExpiryDate() { return expiryDate; }
    public String getCredentialUrl() { return credentialUrl; }
}
