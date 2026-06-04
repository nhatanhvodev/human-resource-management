CREATE TABLE IF NOT EXISTS salary_structure (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  basic_salary numeric(15, 2) NOT NULL,
  allowance numeric(15, 2) NOT NULL DEFAULT 0,
  deduction numeric(15, 2) NOT NULL DEFAULT 0,
  effective_from date NOT NULL,
  effective_to date,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS payslip (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  payroll_run_id uuid NOT NULL REFERENCES payroll_run(id),
  employee_id uuid NOT NULL REFERENCES employee(id),
  basic_salary numeric(15, 2) NOT NULL,
  allowance numeric(15, 2) NOT NULL DEFAULT 0,
  deduction numeric(15, 2) NOT NULL DEFAULT 0,
  overtime_pay numeric(15, 2) NOT NULL DEFAULT 0,
  net_pay numeric(15, 2) NOT NULL,
  issued_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  UNIQUE (payroll_run_id, employee_id)
);
