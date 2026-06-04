package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "holiday")
public class Holiday extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "description")
    private String description;

    @Column(name = "is_recurring_yearly", nullable = false)
    private boolean recurringYearly;

    protected Holiday() {}

    public Holiday(UUID id, String tenantId, String name, LocalDate date, String description, boolean recurringYearly) {
        this.id = id;
        this.tenantId = tenantId;
        this.name = name;
        this.date = date;
        this.description = description;
        this.recurringYearly = recurringYearly;
    }

    public UUID getId() { return id; }
    public String getName() { return name; }
    public LocalDate getDate() { return date; }
    public String getDescription() { return description; }
    public boolean isRecurringYearly() { return recurringYearly; }
}
