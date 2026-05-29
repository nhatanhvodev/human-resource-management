package com.company.hrms.integration.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "outbox_event")
public class OutboxEvent extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "event_type", nullable = false, length = 120)
    private String eventType;

    @Column(name = "payload", nullable = false, length = 2000)
    private String payload;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private OutboxStatus status;

    protected OutboxEvent() {
    }

    public OutboxEvent(UUID id, String tenantId, String eventType, String payload, OutboxStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.eventType = eventType;
        this.payload = payload;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public OutboxStatus getStatus() {
        return status;
    }

    public String getEventType() {
        return eventType;
    }

    public String getPayload() {
        return payload;
    }

    @Override
    public Instant getCreatedAt() {
        return super.getCreatedAt();
    }

    public void markSent() {
        this.status = OutboxStatus.SENT;
    }
}
