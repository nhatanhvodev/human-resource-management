package com.company.hrms.recruitment.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "job_posting")
public class JobPosting extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "department_id")
    private UUID departmentId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private JobPostingStatus status;

    @Column(name = "salary_range_min", precision = 15, scale = 2)
    private BigDecimal salaryRangeMin;

    @Column(name = "salary_range_max", precision = 15, scale = 2)
    private BigDecimal salaryRangeMax;

    @Column(name = "requirements", columnDefinition = "TEXT")
    private String requirements;

    @Column(name = "location", length = 255)
    private String location;

    @Column(name = "headcount")
    private Integer headcount;

    protected JobPosting() {
    }

    public JobPosting(UUID id, String tenantId, String title, String description,
                      UUID departmentId, JobPostingStatus status,
                      BigDecimal salaryRangeMin, BigDecimal salaryRangeMax,
                      String requirements, String location, Integer headcount) {
        this.id = id;
        this.tenantId = tenantId;
        this.title = title;
        this.description = description;
        this.departmentId = departmentId;
        this.status = status;
        this.salaryRangeMin = salaryRangeMin;
        this.salaryRangeMax = salaryRangeMax;
        this.requirements = requirements;
        this.location = location;
        this.headcount = headcount;
    }

    public UUID getId() {
        return id;
    }

    public String getTenantId() {
        return tenantId;
    }

    public String getTitle() {
        return title;
    }

    public void updateTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void updateDescription(String description) {
        this.description = description;
    }

    public UUID getDepartmentId() {
        return departmentId;
    }

    public void updateDepartmentId(UUID departmentId) {
        this.departmentId = departmentId;
    }

    public JobPostingStatus getStatus() {
        return status;
    }

    public void updateStatus(JobPostingStatus status) {
        this.status = status;
    }

    public BigDecimal getSalaryRangeMin() {
        return salaryRangeMin;
    }

    public void updateSalaryRangeMin(BigDecimal salaryRangeMin) {
        this.salaryRangeMin = salaryRangeMin;
    }

    public BigDecimal getSalaryRangeMax() {
        return salaryRangeMax;
    }

    public void updateSalaryRangeMax(BigDecimal salaryRangeMax) {
        this.salaryRangeMax = salaryRangeMax;
    }

    public String getRequirements() {
        return requirements;
    }

    public void updateRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getLocation() {
        return location;
    }

    public void updateLocation(String location) {
        this.location = location;
    }

    public Integer getHeadcount() {
        return headcount;
    }

    public void updateHeadcount(Integer headcount) {
        this.headcount = headcount;
    }
}
