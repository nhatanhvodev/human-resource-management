-- V41: Comprehensive seed data for all active employees
-- Adds leave balances, time entries, documents, leave requests per department,
-- and course enrollments to ensure realistic dashboard data for every employee.

-- ── 1. LEAVE BALANCES ────────────────────────────────────────────────
-- Ensure every active employee has ANNUAL + SICK leave balance for 2026

-- ANNUAL leave balances
INSERT INTO leave_balance (id, tenant_id, employee_id, leave_type, "year", total_days, used_days, pending_days)
SELECT 'c1000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.employee_no) + 1000 AS VARCHAR), 12, '0'),
       'default', e.id, 'ANNUAL', 2026, 15, 3, 1
FROM employee e
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (
    SELECT 1 FROM leave_balance lb
    WHERE lb.employee_id = e.id AND lb.leave_type = 'ANNUAL' AND lb."year" = 2026
  );

-- SICK leave balances
INSERT INTO leave_balance (id, tenant_id, employee_id, leave_type, "year", total_days, used_days, pending_days)
SELECT 'c2000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.employee_no) + 2000 AS VARCHAR), 12, '0'),
       'default', e.id, 'SICK', 2026, 10, 2, 0
FROM employee e
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (
    SELECT 1 FROM leave_balance lb
    WHERE lb.employee_id = e.id AND lb.leave_type = 'SICK' AND lb."year" = 2026
  );

-- ── 2. TIME ENTRIES for June 2026 ────────────────────────────────────
-- Each batch uses a unique prefix to avoid UUID collisions across employees

-- Week 1: Jun 1-5 (Mon-Fri)
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.id, d.dt) + 10000 AS VARCHAR), 12, '0'),
       'default', e.id, d.dt, '08:00', '17:30', 570, 'PRESENT', now(), now()
FROM employee e
CROSS JOIN (VALUES
  ('2026-06-01'), ('2026-06-02'), ('2026-06-03'), ('2026-06-04'), ('2026-06-05')
) AS d(dt)
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM time_entry te WHERE te.employee_id = e.id AND te.date = d.dt::date);

-- Week 2: Jun 8-12
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT 'd2000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.id, d.dt) + 20000 AS VARCHAR), 12, '0'),
       'default', e.id, d.dt, '08:00', '17:30', 570, 'PRESENT', now(), now()
FROM employee e
CROSS JOIN (VALUES
  ('2026-06-08'), ('2026-06-09'), ('2026-06-10'), ('2026-06-11'), ('2026-06-12')
) AS d(dt)
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM time_entry te WHERE te.employee_id = e.id AND te.date = d.dt::date);

-- Week 3: Jun 15-19
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT 'd3000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.id, d.dt) + 30000 AS VARCHAR), 12, '0'),
       'default', e.id, d.dt, '08:00', '17:30', 570, 'PRESENT', now(), now()
FROM employee e
CROSS JOIN (VALUES
  ('2026-06-15'), ('2026-06-16'), ('2026-06-17'), ('2026-06-18'), ('2026-06-19')
) AS d(dt)
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM time_entry te WHERE te.employee_id = e.id AND te.date = d.dt::date);

-- Week 4: Jun 22-26
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT 'd4000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.id, d.dt) + 40000 AS VARCHAR), 12, '0'),
       'default', e.id, d.dt, '08:00', '17:30', 570, 'PRESENT', now(), now()
FROM employee e
CROSS JOIN (VALUES
  ('2026-06-22'), ('2026-06-23'), ('2026-06-24'), ('2026-06-25'), ('2026-06-26')
) AS d(dt)
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM time_entry te WHERE te.employee_id = e.id AND te.date = d.dt::date);

-- Week 5: Jun 29-30 (Mon-Tue)
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT 'd5000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.id, d.dt) + 50000 AS VARCHAR), 12, '0'),
       'default', e.id, d.dt, '08:00', '17:30', 570, 'PRESENT', now(), now()
FROM employee e
CROSS JOIN (VALUES
  ('2026-06-29'), ('2026-06-30')
) AS d(dt)
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM time_entry te WHERE te.employee_id = e.id AND te.date = d.dt::date);

-- July 1, 2026 (today)
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT 'd6000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.id) + 60000 AS VARCHAR), 12, '0'),
       'default', e.id, '2026-07-01', '08:00', '17:30', 570, 'PRESENT', now(), now()
FROM employee e
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM time_entry te WHERE te.employee_id = e.id AND te.date = '2026-07-01');

-- ── 3. DOCUMENTS for regular employees ────────────────────────────────

-- Contract document for non-manager employees
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at)
SELECT 'e1000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.employee_no) + 10000 AS VARCHAR), 12, '0'),
       'default', e.id,
       'hop_dong_' || e.employee_no || '.pdf',
       'HopDongLaoDong_' || e.employee_no || '.pdf',
       'application/pdf', 256000,
       'tenants/default/2026/06/hop_dong_' || e.employee_no || '.pdf',
       'CONTRACT', now()
