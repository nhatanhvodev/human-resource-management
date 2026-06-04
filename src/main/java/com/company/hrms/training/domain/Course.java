package com.company.hrms.training.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "course")
public class Course extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", columnDefinition = "text")
    private String description;

    @Column(name = "category", length = 100)
    private String category;

    @Column(name = "duration_hours")
    private Integer durationHours;

    @Column(name = "instructor_name", length = 255)
    private String instructorName;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    protected Course() {}

    public Course(UUID id, String tenantId, String title, String description, String category,
                  Integer durationHours, String instructorName, LocalDate startDate, LocalDate endDate) {
        this.id = id; this.tenantId = tenantId; this.title = title; this.description = description;
        this.category = category; this.durationHours = durationHours;
        this.instructorName = instructorName; this.startDate = startDate; this.endDate = endDate;
    }

    public UUID getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getCategory() { return category; }
    public Integer getDurationHours() { return durationHours; }
    public String getInstructorName() { return instructorName; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
}
