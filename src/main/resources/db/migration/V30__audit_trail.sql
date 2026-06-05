-- V30: RBAC audit trail

create table if not exists security_audit_log (
  id uuid primary key,
  tenant_id varchar(64) not null,
  actor_id uuid not null,
  action varchar(50) not null,
  target_type varchar(50) not null,
  target_id uuid,
  detail jsonb,
  created_at timestamp with time zone not null default now()
);

create index if not exists idx_security_audit_tenant on security_audit_log(tenant_id, created_at desc);
create index if not exists idx_security_audit_actor on security_audit_log(actor_id);
