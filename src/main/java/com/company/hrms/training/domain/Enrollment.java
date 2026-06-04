package com.company.hrms.training.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "enrollment")
public class Enrollment extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "course_id", nullable = false)
    private UUID courseId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "progress", nullable = false)
    private int progress;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private EnrollmentStatus status;

    @Column(name = "enrolled_at", nullable = false)
    private Instant enrolledAt;

    protected Enrollment() {}

    public Enrollment(UUID id, String tenantId, UUID courseId, UUID employeeId) {
        this.id = id; this.tenantId = tenantId; this.courseId = courseId; this.employeeId = employeeId;
        this.progress = 0; this.status = EnrollmentStatus.ENROLLED; this.enrolledAt = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getCourseId() { return courseId; }
    public UUID getEmployeeId() { return employeeId; }
    public int getProgress() { return progress; }
    public EnrollmentStatus getStatus() { return status; }
    public Instant getEnrolledAt() { return enrolledAt; }

    public void updateProgress(int progress) {
        this.progress = Math.min(100, Math.max(0, progress));
        if (this.progress >= 100) this.status = EnrollmentStatus.COMPLETED;
        else if (this.progress > 0) this.status = EnrollmentStatus.IN_PROGRESS;
    }
}
