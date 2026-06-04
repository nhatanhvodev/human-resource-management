CREATE TABLE time_entry (
    id UUID PRIMARY KEY,
    tenant_id VARCHAR(64) NOT NULL,
    employee_id UUID NOT NULL,
    date DATE NOT NULL,
    clock_in TIME,
    clock_out TIME,
    total_minutes INTEGER DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
