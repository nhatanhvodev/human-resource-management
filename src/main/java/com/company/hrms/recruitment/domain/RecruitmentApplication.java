package com.company.hrms.recruitment.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "recruitment_application")
public class RecruitmentApplication extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "application_no", nullable = false, length = 32)
    private String applicationNo;

    @ManyToOne(optional = false)
    @JoinColumn(name = "candidate_id", nullable = false)
    private Candidate candidate;

    @ManyToOne(optional = false)
    @JoinColumn(name = "job_posting_id", nullable = false)
    private JobPosting jobPosting;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 40)
    private ApplicationStatus status;

    protected RecruitmentApplication() {
    }

    public RecruitmentApplication(UUID id, String tenantId, String applicationNo, Candidate candidate, JobPosting jobPosting, ApplicationStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.applicationNo = applicationNo;
        this.candidate = candidate;
        this.jobPosting = jobPosting;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public String getTenantId() {
        return tenantId;
    }

    public String getApplicationNo() {
        return applicationNo;
    }

    public Candidate getCandidate() {
        return candidate;
    }

    public JobPosting getJobPosting() {
        return jobPosting;
    }

    public ApplicationStatus getStatus() {
        return status;
    }

    public void setStatus(ApplicationStatus status) {
        this.status = status;
    }
}
