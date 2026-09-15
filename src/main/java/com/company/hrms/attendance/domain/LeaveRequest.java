package com.company.hrms.attendance.domain;

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
@Table(name = "leave_request")
public class LeaveRequest extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "from_date", nullable = false)
    private LocalDate fromDate;

    @Column(name = "to_date", nullable = false)
    private LocalDate toDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "leave_type", nullable = false, length = 20)
    private LeaveType leaveType;

    @Column(name = "reason")
    private String reason;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private LeaveStatus status;

    @Column(name = "approved_by")
    private UUID approvedBy;

    protected LeaveRequest() {
    }

    public LeaveRequest(UUID id, String tenantId, UUID employeeId, LocalDate fromDate, LocalDate toDate,
                        LeaveType leaveType, String reason, LeaveStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.leaveType = leaveType;
        this.reason = reason;
        this.status = status;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LocalDate getFromDate() { return fromDate; }
    public LocalDate getToDate() { return toDate; }
    public LeaveType getLeaveType() { return leaveType; }
    public String getReason() { return reason; }
    public LeaveStatus getStatus() { return status; }
    public UUID getApprovedBy() { return approvedBy; }

    public void approve(UUID approvedBy) { this.status = LeaveStatus.APPROVED; this.approvedBy = approvedBy; }
    public void reject(UUID rejectedBy) { this.status = LeaveStatus.REJECTED; this.approvedBy = rejectedBy; }
}
