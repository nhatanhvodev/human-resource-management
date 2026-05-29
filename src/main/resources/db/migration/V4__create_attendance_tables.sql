create table if not exists attendance_record (
  id uuid primary key,
  tenant_id varchar(64) not null,
  employee_id uuid not null,
  check_in_at timestamp with time zone not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);

create table if not exists leave_request (
  id uuid primary key,
  tenant_id varchar(64) not null,
  employee_id uuid not null,
  from_date date not null,
  to_date date not null,
  status varchar(20) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);
