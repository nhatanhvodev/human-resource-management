-- Complete demo identities from the existing employee seed.
-- The data remains synthetic demo data, but it is derived from current employees
-- and uses consistent HR/accounting conventions instead of UUID-looking labels.

insert into position (id, tenant_id, code, title, department_id, created_at, updated_at) values
  ('a0300000-0000-4000-8000-000000000001', 'default', 'HEAD_ADMIN', 'Giám đốc Điều hành', 'a1000000-0000-4000-8000-000000000011', now(), now()),
  ('a0300000-0000-4000-8000-000000000002', 'default', 'HEAD_CS', 'Trưởng phòng Chăm sóc khách hàng', 'a1000000-0000-4000-8000-000000000009', now(), now()),
  ('a0300000-0000-4000-8000-000000000003', 'default', 'HEAD_DATA', 'Trưởng phòng Dữ liệu và Phân tích', 'a1000000-0000-4000-8000-000000000013', now(), now()),
  ('a0300000-0000-4000-8000-000000000004', 'default', 'HEAD_FIN', 'Trưởng phòng Tài chính - Kế toán', 'a1000000-0000-4000-8000-000000000003', now(), now()),
  ('a0300000-0000-4000-8000-000000000005', 'default', 'HEAD_HR', 'Trưởng phòng Nhân sự', 'a1000000-0000-4000-8000-000000000001', now(), now()),
  ('a0300000-0000-4000-8000-000000000006', 'default', 'HEAD_IT', 'Trưởng phòng Công nghệ thông tin', 'a1000000-0000-4000-8000-000000000002', now(), now()),
  ('a0300000-0000-4000-8000-000000000007', 'default', 'HEAD_LEGAL', 'Trưởng phòng Pháp chế', 'a1000000-0000-4000-8000-000000000008', now(), now()),
  ('a0300000-0000-4000-8000-000000000008', 'default', 'HEAD_MKT', 'Trưởng phòng Marketing', 'a1000000-0000-4000-8000-000000000005', now(), now()),
  ('a0300000-0000-4000-8000-000000000009', 'default', 'HEAD_OPS', 'Trưởng phòng Vận hành', 'a1000000-0000-4000-8000-000000000006', now(), now()),
  ('a0300000-0000-4000-8000-000000000010', 'default', 'HEAD_PMO', 'Trưởng Văn phòng Quản lý dự án', 'a1000000-0000-4000-8000-000000000016', now(), now()),
  ('a0300000-0000-4000-8000-000000000011', 'default', 'HEAD_PRODUCT', 'Trưởng phòng Sản phẩm', 'a1000000-0000-4000-8000-000000000014', now(), now()),
  ('a0300000-0000-4000-8000-000000000012', 'default', 'HEAD_QA', 'Trưởng phòng Đảm bảo chất lượng', 'a1000000-0000-4000-8000-000000000010', now(), now()),
  ('a0300000-0000-4000-8000-000000000013', 'default', 'HEAD_RND', 'Trưởng phòng Nghiên cứu và Phát triển', 'a1000000-0000-4000-8000-000000000007', now(), now()),
  ('a0300000-0000-4000-8000-000000000014', 'default', 'HEAD_SALES', 'Trưởng phòng Kinh doanh', 'a1000000-0000-4000-8000-000000000004', now(), now()),
  ('a0300000-0000-4000-8000-000000000015', 'default', 'HEAD_SECURITY', 'Trưởng phòng An toàn thông tin', 'a1000000-0000-4000-8000-000000000015', now(), now()),
  ('a0300000-0000-4000-8000-000000000016', 'default', 'HEAD_TRAINING', 'Trưởng phòng Đào tạo nội bộ', 'a1000000-0000-4000-8000-000000000012', now(), now()),
  ('a0400000-0000-4000-8000-000000000001', 'default', 'STAFF_ADMIN', 'Chuyên viên Hành chính', 'a1000000-0000-4000-8000-000000000011', now(), now()),
  ('a0400000-0000-4000-8000-000000000002', 'default', 'STAFF_CS', 'Chuyên viên Chăm sóc khách hàng', 'a1000000-0000-4000-8000-000000000009', now(), now()),
  ('a0400000-0000-4000-8000-000000000003', 'default', 'STAFF_DATA', 'Chuyên viên Dữ liệu và Phân tích', 'a1000000-0000-4000-8000-000000000013', now(), now()),
  ('a0400000-0000-4000-8000-000000000004', 'default', 'STAFF_FIN', 'Chuyên viên Tài chính - Kế toán', 'a1000000-0000-4000-8000-000000000003', now(), now()),
  ('a0400000-0000-4000-8000-000000000005', 'default', 'STAFF_HR', 'Chuyên viên Nhân sự', 'a1000000-0000-4000-8000-000000000001', now(), now()),
  ('a0400000-0000-4000-8000-000000000006', 'default', 'STAFF_IT', 'Kỹ sư Công nghệ thông tin', 'a1000000-0000-4000-8000-000000000002', now(), now()),
  ('a0400000-0000-4000-8000-000000000007', 'default', 'STAFF_LEGAL', 'Chuyên viên Pháp chế', 'a1000000-0000-4000-8000-000000000008', now(), now()),
  ('a0400000-0000-4000-8000-000000000008', 'default', 'STAFF_MKT', 'Chuyên viên Marketing', 'a1000000-0000-4000-8000-000000000005', now(), now()),
  ('a0400000-0000-4000-8000-000000000009', 'default', 'STAFF_OPS', 'Chuyên viên Vận hành', 'a1000000-0000-4000-8000-000000000006', now(), now()),
  ('a0400000-0000-4000-8000-000000000010', 'default', 'STAFF_PMO', 'Chuyên viên Quản lý dự án', 'a1000000-0000-4000-8000-000000000016', now(), now()),
  ('a0400000-0000-4000-8000-000000000011', 'default', 'STAFF_PRODUCT', 'Chuyên viên Sản phẩm', 'a1000000-0000-4000-8000-000000000014', now(), now()),
  ('a0400000-0000-4000-8000-000000000012', 'default', 'STAFF_QA', 'Kỹ sư Đảm bảo chất lượng', 'a1000000-0000-4000-8000-000000000010', now(), now()),
  ('a0400000-0000-4000-8000-000000000013', 'default', 'STAFF_RND', 'Chuyên viên Nghiên cứu và Phát triển', 'a1000000-0000-4000-8000-000000000007', now(), now()),
  ('a0400000-0000-4000-8000-000000000014', 'default', 'STAFF_SALES', 'Chuyên viên Kinh doanh', 'a1000000-0000-4000-8000-000000000004', now(), now()),
  ('a0400000-0000-4000-8000-000000000015', 'default', 'STAFF_SECURITY', 'Kỹ sư An toàn thông tin', 'a1000000-0000-4000-8000-000000000015', now(), now()),
  ('a0400000-0000-4000-8000-000000000016', 'default', 'STAFF_TRAINING', 'Chuyên viên Đào tạo nội bộ', 'a1000000-0000-4000-8000-000000000012', now(), now())
