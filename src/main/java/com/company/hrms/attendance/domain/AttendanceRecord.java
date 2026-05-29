package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "attendance_record")
public class AttendanceRecord extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "check_in_at", nullable = false)
    private Instant checkInAt;

    protected AttendanceRecord() {
    }

    public AttendanceRecord(UUID id, String tenantId, UUID employeeId, Instant checkInAt) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.checkInAt = checkInAt;
    }
}
