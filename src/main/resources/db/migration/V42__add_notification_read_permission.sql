insert into security_permission (code, module, action, description)
select 'notification:read', 'notification', 'read', 'Read all notifications'
where not exists (select 1 from security_permission where code = 'notification:read');

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000001', 'notification:read'
where not exists (select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000001' and permission_code = 'notification:read');

insert into security_role_permission (role_id, permission_code)
select 'c1000000-0000-4000-8000-000000000002', 'notification:read'
where not exists (select 1 from security_role_permission where role_id = 'c1000000-0000-4000-8000-000000000002' and permission_code = 'notification:read');
