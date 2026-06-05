-- V31: IdP group-to-role mapping

create table if not exists security_idp_mapping (
  id uuid primary key,
  tenant_id varchar(64) not null,
  idp_group varchar(255) not null,
  role_id uuid not null references security_role(id) on delete cascade,
  unique (tenant_id, idp_group, role_id)
);

create index if not exists idx_idp_mapping_tenant on security_idp_mapping(tenant_id);
