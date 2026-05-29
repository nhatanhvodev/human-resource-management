package com.company.hrms.payroll.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "payroll_period")
public class PayrollPeriod extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "period_from", nullable = false)
    private LocalDate periodFrom;

    @Column(name = "period_to", nullable = false)
    private LocalDate periodTo;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private PayrollPeriodStatus status;

    protected PayrollPeriod() {
    }

    public PayrollPeriod(UUID id, String tenantId, LocalDate periodFrom, LocalDate periodTo, PayrollPeriodStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.periodFrom = periodFrom;
        this.periodTo = periodTo;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public PayrollPeriodStatus getStatus() {
        return status;
    }

    public boolean isClosed() {
        return status == PayrollPeriodStatus.CLOSED;
    }

    public void close() {
        this.status = PayrollPeriodStatus.CLOSED;
    }
}