FROM employee e
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND e.id NOT IN (
    SELECT DISTINCT e2.id FROM employee e2
    JOIN app_user au ON au.employee_id = e2.id
    JOIN security_user_role sur ON sur.user_id = au.id
    JOIN security_role sr ON sr.id = sur.role_id AND sr.name IN ('LINE_MANAGER', 'ADMIN', 'HR_MANAGER')
    WHERE e2.tenant_id = 'default'
  )
  AND NOT EXISTS (
    SELECT 1 FROM document d
    WHERE d.employee_id = e.id AND d.category = 'CONTRACT'
  );

-- CV document for non-manager employees
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at)
SELECT 'e2000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.employee_no) + 20000 AS VARCHAR), 12, '0'),
       'default', e.id,
       'cv_' || e.employee_no || '.pdf',
       'CV_' || e.full_name || '.pdf',
       'application/pdf', 128000,
       'tenants/default/2026/06/cv_' || e.employee_no || '.pdf',
       'CV', now()
FROM employee e
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND e.id NOT IN (
    SELECT DISTINCT e2.id FROM employee e2
    JOIN app_user au ON au.employee_id = e2.id
    JOIN security_user_role sur ON sur.user_id = au.id
    JOIN security_role sr ON sr.id = sur.role_id AND sr.name IN ('LINE_MANAGER', 'ADMIN', 'HR_MANAGER')
    WHERE e2.tenant_id = 'default'
  )
  AND NOT EXISTS (
    SELECT 1 FROM document d
    WHERE d.employee_id = e.id AND d.category = 'CV'
  );

-- ── 4. LEAVE REQUESTS per department ──────────────────────────────────

-- HR: employee NV000021 requests leave (approved by CEO NV000001)
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, approved_by, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000001', 'default', e.id,
       '2026-06-15', '2026-06-16', 'ANNUAL', 'Nghỉ việc riêng', 'APPROVED',
       (SELECT e2.id FROM employee e2 WHERE e2.employee_no = 'NV000001' AND e2.tenant_id = 'default'),
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000021' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-06-15');

-- IT: NV000007 sick leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000002', 'default', e.id,
       '2026-06-20', '2026-06-22', 'SICK', 'Ốm, cần nghỉ điều trị', 'APPROVED',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000007' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-06-20');

-- IT: NV000008 annual leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000003', 'default', e.id,
       '2026-07-08', '2026-07-09', 'ANNUAL', 'Đi du lịch cùng gia đình', 'PENDING',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000008' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-08');

-- FIN: NV000003 sick leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000004', 'default', e.id,
       '2026-06-10', '2026-06-10', 'SICK', 'Đi khám sức khỏe định kỳ', 'APPROVED',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000003' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-06-10');

-- SALES: NV000012 annual leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000005', 'default', e.id,
       '2026-07-03', '2026-07-04', 'ANNUAL', 'Về quê', 'PENDING',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000012' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-03');

-- SALES: NV000013 annual leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000006', 'default', e.id,
       '2026-07-20', '2026-07-21', 'ANNUAL', 'Công việc gia đình', 'PENDING',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000013' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-20');

-- MKT: NV000016 unpaid leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000007', 'default', e.id,
       '2026-06-25', '2026-06-26', 'UNPAID', 'Việc gia đình khẩn cấp', 'APPROVED',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000016' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-06-25');

-- OPS: NV000023 annual leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000008', 'default', e.id,
       '2026-07-10', '2026-07-11', 'ANNUAL', 'Nghỉ dưỡng', 'PENDING',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000023' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-10');

-- CS: NV000029 sick leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-000000000009', 'default', e.id,
       '2026-06-18', '2026-06-18', 'SICK', 'Sốt, cần nghỉ', 'APPROVED',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000029' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-06-18');

-- QA: NV000026 annual leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-00000000000a', 'default', e.id,
       '2026-07-15', '2026-07-17', 'ANNUAL', 'Nghỉ phép năm', 'PENDING',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000026' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-15');

-- RND: NV000025 rejected annual
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-00000000000b', 'default', e.id,
       '2026-07-05', '2026-07-05', 'ANNUAL', 'Việc cá nhân', 'REJECTED',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000025' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-05');

-- LEGAL: NV000028 sick leave
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, leave_type, reason, status, created_at, updated_at)
SELECT 'f4100000-0000-4000-8000-00000000000c', 'default', e.id,
       '2026-07-12', '2026-07-12', 'SICK', 'Nghỉ ốm', 'APPROVED',
       now(), now()
FROM employee e
WHERE e.employee_no = 'NV000028' AND e.tenant_id = 'default'
  AND NOT EXISTS (SELECT 1 FROM leave_request lr WHERE lr.employee_id = e.id AND lr.from_date = '2026-07-12');

-- ── 5. COURSE ENROLLMENTS ─────────────────────────────────────────────
INSERT INTO enrollment (id, tenant_id, employee_id, course_id, status, enrolled_at, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-' || LPAD(CAST(ROW_NUMBER() OVER (ORDER BY e.employee_no) + 10000 AS VARCHAR), 12, '0'),
       'default', e.id,
       (SELECT c.id FROM course c WHERE c.tenant_id = 'default' LIMIT 1),
       'IN_PROGRESS', '2026-06-01', now(), now()
FROM employee e
WHERE e.tenant_id = 'default'
  AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM enrollment en2 WHERE en2.employee_id = e.id);
