-- Normalize demo people, employee numbers, and department-scoped manager accounts.

update position set title = 'Giám đốc Điều hành', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000001';

update position set title = 'Trưởng phòng Công nghệ thông tin', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000002';

update position set title = 'Trưởng phòng Tài chính - Kế toán', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000003';

update position set title = 'Trưởng phòng Kinh doanh', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000004';

update position set title = 'Trưởng phòng Vận hành', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000006';

update position set title = 'Trưởng phòng Nhân sự', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000017';

update position set title = 'Kỹ sư Phần mềm', updated_at = now()
where id = 'a0100000-0000-4000-8000-000000000018';

update employee
set full_name = 'Trần Quốc Khánh',
    department_id = 'a1000000-0000-4000-8000-000000000011',
    position_id = 'a0100000-0000-4000-8000-000000000001',
    email = 'tran.quoc.khanh@company.vn',
    phone = '0901000001',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000001';

update employee
set full_name = 'Nguyễn Thị Bích Ngọc',
    department_id = 'a1000000-0000-4000-8000-000000000002',
    position_id = 'a0100000-0000-4000-8000-000000000018',
    email = 'nguyen.bichngoc@company.vn',
    phone = '0901000002',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000002';

update employee
set full_name = 'Lê Hoàng Minh',
    department_id = 'a1000000-0000-4000-8000-000000000003',
    position_id = 'a0100000-0000-4000-8000-000000000003',
    email = 'le.hoangminh@company.vn',
    phone = '0901000003',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000003';

update employee
set full_name = 'Phạm Đức Anh',
    department_id = 'a1000000-0000-4000-8000-000000000002',
    position_id = 'a0100000-0000-4000-8000-000000000002',
    email = 'pham.ducanh@company.vn',
    phone = '0901000004',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000004';

update employee
set full_name = 'Trần Minh Quân',
    department_id = 'a1000000-0000-4000-8000-000000000004',
    position_id = 'a0100000-0000-4000-8000-000000000004',
    email = 'tran.minhquan@company.vn',
    phone = '0901000011',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000011';

update employee
set full_name = 'Lê Thu Trang',
    department_id = 'a1000000-0000-4000-8000-000000000001',
    position_id = 'a0100000-0000-4000-8000-000000000017',
    email = 'le.thutrang@company.vn',
    phone = '0901000020',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000020';

update employee
set full_name = 'Đỗ Minh Hoàng',
    department_id = 'a1000000-0000-4000-8000-000000000006',
    position_id = 'a0100000-0000-4000-8000-000000000006',
    email = 'do.minhhoang@company.vn',
    phone = '0901000076',
    updated_at = now()
where id = 'b1000000-0000-4000-8000-000000000076';

update app_user
set display_name = e.full_name,
    employee_id = e.id,
    enabled = true,
    updated_at = now()
from employee e
where app_user.tenant_id = 'default'
  and e.tenant_id = 'default'
  and (
    (app_user.username = 'admin' and e.id = 'b1000000-0000-4000-8000-000000000001')
    or (app_user.username = 'employee002' and e.id = 'b1000000-0000-4000-8000-000000000002')
    or (app_user.username = 'hr-manager' and e.id = 'b1000000-0000-4000-8000-000000000020')
    or (app_user.username = 'line-manager' and e.id = 'b1000000-0000-4000-8000-000000000011')
  );

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, password_hash, created_at, updated_at)
select e.id, 'default', 'it-manager', e.full_name, e.id, true,
       '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu', now(), now()
from employee e
where e.id = 'b1000000-0000-4000-8000-000000000004'
  and not exists (select 1 from app_user u where u.tenant_id = 'default' and u.username = 'it-manager');

update app_user
set display_name = (select full_name from employee where id = 'b1000000-0000-4000-8000-000000000004'),
    employee_id = 'b1000000-0000-4000-8000-000000000004',
    enabled = true,
    password_hash = '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu',
    updated_at = now()
where tenant_id = 'default'
  and username = 'it-manager';

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, password_hash, created_at, updated_at)
select e.id, 'default', 'finance-manager', e.full_name, e.id, true,
       '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu', now(), now()
from employee e
where e.id = 'b1000000-0000-4000-8000-000000000003'
  and not exists (select 1 from app_user u where u.tenant_id = 'default' and u.username = 'finance-manager');

