package com.company.hrms.asset.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "asset")
public class Asset extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "category", length = 100)
    private String category;

    @Column(name = "serial_number", length = 100)
    private String serialNumber;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private AssetStatus status;

    @Column(name = "assigned_to")
    private UUID assignedTo;

    @Column(name = "assigned_date")
    private LocalDate assignedDate;

    @Column(name = "purchase_date")
    private LocalDate purchaseDate;

    @Column(name = "purchase_price")
    private Double purchasePrice;

    protected Asset() {}

    public Asset(UUID id, String tenantId, String name, String category, String serialNumber,
                 LocalDate purchaseDate, Double purchasePrice) {
        this.id = id; this.tenantId = tenantId; this.name = name; this.category = category;
        this.serialNumber = serialNumber; this.purchaseDate = purchaseDate;
        this.purchasePrice = purchasePrice;
        this.status = AssetStatus.AVAILABLE;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public String getSerialNumber() { return serialNumber; }
    public AssetStatus getStatus() { return status; }
    public UUID getAssignedTo() { return assignedTo; }
    public LocalDate getAssignedDate() { return assignedDate; }
    public LocalDate getPurchaseDate() { return purchaseDate; }
    public Double getPurchasePrice() { return purchasePrice; }

    public void assignTo(UUID employeeId) {
        this.assignedTo = employeeId;
        this.assignedDate = LocalDate.now();
        this.status = AssetStatus.ASSIGNED;
    }

    public void unassign() {
        this.assignedTo = null;
        this.assignedDate = null;
        this.status = AssetStatus.AVAILABLE;
    }

    public void markBroken() { this.status = AssetStatus.BROKEN; }
    public void retire() { this.status = AssetStatus.RETIRED; }
}
