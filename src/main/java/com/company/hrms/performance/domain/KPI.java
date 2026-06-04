package com.company.hrms.performance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "kpi")
public class KPI extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "cycle_id", nullable = false)
    private AppraisalCycle cycle;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "target_score", nullable = false, precision = 5, scale = 2)
    private BigDecimal targetScore;

    @Column(name = "actual_score", precision = 5, scale = 2)
    private BigDecimal actualScore;

    @Column(name = "weight", nullable = false, precision = 5, scale = 2)
    private BigDecimal weight;

    protected KPI() {}

    public KPI(UUID id, String tenantId, UUID employeeId, AppraisalCycle cycle,
               String title, String description, BigDecimal targetScore, BigDecimal actualScore, BigDecimal weight) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.cycle = cycle;
        this.title = title;
        this.description = description;
        this.targetScore = targetScore;
        this.actualScore = actualScore;
        this.weight = weight;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public AppraisalCycle getCycle() { return cycle; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public BigDecimal getTargetScore() { return targetScore; }
    public BigDecimal getActualScore() { return actualScore; }
    public BigDecimal getWeight() { return weight; }
}
