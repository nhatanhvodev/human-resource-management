package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "leave_balance")
public class LeaveBalance extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Enumerated(EnumType.STRING)
    @Column(name = "leave_type", nullable = false, length = 20)
    private LeaveType leaveType;

    @Column(name = "\"year\"", nullable = false)
    private int year;

    @Column(name = "total_days", nullable = false)
    private int totalDays;

    @Column(name = "used_days", nullable = false)
    private int usedDays;

    @Column(name = "pending_days", nullable = false)
    private int pendingDays;

    protected LeaveBalance() {}

    public LeaveBalance(UUID id, String tenantId, UUID employeeId, LeaveType leaveType,
                        int year, int totalDays, int usedDays, int pendingDays) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.leaveType = leaveType;
        this.year = year;
        this.totalDays = totalDays;
        this.usedDays = usedDays;
        this.pendingDays = pendingDays;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LeaveType getLeaveType() { return leaveType; }
    public int getYear() { return year; }
    public int getTotalDays() { return totalDays; }
    public int getUsedDays() { return usedDays; }
    public int getPendingDays() { return pendingDays; }

    public void addPendingDays(long days) {
        this.pendingDays += (int) days;
    }

    public void reducePendingDays(long days) {
        this.pendingDays -= (int) days;
    }

    public void addUsedDays(long days) {
        this.usedDays += (int) days;
    }
}
