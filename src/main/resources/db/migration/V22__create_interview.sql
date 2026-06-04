CREATE TABLE interview (
    id UUID PRIMARY KEY,
    tenant_id VARCHAR(64) NOT NULL,
    application_id UUID NOT NULL,
    interviewer_id UUID,
    scheduled_at TIMESTAMP,
    location VARCHAR(255),
    meeting_link VARCHAR(500),
    feedback TEXT,
    rating INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
