CREATE TABLE course (
    id UUID PRIMARY KEY,
    tenant_id VARCHAR(64) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    duration_hours INTEGER,
    instructor_name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE enrollment (
    id UUID PRIMARY KEY,
    tenant_id VARCHAR(64) NOT NULL,
    course_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    progress INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'ENROLLED',
    enrolled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE certification (
    id UUID PRIMARY KEY,
    tenant_id VARCHAR(64) NOT NULL,
    employee_id UUID NOT NULL,
    course_id UUID,
    name VARCHAR(255) NOT NULL,
    issued_at DATE NOT NULL,
    expiry_date DATE,
    credential_url VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
