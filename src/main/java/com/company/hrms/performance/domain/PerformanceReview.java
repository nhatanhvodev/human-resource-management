package com.company.hrms.performance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "performance_review")
public class PerformanceReview extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "cycle_id", nullable = false)
    private AppraisalCycle cycle;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Enumerated(EnumType.STRING)
    @Column(name = "reviewer_type", nullable = false, length = 20)
    private ReviewerType reviewerType;

    @Column(name = "reviewer_id")
    private UUID reviewerId;

    @Column(name = "overall_score", precision = 5, scale = 2)
    private BigDecimal overallScore;

    @Column(name = "strengths")
    private String strengths;

    @Column(name = "improvements")
    private String improvements;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private ReviewStatus status;

    @Column(name = "submitted_at")
    private Instant submittedAt;

    protected PerformanceReview() {}

    public PerformanceReview(UUID id, String tenantId, AppraisalCycle cycle, UUID employeeId,
                             ReviewerType reviewerType, UUID reviewerId, ReviewStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.cycle = cycle;
        this.employeeId = employeeId;
        this.reviewerType = reviewerType;
        this.reviewerId = reviewerId;
        this.status = status;
    }

    public UUID getId() { return id; }
    public AppraisalCycle getCycle() { return cycle; }
    public UUID getEmployeeId() { return employeeId; }
    public ReviewerType getReviewerType() { return reviewerType; }
    public UUID getReviewerId() { return reviewerId; }
    public BigDecimal getOverallScore() { return overallScore; }
    public String getStrengths() { return strengths; }
    public String getImprovements() { return improvements; }
    public ReviewStatus getStatus() { return status; }
    public Instant getSubmittedAt() { return submittedAt; }
}