on conflict do nothing;

update employee
set position_id = case when employee_no = 'NV000001' then 'a0300000-0000-4000-8000-000000000001'::uuid else 'a0400000-0000-4000-8000-000000000001'::uuid end,
    manager_id = case when employee_no = 'NV000001' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000001') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'ADMIN');

update employee
set position_id = case when employee_no = 'NV000029' then 'a0300000-0000-4000-8000-000000000002'::uuid else 'a0400000-0000-4000-8000-000000000002'::uuid end,
    manager_id = case when employee_no = 'NV000029' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000029') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'CS');

update employee
set position_id = case when employee_no = 'NV000037' then 'a0300000-0000-4000-8000-000000000003'::uuid else 'a0400000-0000-4000-8000-000000000003'::uuid end,
    manager_id = case when employee_no = 'NV000037' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000037') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'DATA');

update employee
set position_id = case when employee_no = 'NV000003' then 'a0300000-0000-4000-8000-000000000004'::uuid else 'a0400000-0000-4000-8000-000000000004'::uuid end,
    manager_id = case when employee_no = 'NV000003' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000003') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'FIN');

update employee
set position_id = case when employee_no = 'NV000020' then 'a0300000-0000-4000-8000-000000000005'::uuid else 'a0400000-0000-4000-8000-000000000005'::uuid end,
    manager_id = case when employee_no = 'NV000020' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000020') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'HR');

