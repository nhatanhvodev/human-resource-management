-- Seed a ready-to-test LINE_MANAGER account.
-- Subject/employee_id for test token: b1000000-0000-4000-8000-000000000011

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, created_at, updated_at) values
  ('b1000000-0000-4000-8000-000000000011', 'default', 'line-manager', 'Trinh Van Khang', 'b1000000-0000-4000-8000-000000000011', true, now(), now())
on conflict do nothing;

insert into security_user_role (user_id, role_id) values
  ('b1000000-0000-4000-8000-000000000011', 'c1000000-0000-4000-8000-000000000004')
on conflict do nothing;

insert into security_role_scope (id, user_id, department_id) values
  ('c2000000-0000-4000-8000-000000000011', 'b1000000-0000-4000-8000-000000000011', 'a1000000-0000-4000-8000-000000000004')
on conflict do nothing;

update employee
set manager_id = 'b1000000-0000-4000-8000-000000000011',
    updated_at = now()
where tenant_id = 'default'
  and id in (
    'b1000000-0000-4000-8000-000000000012',
    'b1000000-0000-4000-8000-000000000013',
    'b1000000-0000-4000-8000-000000000014'
  )
  and manager_id is null;
