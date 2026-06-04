package com.company.hrms.performance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "appraisal_cycle")
public class AppraisalCycle extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "cycle_type", nullable = false, length = 20)
    private CycleType cycleType;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private CycleStatus status;

    protected AppraisalCycle() {}

    public AppraisalCycle(UUID id, String tenantId, String name, CycleType cycleType,
                          LocalDate startDate, LocalDate endDate, CycleStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.name = name;
        this.cycleType = cycleType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public UUID getId() { return id; }
    public String getName() { return name; }
    public CycleType getCycleType() { return cycleType; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public CycleStatus getStatus() { return status; }
}
