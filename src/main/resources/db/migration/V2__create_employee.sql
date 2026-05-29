create table if not exists employee (
  id uuid primary key,
  tenant_id varchar(64) not null,
  employee_no varchar(50) not null,
  full_name varchar(255) not null,
  department_id uuid not null references department(id),
  hire_date date not null,
  employment_status varchar(30) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null,
  unique (tenant_id, employee_no)
);
