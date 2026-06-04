package com.company.hrms.integration.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "announcement")
public class Announcement extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "author_id", nullable = false)
    private UUID authorId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "content", columnDefinition = "text")
    private String content;

    @Column(name = "publish_at")
    private Instant publishAt;

    @Column(name = "expire_at")
    private Instant expireAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "priority", nullable = false, length = 20)
    private AnnouncementPriority priority;

    protected Announcement() {}

    public Announcement(UUID id, String tenantId, UUID authorId, String title, String content,
                        Instant publishAt, Instant expireAt, AnnouncementPriority priority) {
        this.id = id; this.tenantId = tenantId; this.authorId = authorId;
        this.title = title; this.content = content; this.publishAt = publishAt;
        this.expireAt = expireAt; this.priority = priority;
    }

    public UUID getId() { return id; }
    public UUID getAuthorId() { return authorId; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public Instant getPublishAt() { return publishAt; }
    public Instant getExpireAt() { return expireAt; }
    public AnnouncementPriority getPriority() { return priority; }

    public void update(String title, String content, Instant publishAt, Instant expireAt, AnnouncementPriority priority) {
        this.title = title;
        this.content = content;
        this.publishAt = publishAt;
        this.expireAt = expireAt;
        this.priority = priority;
    }
}