update employee
set position_id = case when employee_no = 'NV000004' then 'a0300000-0000-4000-8000-000000000006'::uuid else 'a0400000-0000-4000-8000-000000000006'::uuid end,
    manager_id = case when employee_no = 'NV000004' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000004') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'IT');

update employee
set position_id = case when employee_no = 'NV000028' then 'a0300000-0000-4000-8000-000000000007'::uuid else 'a0400000-0000-4000-8000-000000000007'::uuid end,
    manager_id = case when employee_no = 'NV000028' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000028') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'LEGAL');

update employee
set position_id = case when employee_no = 'NV000005' then 'a0300000-0000-4000-8000-000000000008'::uuid else 'a0400000-0000-4000-8000-000000000008'::uuid end,
    manager_id = case when employee_no = 'NV000005' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000005') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'MKT');

update employee
set position_id = case when employee_no = 'NV000076' then 'a0300000-0000-4000-8000-000000000009'::uuid else 'a0400000-0000-4000-8000-000000000009'::uuid end,
    manager_id = case when employee_no = 'NV000076' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000076') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'OPS');

update employee
set position_id = case when employee_no = 'NV000043' then 'a0300000-0000-4000-8000-000000000010'::uuid else 'a0400000-0000-4000-8000-000000000010'::uuid end,
    manager_id = case when employee_no = 'NV000043' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000043') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'PMO');

update employee
set position_id = case when employee_no = 'NV000039' then 'a0300000-0000-4000-8000-000000000011'::uuid else 'a0400000-0000-4000-8000-000000000011'::uuid end,
    manager_id = case when employee_no = 'NV000039' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000039') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'PRODUCT');

update employee
set position_id = case when employee_no = 'NV000026' then 'a0300000-0000-4000-8000-000000000012'::uuid else 'a0400000-0000-4000-8000-000000000012'::uuid end,
    manager_id = case when employee_no = 'NV000026' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000026') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'QA');

update employee
set position_id = case when employee_no = 'NV000024' then 'a0300000-0000-4000-8000-000000000013'::uuid else 'a0400000-0000-4000-8000-000000000013'::uuid end,
    manager_id = case when employee_no = 'NV000024' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000024') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'RND');

update employee
set position_id = case when employee_no = 'NV000011' then 'a0300000-0000-4000-8000-000000000014'::uuid else 'a0400000-0000-4000-8000-000000000014'::uuid end,
    manager_id = case when employee_no = 'NV000011' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000011') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'SALES');

update employee
set position_id = case when employee_no = 'NV000041' then 'a0300000-0000-4000-8000-000000000015'::uuid else 'a0400000-0000-4000-8000-000000000015'::uuid end,
    manager_id = case when employee_no = 'NV000041' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000041') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'SECURITY');

update employee
set position_id = case when employee_no = 'NV000033' then 'a0300000-0000-4000-8000-000000000016'::uuid else 'a0400000-0000-4000-8000-000000000016'::uuid end,
    manager_id = case when employee_no = 'NV000033' then null else (select id from employee where tenant_id = 'default' and employee_no = 'NV000033') end,
    updated_at = now()
where tenant_id = 'default' and department_id = (select id from department where tenant_id = 'default' and code = 'TRAINING');

update app_user u
set display_name = e.full_name,
    employee_id = e.id,
    enabled = true,
    updated_at = now()
