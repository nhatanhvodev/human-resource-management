package com.company.hrms.document.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "document")
public class Document extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    @Column(name = "original_name", nullable = false, length = 255)
    private String originalName;

    @Column(name = "file_type", nullable = false, length = 100)
    private String fileType;

    @Column(name = "file_size", nullable = false)
    private Long fileSize;

    @Column(name = "storage_path", nullable = false, length = 500)
    private String storagePath;

    @Enumerated(EnumType.STRING)
    @Column(name = "category", nullable = false, length = 20)
    private DocumentCategory category;

    @Column(name = "uploaded_at", nullable = false)
    private Instant uploadedAt;

    protected Document() {}

    public Document(UUID id, String tenantId, UUID employeeId, String fileName,
                    String originalName, String fileType, Long fileSize,
                    String storagePath, DocumentCategory category) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.fileName = fileName;
        this.originalName = originalName;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.storagePath = storagePath;
        this.category = category;
        this.uploadedAt = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public String getFileName() { return fileName; }
    public String getOriginalName() { return originalName; }
    public String getFileType() { return fileType; }
    public Long getFileSize() { return fileSize; }
    public String getStoragePath() { return storagePath; }
    public DocumentCategory getCategory() { return category; }
    public Instant getUploadedAt() { return uploadedAt; }
}
