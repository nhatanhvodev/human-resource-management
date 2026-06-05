create table if not exists security_permission (
  code varchar(100) primary key,
  module varchar(50) not null,
  action varchar(50) not null,
  description varchar(255) not null
);

create table if not exists security_role (
  id uuid primary key,
  tenant_id varchar(64) not null,
  code varchar(50) not null,
  name varchar(120) not null,
  description varchar(255),
  system_role boolean not null default false,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null,
  unique (tenant_id, code)
);

create table if not exists security_role_permission (
  role_id uuid not null references security_role(id) on delete cascade,
  permission_code varchar(100) not null references security_permission(code) on delete cascade,
  primary key (role_id, permission_code)
);

create table if not exists app_user (
  id uuid primary key,
  tenant_id varchar(64) not null,
  username varchar(120) not null,
  display_name varchar(255) not null,
  employee_id uuid references employee(id),
  enabled boolean not null default true,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null,
  unique (tenant_id, username)
);

create table if not exists security_user_role (
  user_id uuid not null references app_user(id) on delete cascade,
  role_id uuid not null references security_role(id) on delete cascade,
  primary key (user_id, role_id)
);

create index if not exists idx_app_user_tenant_employee on app_user(tenant_id, employee_id);
create index if not exists idx_security_user_role_role on security_user_role(role_id);
create index if not exists idx_security_role_permission_permission on security_role_permission(permission_code);

insert into security_permission (code, module, action, description) values
  ('announcement:create', 'announcement', 'create', 'Create announcements'),
  ('announcement:delete', 'announcement', 'delete', 'Delete announcements'),
  ('announcement:read', 'announcement', 'read', 'Read announcements'),
  ('asset:create', 'asset', 'create', 'Create assets'),
  ('asset:delete', 'asset', 'delete', 'Delete assets'),
  ('asset:read', 'asset', 'read', 'Read assets'),
  ('asset:update', 'asset', 'update', 'Update assets'),
  ('attendance:approve', 'attendance', 'approve', 'Approve attendance'),
  ('attendance:create', 'attendance', 'create', 'Create attendance'),
  ('attendance:read', 'attendance', 'read', 'Read attendance'),
  ('audit:read', 'audit', 'read', 'Read audit log'),
  ('authz:read', 'authz', 'read', 'Read roles and permissions'),
  ('authz:update', 'authz', 'update', 'Update role and user assignments'),
  ('dashboard:read', 'dashboard', 'read', 'Read dashboard'),
  ('department:create', 'department', 'create', 'Create departments'),
  ('department:delete', 'department', 'delete', 'Delete departments'),
  ('department:read', 'department', 'read', 'Read departments'),
  ('department:update', 'department', 'update', 'Update departments'),
  ('document:create', 'document', 'create', 'Create documents'),
  ('document:delete', 'document', 'delete', 'Delete documents'),
  ('document:read', 'document', 'read', 'Read documents'),
  ('employee:create', 'employee', 'create', 'Create employees'),
  ('employee:read', 'employee', 'read', 'Read employees'),
  ('employee:update', 'employee', 'update', 'Update employees'),
  ('leave:approve', 'leave', 'approve', 'Approve leave'),
  ('leave:create', 'leave', 'create', 'Create leave'),
  ('leave:read', 'leave', 'read', 'Read leave'),
  ('notification:create', 'notification', 'create', 'Create notifications'),
  ('onboarding:create', 'onboarding', 'create', 'Create onboarding'),
  ('onboarding:delete', 'onboarding', 'delete', 'Delete onboarding'),
  ('onboarding:read', 'onboarding', 'read', 'Read onboarding'),
  ('onboarding:update', 'onboarding', 'update', 'Update onboarding'),
  ('payroll:approve', 'payroll', 'approve', 'Approve payroll'),
  ('payroll:create', 'payroll', 'create', 'Create payroll'),
  ('payroll:execute', 'payroll', 'execute', 'Execute payroll'),
  ('payroll:read', 'payroll', 'read', 'Read payroll'),
  ('performance:create', 'performance', 'create', 'Create performance data'),
  ('performance:read', 'performance', 'read', 'Read performance data'),
  ('performance:update', 'performance', 'update', 'Update performance data'),
  ('recruitment:convert', 'recruitment', 'convert', 'Convert applications'),
  ('recruitment:create', 'recruitment', 'create', 'Create recruitment data'),
  ('recruitment:read', 'recruitment', 'read', 'Read recruitment data'),
  ('recruitment:update', 'recruitment', 'update', 'Update recruitment data'),
  ('self:access', 'self', 'access', 'Access employee self service'),
  ('training:create', 'training', 'create', 'Create training'),
  ('training:read', 'training', 'read', 'Read training'),
  ('training:update', 'training', 'update', 'Update training');

insert into security_role (id, tenant_id, code, name, description, system_role, created_at, updated_at) values
  ('c1000000-0000-4000-8000-000000000001', 'default', 'ADMIN', 'Administrator', 'Full system administrator', true, now(), now()),
  ('c1000000-0000-4000-8000-000000000002', 'default', 'HR_MANAGER', 'HR Manager', 'HR operations manager', true, now(), now()),
  ('c1000000-0000-4000-8000-000000000003', 'default', 'EMPLOYEE', 'Employee', 'Employee self-service access', true, now(), now());

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000001', code from security_permission;

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000002', code
from security_permission
where code in (
  'announcement:create', 'announcement:delete', 'announcement:read',
  'asset:create', 'asset:delete', 'asset:read', 'asset:update',
  'attendance:approve', 'attendance:create', 'attendance:read',
  'dashboard:read',
  'department:create', 'department:delete', 'department:read', 'department:update',
  'document:create', 'document:delete', 'document:read',
  'employee:create', 'employee:read', 'employee:update',
  'leave:approve', 'leave:create', 'leave:read',
  'notification:create',
  'onboarding:create', 'onboarding:delete', 'onboarding:read', 'onboarding:update',
  'payroll:read',
  'performance:create', 'performance:read', 'performance:update',
  'recruitment:convert', 'recruitment:create', 'recruitment:read', 'recruitment:update',
  'self:access',
  'training:create', 'training:read', 'training:update'
);

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000003', code
from security_permission
where code in ('announcement:read', 'asset:read', 'document:read', 'self:access', 'training:read');

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, created_at, updated_at) values
  ('b1000000-0000-4000-8000-000000000001', 'default', 'admin', 'Nguyen Van An', 'b1000000-0000-4000-8000-000000000001', true, now(), now()),
  ('b1000000-0000-4000-8000-000000000002', 'default', 'employee002', 'Tran Thi Bich Ngoc', 'b1000000-0000-4000-8000-000000000002', true, now(), now()),
  ('b1000000-0000-4000-8000-000000000020', 'default', 'hr-manager', 'Luu Van Phong', 'b1000000-0000-4000-8000-000000000020', true, now(), now());

insert into security_user_role (user_id, role_id) values
  ('b1000000-0000-4000-8000-000000000001', 'c1000000-0000-4000-8000-000000000001'),
  ('b1000000-0000-4000-8000-000000000002', 'c1000000-0000-4000-8000-000000000003'),
  ('b1000000-0000-4000-8000-000000000020', 'c1000000-0000-4000-8000-000000000002');