from employee e
where u.tenant_id = 'default'
  and e.tenant_id = 'default'
  and u.employee_id = e.id;

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, password_hash, created_at, updated_at)
select
  ('d1000000-0000-4000-8000-' || lpad(regexp_replace(e.employee_no, '\D', '', 'g'), 12, '0'))::uuid,
  'default',
  lower(e.employee_no),
  e.full_name,
  e.id,
  true,
  case
    when e.employee_no = 'NV000001' then '$2a$10$e.qUI24nV40WQ6F9aoNquei39xrMN2SZKOOiG6R0Wn7yaNRUkIRGC'
    when e.employee_no = 'NV000020' then '$2a$10$1C58Y6v1k4qOefFtyqzXEupOkmRcGG7C1n36IxSOywNWPvvzKuDYu'
    when e.employee_no in ('NV000003','NV000004','NV000005','NV000011','NV000024','NV000026','NV000028','NV000029','NV000033','NV000037','NV000039','NV000041','NV000043','NV000076') then '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'
    else '$2a$10$0ARSyO9LXj1VNYITaTceX.dWOyecPtJ1ZEwi6mA1JbzoK.JlDpuRi'
  end,
  now(),
  now()
from employee e
where not exists (
  select 1 from app_user u
  where u.tenant_id = 'default'
    and u.username = lower(e.employee_no)
)
  and e.tenant_id = 'default';

insert into app_user (id, tenant_id, username, display_name, employee_id, enabled, password_hash, created_at, updated_at)
select aa.user_id, 'default', aa.username, e.full_name, e.id, true, aa.password_hash, now(), now()
from (
  values
    ('e1000000-0000-4000-8000-000000000001'::uuid, 'admin', 'NV000001', '$2a$10$e.qUI24nV40WQ6F9aoNquei39xrMN2SZKOOiG6R0Wn7yaNRUkIRGC'),
    ('e1000000-0000-4000-8000-000000000002'::uuid, 'hr-manager', 'NV000020', '$2a$10$1C58Y6v1k4qOefFtyqzXEupOkmRcGG7C1n36IxSOywNWPvvzKuDYu'),
    ('e1000000-0000-4000-8000-000000000003'::uuid, 'finance-manager', 'NV000003', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000004'::uuid, 'it-manager', 'NV000004', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000005'::uuid, 'sales-manager', 'NV000011', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000006'::uuid, 'line-manager', 'NV000011', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000007'::uuid, 'ops-manager', 'NV000076', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000008'::uuid, 'cs-manager', 'NV000029', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000009'::uuid, 'data-manager', 'NV000037', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000010'::uuid, 'legal-manager', 'NV000028', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000011'::uuid, 'marketing-manager', 'NV000005', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000012'::uuid, 'pmo-manager', 'NV000043', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000013'::uuid, 'product-manager', 'NV000039', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000014'::uuid, 'qa-manager', 'NV000026', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000015'::uuid, 'rnd-manager', 'NV000024', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000016'::uuid, 'security-manager', 'NV000041', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'),
    ('e1000000-0000-4000-8000-000000000017'::uuid, 'training-manager', 'NV000033', '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu')
) as aa(user_id, username, employee_no, password_hash)
join employee e on e.tenant_id = 'default' and e.employee_no = aa.employee_no
where not exists (
  select 1 from app_user u
  where u.tenant_id = 'default'
    and u.username = aa.username
);

update app_user u
set display_name = e.full_name,
    employee_id = e.id,
    enabled = true,
    password_hash = case
      when e.employee_no = 'NV000001' then '$2a$10$e.qUI24nV40WQ6F9aoNquei39xrMN2SZKOOiG6R0Wn7yaNRUkIRGC'
      when e.employee_no = 'NV000020' then '$2a$10$1C58Y6v1k4qOefFtyqzXEupOkmRcGG7C1n36IxSOywNWPvvzKuDYu'
      when e.employee_no in ('NV000003','NV000004','NV000005','NV000011','NV000024','NV000026','NV000028','NV000029','NV000033','NV000037','NV000039','NV000041','NV000043','NV000076') then '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu'
      else '$2a$10$0ARSyO9LXj1VNYITaTceX.dWOyecPtJ1ZEwi6mA1JbzoK.JlDpuRi'
    end,
    updated_at = now()
