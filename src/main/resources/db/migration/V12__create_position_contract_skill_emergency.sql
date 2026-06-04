CREATE TABLE IF NOT EXISTS position (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  code varchar(50) NOT NULL,
  title varchar(255) NOT NULL,
  department_id uuid NOT NULL REFERENCES department(id),
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS employee_contract (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  contract_type varchar(20) NOT NULL,
  start_date date NOT NULL,
  end_date date,
  salary numeric(15, 2) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS employee_skill (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  skill_name varchar(100) NOT NULL,
  proficiency_level varchar(20) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS emergency_contact (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  full_name varchar(255) NOT NULL,
  relationship varchar(50) NOT NULL,
  phone varchar(20) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);
