-- V28: Short-term RBAC — employee:delete permission + LINE_MANAGER role

insert into security_permission (code, module, action, description) values
  ('employee:delete', 'employee', 'delete', 'Delete employees')
on conflict do nothing;

insert into security_role (id, tenant_id, code, name, description, system_role, created_at, updated_at) values
  ('c1000000-0000-4000-8000-000000000004', 'default', 'LINE_MANAGER', 'Line Manager', 'Team manager with limited access', true, now(), now())
on conflict do nothing;

-- Grant employee:delete to ADMIN
insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000001', 'employee:delete'
where not exists (
  select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000001' and permission_code = 'employee:delete'
);

-- Grant employee:delete to HR_MANAGER
insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000002', 'employee:delete'
where not exists (
  select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000002' and permission_code = 'employee:delete'
);

-- Grant LINE_MANAGER permissions
insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000004', code
from security_permission
where code in (
  'dashboard:read',
  'employee:read',
  'department:read',
  'leave:read', 'leave:approve',
  'attendance:read', 'attendance:approve',
  'self:access',
  'document:read',
  'announcement:read',
  'training:read'
)
and not exists (
  select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000004' and permission_code = security_permission.code
);