from employee e
where u.tenant_id = 'default'
  and e.tenant_id = 'default'
  and u.username = lower(e.employee_no);

insert into security_user_role (user_id, role_id)
select u.id, r.id
from app_user u
join employee e on e.id = u.employee_id
join security_role r on r.tenant_id = u.tenant_id
where u.tenant_id = 'default'
  and (
    (u.username in ('admin', 'nv000001') and r.code = 'ADMIN')
    or (u.username in ('hr-manager', 'nv000020') and r.code = 'HR_MANAGER')
    or (u.username in (
      'finance-manager','it-manager','sales-manager','line-manager','ops-manager',
      'cs-manager','data-manager','legal-manager','marketing-manager','pmo-manager',
      'product-manager','qa-manager','rnd-manager','security-manager','training-manager',
      'nv000003','nv000004','nv000005','nv000011','nv000024','nv000026','nv000028',
      'nv000029','nv000033','nv000037','nv000039','nv000041','nv000043','nv000076'
    ) and r.code = 'LINE_MANAGER')
    or (u.username = lower(e.employee_no) and e.employee_no not in (
      'NV000001','NV000003','NV000004','NV000005','NV000011','NV000020','NV000024',
      'NV000026','NV000028','NV000029','NV000033','NV000037','NV000039','NV000041',
      'NV000043','NV000076'
    ) and r.code = 'EMPLOYEE')
  )
  and not exists (
    select 1 from security_user_role existing
    where existing.user_id = u.id
      and existing.role_id = r.id
  );

delete from security_role_scope
where user_id in (
  select u.id
  from app_user u
  where u.tenant_id = 'default'
    and u.username in (
      'finance-manager','it-manager','sales-manager','line-manager','ops-manager',
      'cs-manager','data-manager','legal-manager','marketing-manager','pmo-manager',
      'product-manager','qa-manager','rnd-manager','security-manager','training-manager',
      'nv000003','nv000004','nv000005','nv000011','nv000024','nv000026','nv000028',
      'nv000029','nv000033','nv000037','nv000039','nv000041','nv000043','nv000076'
    )
);

