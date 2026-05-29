create table if not exists candidate (
  id uuid primary key,
  tenant_id varchar(64) not null,
  full_name varchar(255) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);

create table if not exists job_posting (
  id uuid primary key,
  tenant_id varchar(64) not null,
  title varchar(255) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);

create table if not exists recruitment_application (
  id uuid primary key,
  tenant_id varchar(64) not null,
  candidate_id uuid not null references candidate(id),
  job_posting_id uuid not null references job_posting(id),
  status varchar(40) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);
