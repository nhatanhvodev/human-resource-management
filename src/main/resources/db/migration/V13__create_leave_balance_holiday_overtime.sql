CREATE TABLE IF NOT EXISTS leave_balance (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL,
  leave_type varchar(20) NOT NULL,
  year integer NOT NULL,
  total_days integer NOT NULL,
  used_days integer NOT NULL DEFAULT 0,
  pending_days integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  UNIQUE (tenant_id, employee_id, leave_type, year)
);

CREATE TABLE IF NOT EXISTS holiday (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  name varchar(255) NOT NULL,
  date date NOT NULL,
  description text,
  is_recurring_yearly boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS overtime_record (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL,
  date date NOT NULL,
  hours numeric(4, 1) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'PENDING',
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);
