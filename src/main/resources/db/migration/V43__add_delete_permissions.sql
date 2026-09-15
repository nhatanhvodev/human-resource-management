insert into security_permission (code, module, action, description)
select 'employee:delete', 'employee', 'delete', 'Delete employees'
where not exists (select 1 from security_permission where code = 'employee:delete');

insert into security_permission (code, module, action, description)
select 'recruitment:delete', 'recruitment', 'delete', 'Delete recruitment data'
where not exists (select 1 from security_permission where code = 'recruitment:delete');

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000001', 'employee:delete'
where not exists (select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000001' and permission_code = 'employee:delete');

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000001', 'recruitment:delete'
where not exists (select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000001' and permission_code = 'recruitment:delete');

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000002', 'employee:delete'
where not exists (select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000002' and permission_code = 'employee:delete');

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000002', 'recruitment:delete'
where not exists (select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000002' and permission_code = 'recruitment:delete');
