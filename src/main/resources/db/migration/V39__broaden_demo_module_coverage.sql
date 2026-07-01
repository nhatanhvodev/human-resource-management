-- Broaden demo coverage for user-facing HR modules.
-- The rows below are derived from existing employees/courses/payroll runs so the
-- demo remains coherent across employee, manager, HR and admin role testing.

insert into security_idp_mapping (id, tenant_id, idp_group, role_id)
select '3a900000-0000-4000-8000-000000000001'::uuid, 'default', 'hrms-admins', r.id
from security_role r
where r.tenant_id = 'default' and r.code = 'ADMIN'
  and not exists (select 1 from security_idp_mapping m where m.tenant_id = 'default' and m.idp_group = 'hrms-admins');

insert into security_idp_mapping (id, tenant_id, idp_group, role_id)
select '3a900000-0000-4000-8000-000000000002'::uuid, 'default', 'hrms-hr-managers', r.id
from security_role r
where r.tenant_id = 'default' and r.code = 'HR_MANAGER'
  and not exists (select 1 from security_idp_mapping m where m.tenant_id = 'default' and m.idp_group = 'hrms-hr-managers');

insert into security_idp_mapping (id, tenant_id, idp_group, role_id)
select '3a900000-0000-4000-8000-000000000003'::uuid, 'default', 'hrms-line-managers', r.id
from security_role r
where r.tenant_id = 'default' and r.code = 'LINE_MANAGER'
  and not exists (select 1 from security_idp_mapping m where m.tenant_id = 'default' and m.idp_group = 'hrms-line-managers');

insert into security_idp_mapping (id, tenant_id, idp_group, role_id)
select '3a900000-0000-4000-8000-000000000004'::uuid, 'default', 'hrms-employees', r.id
from security_role r
where r.tenant_id = 'default' and r.code = 'EMPLOYEE'
  and not exists (select 1 from security_idp_mapping m where m.tenant_id = 'default' and m.idp_group = 'hrms-employees');

insert into payslip (
    id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction,
    overtime_pay, net_pay, issued_at, created_at, updated_at
)
select
    ('39000000-0000-4000-8000-' || lpad(substring(e.employee_no, 3), 12, '0'))::uuid,
    e.tenant_id,
    pr.id,
    e.id,
    ss.basic_salary,
    ss.allowance,
    round(ss.basic_salary * 0.105, 2),
    case when mod(cast(substring(e.employee_no, 3) as integer), 5) = 0 then 500000 else 0 end,
    ss.basic_salary + ss.allowance
        + case when mod(cast(substring(e.employee_no, 3) as integer), 5) = 0 then 500000 else 0 end
        - round(ss.basic_salary * 0.105, 2),
    timestamp with time zone '2026-08-31 17:00:00+07',
    now(),
    now()
from employee e
join salary_structure ss on ss.tenant_id = e.tenant_id and ss.employee_id = e.id
join payroll_run pr on pr.tenant_id = e.tenant_id
join payroll_period pp on pp.tenant_id = pr.tenant_id and pp.id = pr.period_id
where e.tenant_id = 'default'
  and e.employment_status = 'ACTIVE'
  and pp.period_from = date '2026-08-01'
  and pp.period_to = date '2026-08-31'
  and not exists (
      select 1 from payslip p where p.tenant_id = e.tenant_id and p.payroll_run_id = pr.id and p.employee_id = e.id
  );

