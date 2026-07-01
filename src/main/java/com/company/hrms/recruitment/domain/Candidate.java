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

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "phone", length = 50)
    private String phone;

    @Column(name = "source", length = 100)
    private String source;

    protected Candidate() {
    }

    public Candidate(UUID id, String tenantId, String fullName, String email, String phone, String source) {
        this.id = id;
        this.tenantId = tenantId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.source = source;
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

    public String getEmail() {
        return email;
    }

    public void updateEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void updatePhone(String phone) {
        this.phone = phone;
    }

    public String getSource() {
        return source;
    }

    public void updateSource(String source) {
        this.source = source;
    }
}