insert into security_role_scope (id, user_id, department_id)
select ms.scope_id, u.id, d.id
from (
  values
    ('c5000000-0000-4000-8000-000000000003'::uuid, 'finance-manager', 'FIN'),
    ('c5000000-0000-4000-8000-000000000004'::uuid, 'it-manager', 'IT'),
    ('c5000000-0000-4000-8000-000000000005'::uuid, 'sales-manager', 'SALES'),
    ('c5000000-0000-4000-8000-000000000006'::uuid, 'line-manager', 'SALES'),
    ('c5000000-0000-4000-8000-000000000007'::uuid, 'ops-manager', 'OPS'),
    ('c5000000-0000-4000-8000-000000000008'::uuid, 'cs-manager', 'CS'),
    ('c5000000-0000-4000-8000-000000000009'::uuid, 'data-manager', 'DATA'),
    ('c5000000-0000-4000-8000-000000000010'::uuid, 'legal-manager', 'LEGAL'),
    ('c5000000-0000-4000-8000-000000000011'::uuid, 'marketing-manager', 'MKT'),
    ('c5000000-0000-4000-8000-000000000012'::uuid, 'pmo-manager', 'PMO'),
    ('c5000000-0000-4000-8000-000000000013'::uuid, 'product-manager', 'PRODUCT'),
    ('c5000000-0000-4000-8000-000000000014'::uuid, 'qa-manager', 'QA'),
    ('c5000000-0000-4000-8000-000000000015'::uuid, 'rnd-manager', 'RND'),
    ('c5000000-0000-4000-8000-000000000016'::uuid, 'security-manager', 'SECURITY'),
    ('c5000000-0000-4000-8000-000000000017'::uuid, 'training-manager', 'TRAINING'),
    ('c6000000-0000-4000-8000-000000000003'::uuid, 'nv000003', 'FIN'),
    ('c6000000-0000-4000-8000-000000000004'::uuid, 'nv000004', 'IT'),
    ('c6000000-0000-4000-8000-000000000005'::uuid, 'nv000005', 'MKT'),
    ('c6000000-0000-4000-8000-000000000011'::uuid, 'nv000011', 'SALES'),
    ('c6000000-0000-4000-8000-000000000024'::uuid, 'nv000024', 'RND'),
    ('c6000000-0000-4000-8000-000000000026'::uuid, 'nv000026', 'QA'),
    ('c6000000-0000-4000-8000-000000000028'::uuid, 'nv000028', 'LEGAL'),
    ('c6000000-0000-4000-8000-000000000029'::uuid, 'nv000029', 'CS'),
    ('c6000000-0000-4000-8000-000000000033'::uuid, 'nv000033', 'TRAINING'),
    ('c6000000-0000-4000-8000-000000000037'::uuid, 'nv000037', 'DATA'),
    ('c6000000-0000-4000-8000-000000000039'::uuid, 'nv000039', 'PRODUCT'),
    ('c6000000-0000-4000-8000-000000000041'::uuid, 'nv000041', 'SECURITY'),
    ('c6000000-0000-4000-8000-000000000043'::uuid, 'nv000043', 'PMO'),
    ('c6000000-0000-4000-8000-000000000076'::uuid, 'nv000076', 'OPS')
) as ms(scope_id, username, department_code)
join app_user u on u.tenant_id = 'default' and u.username = ms.username
join department d on d.tenant_id = 'default' and d.code = ms.department_code
where not exists (
  select 1 from security_role_scope s
  where s.user_id = u.id
    and s.department_id = d.id
);

insert into employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
select
  ('f1000000-0000-4000-8000-' || lpad(regexp_replace(e.employee_no, '\D', '', 'g'), 12, '0'))::uuid,
  'default',
  e.id,
  case d.code
    when 'ADMIN' then 'Nghiệp vụ hành chính'
    when 'CS' then 'Chăm sóc khách hàng'
    when 'DATA' then 'Phân tích dữ liệu'
    when 'FIN' then 'Kế toán và tài chính'
    when 'HR' then 'Quản trị nhân sự'
    when 'IT' then 'Phát triển phần mềm'
    when 'LEGAL' then 'Pháp chế doanh nghiệp'
    when 'MKT' then 'Marketing'
    when 'OPS' then 'Vận hành'
    when 'PMO' then 'Quản lý dự án'
    when 'PRODUCT' then 'Quản lý sản phẩm'
    when 'QA' then 'Đảm bảo chất lượng'
    when 'RND' then 'Nghiên cứu và phát triển'
    when 'SALES' then 'Kinh doanh'
    when 'SECURITY' then 'An toàn thông tin'
    else 'Đào tạo nội bộ'
  end,
  'INTERMEDIATE',
  now(),
  now()
from employee e
join department d on d.id = e.department_id
where e.tenant_id = 'default'
  and not exists (
    select 1 from employee_skill s
    where s.employee_id = e.id
  );

insert into emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
select
  ('f2000000-0000-4000-8000-' || lpad(regexp_replace(e.employee_no, '\D', '', 'g'), 12, '0'))::uuid,
  'default',
  e.id,
  'Liên hệ gia đình ' || e.employee_no,
  'Gia đình',
  '09' || lpad(regexp_replace(e.employee_no, '\D', '', 'g'), 8, '0'),
  now(),
  now()
from employee e
where e.tenant_id = 'default'
  and not exists (
    select 1 from emergency_contact c
    where c.employee_id = e.id
  );
