package com.company.hrms.recruitment.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "interview")
public class Interview extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "application_id", nullable = false)
    private UUID applicationId;

    @Column(name = "interviewer_id")
    private UUID interviewerId;

    @Column(name = "scheduled_at")
    private Instant scheduledAt;

    @Column(name = "location", length = 255)
    private String location;

    @Column(name = "meeting_link", length = 500)
    private String meetingLink;

    @Column(name = "feedback", columnDefinition = "text")
    private String feedback;

    @Column(name = "rating")
    private Integer rating;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private InterviewStatus status;

    protected Interview() {}

    public Interview(UUID id, String tenantId, UUID applicationId, UUID interviewerId,
                     Instant scheduledAt, String location, String meetingLink) {
        this.id = id; this.tenantId = tenantId; this.applicationId = applicationId;
        this.interviewerId = interviewerId; this.scheduledAt = scheduledAt;
        this.location = location; this.meetingLink = meetingLink;
        this.status = InterviewStatus.SCHEDULED;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public UUID getApplicationId() { return applicationId; }
    public UUID getInterviewerId() { return interviewerId; }
    public Instant getScheduledAt() { return scheduledAt; }
    public String getLocation() { return location; }
    public String getMeetingLink() { return meetingLink; }
    public String getFeedback() { return feedback; }
    public Integer getRating() { return rating; }
    public InterviewStatus getStatus() { return status; }

    public void addFeedback(String feedback, Integer rating) {
        this.feedback = feedback; this.rating = rating; this.status = InterviewStatus.COMPLETED;
    }

    public void cancel() { this.status = InterviewStatus.CANCELLED; }
}
