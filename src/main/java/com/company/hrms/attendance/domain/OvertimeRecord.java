package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "overtime_record")
public class OvertimeRecord extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "hours", nullable = false, precision = 4, scale = 1)
    private BigDecimal hours;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private OvertimeStatus status;

    protected OvertimeRecord() {}

    public OvertimeRecord(UUID id, String tenantId, UUID employeeId, LocalDate date, BigDecimal hours, OvertimeStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.date = date;
        this.hours = hours;
        this.status = status;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LocalDate getDate() { return date; }
    public BigDecimal getHours() { return hours; }
    public OvertimeStatus getStatus() { return status; }

    public void approve() { this.status = OvertimeStatus.APPROVED; }
    public void reject() { this.status = OvertimeStatus.REJECTED; }
}
