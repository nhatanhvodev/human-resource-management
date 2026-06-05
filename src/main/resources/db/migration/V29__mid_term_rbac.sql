-- V29: Mid-term RBAC -- department-scoped access + manager relationship

create table if not exists security_role_scope (
  id uuid primary key,
  user_id uuid not null references app_user(id) on delete cascade,
  department_id uuid not null references department(id) on delete cascade,
  unique (user_id, department_id)
);

create index if not exists idx_security_role_scope_user on security_role_scope(user_id);
create index if not exists idx_security_role_scope_dept on security_role_scope(department_id);

alter table employee add column if not exists manager_id uuid references employee(id);
create index if not exists idx_employee_manager on employee(manager_id);
