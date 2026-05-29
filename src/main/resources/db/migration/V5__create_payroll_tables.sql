create table if not exists payroll_period (
  id uuid primary key,
  tenant_id varchar(64) not null,
  period_from date not null,
  period_to date not null,
  status varchar(20) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);

create table if not exists payroll_run (
  id uuid primary key,
  tenant_id varchar(64) not null,
  period_id uuid not null references payroll_period(id),
  status varchar(20) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);
