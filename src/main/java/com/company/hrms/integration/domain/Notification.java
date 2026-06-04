package com.company.hrms.integration.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "notification")
public class Notification extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "recipient_id", nullable = false)
    private UUID recipientId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "body", length = 1000)
    private String body;

    @Column(name = "type", nullable = false, length = 50)
    private String type;

    @Column(name = "is_read", nullable = false)
    private boolean isRead;

    protected Notification() {}

    public Notification(UUID id, String tenantId, UUID recipientId, String title, String body, String type) {
        this.id = id; this.tenantId = tenantId; this.recipientId = recipientId;
        this.title = title; this.body = body; this.type = type;
        this.isRead = false;
    }

    public UUID getId() { return id; }
    public UUID getRecipientId() { return recipientId; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
    public String getType() { return type; }
    public boolean isRead() { return isRead; }
    public void markRead() { this.isRead = true; }
}
