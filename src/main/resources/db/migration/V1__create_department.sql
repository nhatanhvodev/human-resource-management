create table if not exists department (
  id uuid primary key,
  tenant_id varchar(64) not null,
  code varchar(50) not null,
  name varchar(255) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null,
  unique (tenant_id, code)
);
