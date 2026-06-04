package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "time_entry")
public class TimeEntry extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "clock_in")
    private LocalTime clockIn;

    @Column(name = "clock_out")
    private LocalTime clockOut;

    @Column(name = "total_minutes")
    private Integer totalMinutes;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private TimeEntryStatus status;

    protected TimeEntry() {}

    public TimeEntry(UUID id, String tenantId, UUID employeeId, LocalDate date) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.date = date;
        this.status = TimeEntryStatus.PENDING;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LocalDate getDate() { return date; }
    public LocalTime getClockIn() { return clockIn; }
    public LocalTime getClockOut() { return clockOut; }
    public Integer getTotalMinutes() { return totalMinutes; }
    public TimeEntryStatus getStatus() { return status; }

    public void clockIn(LocalTime time) { this.clockIn = time; }

    public void clockOut(LocalTime time) {
        this.clockOut = time;
        if (clockIn != null) {
            this.totalMinutes = (int) java.time.Duration.between(clockIn, time).toMinutes();
        }
    }

    public void approve() { this.status = TimeEntryStatus.APPROVED; }
    public void reject() { this.status = TimeEntryStatus.REJECTED; }
}
