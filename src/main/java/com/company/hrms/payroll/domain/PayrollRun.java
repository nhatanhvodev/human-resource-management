package com.company.hrms.payroll.domain;

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
@Table(name = "payroll_run")
public class PayrollRun extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(optional = false)
    @JoinColumn(name = "period_id", nullable = false)
    private PayrollPeriod payrollPeriod;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private PayrollRunStatus status;

    protected PayrollRun() {
    }

    public PayrollRun(UUID id, String tenantId, PayrollPeriod payrollPeriod, PayrollRunStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.payrollPeriod = payrollPeriod;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public PayrollRunStatus getStatus() {
        return status;
    }
}
