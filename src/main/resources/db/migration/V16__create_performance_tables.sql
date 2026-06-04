CREATE TABLE IF NOT EXISTS appraisal_cycle (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  name varchar(255) NOT NULL,
  cycle_type varchar(20) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'DRAFT',
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS performance_review (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  cycle_id uuid NOT NULL REFERENCES appraisal_cycle(id),
  employee_id uuid NOT NULL,
  reviewer_type varchar(20) NOT NULL,
  reviewer_id uuid,
  overall_score numeric(5, 2),
  strengths text,
  improvements text,
  status varchar(20) NOT NULL DEFAULT 'DRAFT',
  submitted_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS kpi (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL,
  cycle_id uuid NOT NULL REFERENCES appraisal_cycle(id),
  title varchar(255) NOT NULL,
  description text,
  target_score numeric(5, 2) NOT NULL,
  actual_score numeric(5, 2),
  weight numeric(5, 2) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);