update app_user
set display_name = (select full_name from employee where id = 'b1000000-0000-4000-8000-000000000003'),
    employee_id = 'b1000000-0000-4000-8000-000000000003',
    enabled = true,
    password_hash = '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu',
    updated_at = now()
where tenant_id = 'default'
  and username = 'finance-manager';

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, password_hash, created_at, updated_at)
select e.id, 'default', 'ops-manager', e.full_name, e.id, true,
       '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu', now(), now()
from employee e
where e.id = 'b1000000-0000-4000-8000-000000000076'
  and not exists (select 1 from app_user u where u.tenant_id = 'default' and u.username = 'ops-manager');

update app_user
set display_name = (select full_name from employee where id = 'b1000000-0000-4000-8000-000000000076'),
    employee_id = 'b1000000-0000-4000-8000-000000000076',
    enabled = true,
    password_hash = '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu',
    updated_at = now()
where tenant_id = 'default'
  and username = 'ops-manager';

insert into security_user_role (user_id, role_id) values
  ('b1000000-0000-4000-8000-000000000004', 'c1000000-0000-4000-8000-000000000004'),
  ('b1000000-0000-4000-8000-000000000003', 'c1000000-0000-4000-8000-000000000004'),
  ('b1000000-0000-4000-8000-000000000076', 'c1000000-0000-4000-8000-000000000004')
on conflict do nothing;

insert into security_role_scope (id, user_id, department_id)
select 'c2000000-0000-4000-8000-000000000003', 'b1000000-0000-4000-8000-000000000003', 'a1000000-0000-4000-8000-000000000003'
where not exists (
  select 1 from security_role_scope
  where user_id = 'b1000000-0000-4000-8000-000000000003'
    and department_id = 'a1000000-0000-4000-8000-000000000003'
);

insert into security_role_scope (id, user_id, department_id)
select 'c2000000-0000-4000-8000-000000000004', 'b1000000-0000-4000-8000-000000000004', 'a1000000-0000-4000-8000-000000000002'
where not exists (
  select 1 from security_role_scope
  where user_id = 'b1000000-0000-4000-8000-000000000004'
    and department_id = 'a1000000-0000-4000-8000-000000000002'
);

insert into security_role_scope (id, user_id, department_id)
select 'c2000000-0000-4000-8000-000000000076', 'b1000000-0000-4000-8000-000000000076', 'a1000000-0000-4000-8000-000000000006'
where not exists (
  select 1 from security_role_scope
  where user_id = 'b1000000-0000-4000-8000-000000000076'
    and department_id = 'a1000000-0000-4000-8000-000000000006'
);

update security_role_scope
set department_id = 'a1000000-0000-4000-8000-000000000004'
where user_id = 'b1000000-0000-4000-8000-000000000011';

update employee
set manager_id = 'b1000000-0000-4000-8000-000000000004',
    updated_at = now()
where tenant_id = 'default'
  and department_id = 'a1000000-0000-4000-8000-000000000002'
  and id <> 'b1000000-0000-4000-8000-000000000004';

update employee
set manager_id = 'b1000000-0000-4000-8000-000000000003',
    updated_at = now()
where tenant_id = 'default'
  and department_id = 'a1000000-0000-4000-8000-000000000003'
  and id <> 'b1000000-0000-4000-8000-000000000003';

update employee
set manager_id = 'b1000000-0000-4000-8000-000000000011',
    updated_at = now()
where tenant_id = 'default'
  and department_id = 'a1000000-0000-4000-8000-000000000004'
  and id <> 'b1000000-0000-4000-8000-000000000011';

update employee
set manager_id = 'b1000000-0000-4000-8000-000000000076',
    updated_at = now()
where tenant_id = 'default'
  and department_id = 'a1000000-0000-4000-8000-000000000006'
  and id <> 'b1000000-0000-4000-8000-000000000076';

update employee
set manager_id = 'b1000000-0000-4000-8000-000000000020',
    updated_at = now()
where tenant_id = 'default'
  and department_id = 'a1000000-0000-4000-8000-000000000001'
  and id <> 'b1000000-0000-4000-8000-000000000020';

update employee
set employee_no = 'NV' || lpad(regexp_replace(employee_no, '\D', '', 'g'), 6, '0'),
    updated_at = now()
where tenant_id = 'default'
  and employee_no ~ '^EMP[0-9]+$';