insert into time_entry (
    id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at
)
select
    ('39100000-0000-4000-8000-' || lpad(cast(w.day_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid,
    e.tenant_id,
    e.id,
    w.work_date,
    time '08:30:00',
    time '17:30:00',
    480,
    'APPROVED',
    now(),
    now()
from (
    select id, tenant_id, employee_no
    from employee
    where tenant_id = 'default' and employment_status = 'ACTIVE'
    order by employee_no
    limit 50
) e
cross join (
    values
      (1, date '2026-06-01'),
      (2, date '2026-06-02'),
      (3, date '2026-06-03'),
      (4, date '2026-06-04'),
      (5, date '2026-06-05')
) w(day_no, work_date)
where not exists (
    select 1 from time_entry t where t.id = ('39100000-0000-4000-8000-' || lpad(cast(w.day_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid
);

insert into attendance_record (
    id, tenant_id, employee_id, check_in_at, created_at, updated_at
)
select
    ('39200000-0000-4000-8000-' || lpad(cast(w.day_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid,
    e.tenant_id,
    e.id,
    w.check_in_at,
    now(),
    now()
from (
    select id, tenant_id, employee_no
    from employee
    where tenant_id = 'default' and employment_status = 'ACTIVE'
    order by employee_no
    limit 50
) e
cross join (
    values
      (1, timestamp with time zone '2026-06-01 08:27:00+07'),
      (2, timestamp with time zone '2026-06-02 08:32:00+07'),
      (3, timestamp with time zone '2026-06-03 08:25:00+07'),
      (4, timestamp with time zone '2026-06-04 08:35:00+07'),
      (5, timestamp with time zone '2026-06-05 08:29:00+07')
) w(day_no, check_in_at)
where not exists (
    select 1 from attendance_record a where a.id = ('39200000-0000-4000-8000-' || lpad(cast(w.day_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid
);

insert into enrollment (
    id, tenant_id, course_id, employee_id, progress, status, enrolled_at, created_at, updated_at
)
select
    ('39300000-0000-4000-8000-' || lpad(cast(c.course_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid,
    e.tenant_id,
    c.id,
    e.id,
    case
        when mod(cast(substring(e.employee_no, 3) as integer) + c.course_no, 5) = 0 then 100
        when mod(cast(substring(e.employee_no, 3) as integer) + c.course_no, 3) = 0 then 65
        else 20
    end,
    case
        when mod(cast(substring(e.employee_no, 3) as integer) + c.course_no, 5) = 0 then 'COMPLETED'
        when mod(cast(substring(e.employee_no, 3) as integer) + c.course_no, 3) = 0 then 'IN_PROGRESS'
        else 'ENROLLED'
    end,
    timestamp '2026-05-20 09:00:00',
    now(),
    now()
from (
    select id, tenant_id, employee_no
    from employee
    where tenant_id = 'default' and employment_status = 'ACTIVE'
    order by employee_no
    limit 60
) e
join (
    select id, tenant_id, title, row_number() over (order by title) as course_no
    from course
    where tenant_id = 'default'
) c on c.tenant_id = e.tenant_id
where mod(cast(substring(e.employee_no, 3) as integer) + c.course_no, 4) = 0
  and not exists (
      select 1 from enrollment en where en.tenant_id = e.tenant_id and en.course_id = c.id and en.employee_id = e.id
  );

insert into certification (
    id, tenant_id, employee_id, course_id, name, issued_at, expiry_date, credential_url, created_at, updated_at
)
select
    ('39400000-0000-4000-8000-' || lpad(cast(c.course_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid,
    e.tenant_id,
    e.id,
    c.id,
    'Certificate - ' || c.title,
    date '2026-05-31',
    date '2028-05-31',
    'https://training.example.local/certificates/' || e.employee_no || '/' || lpad(cast(c.course_no as varchar), 2, '0'),
    now(),
    now()
from (
    select id, tenant_id, employee_no
    from employee
    where tenant_id = 'default' and employment_status = 'ACTIVE'
    order by employee_no
    limit 60
) e
join (
    select id, tenant_id, title, row_number() over (order by title) as course_no
    from course
    where tenant_id = 'default'
) c on c.tenant_id = e.tenant_id
where mod(cast(substring(e.employee_no, 3) as integer) + c.course_no, 5) = 0
  and not exists (
      select 1 from certification cert where cert.tenant_id = e.tenant_id and cert.employee_id = e.id and cert.course_id = c.id
  );

insert into onboarding_task (
    id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at
)
select
    ('39500000-0000-4000-8000-' || lpad(cast(t.task_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid,
    e.tenant_id,
    e.id,
    t.title,
    t.description,
    case
        when t.task_no = 1 then 'DONE'
        when t.task_no = 2 then 'IN_PROGRESS'
        else 'TODO'
    end,
    case when t.task_no = 1 then timestamp with time zone '2026-06-03 10:00:00+07' else null end,
    now(),
    now()
from (
    select id, tenant_id, employee_no
    from employee
    where tenant_id = 'default' and employment_status = 'ACTIVE'
    order by hire_date desc, employee_no
    limit 20
) e
cross join (
    values
      (1, 'Complete employee profile', 'Verify personal information, contact details and emergency contact.'),
      (2, 'Review team handbook', 'Read department handbook and acknowledge key internal policies.'),
      (3, 'Meet line manager', 'Schedule a first-week check-in with the assigned line manager.')
) t(task_no, title, description)
where not exists (
    select 1 from onboarding_task ot where ot.id = ('39500000-0000-4000-8000-' || lpad(cast(t.task_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid
);

insert into notification (
    id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at
)
select
    ('39600000-0000-4000-8000-' || lpad(cast(n.notice_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid,
    e.tenant_id,
    e.id,
    n.title,
    n.body,
    n.type,
    case when mod(cast(substring(e.employee_no, 3) as integer) + n.notice_no, 2) = 0 then true else false end,
    now(),
    now()
from (
    select id, tenant_id, employee_no
    from employee
    where tenant_id = 'default' and employment_status = 'ACTIVE'
    order by employee_no
    limit 50
) e
cross join (
    values
      (1, 'Monthly payroll is ready', 'Payslip for the latest executed payroll run is available for review.', 'PAYROLL'),
      (2, 'Training reminder', 'A required training course is waiting for completion.', 'TRAINING'),
      (3, 'Leave request update', 'The latest leave request status has been updated by HR.', 'LEAVE')
) n(notice_no, title, body, type)
where not exists (
    select 1 from notification nf where nf.id = ('39600000-0000-4000-8000-' || lpad(cast(n.notice_no as varchar), 2, '0') || lpad(substring(e.employee_no, 3), 10, '0'))::uuid
);
