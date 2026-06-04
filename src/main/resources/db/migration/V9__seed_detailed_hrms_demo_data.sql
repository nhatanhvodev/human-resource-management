-- Detailed HRMS demo data for tenant 'default'.
-- Keep this migration additive and non-duplicating for databases that already applied V7.

-- Normalize older V7 rows that were saved with broken encoding or unsupported demo statuses.
UPDATE department SET name = 'Phòng Nhân sự' WHERE tenant_id = 'default' AND code = 'HR';
UPDATE department SET name = 'Phòng Công nghệ thông tin' WHERE tenant_id = 'default' AND code = 'IT';
UPDATE department SET name = 'Phòng Tài chính - Kế toán' WHERE tenant_id = 'default' AND code = 'FIN';
UPDATE department SET name = 'Phòng Kinh doanh' WHERE tenant_id = 'default' AND code = 'SALES';
UPDATE department SET name = 'Phòng Marketing' WHERE tenant_id = 'default' AND code = 'MKT';
UPDATE department SET name = 'Phòng Vận hành' WHERE tenant_id = 'default' AND code = 'OPS';
UPDATE department SET name = 'Phòng Nghiên cứu và Phát triển' WHERE tenant_id = 'default' AND code = 'RND';
UPDATE department SET name = 'Phòng Pháp chế' WHERE tenant_id = 'default' AND code = 'LEGAL';
UPDATE department SET name = 'Phòng Chăm sóc khách hàng' WHERE tenant_id = 'default' AND code = 'CS';
UPDATE department SET name = 'Phòng Đảm bảo chất lượng' WHERE tenant_id = 'default' AND code = 'QA';

UPDATE employee SET full_name = 'Nguyễn Văn An' WHERE tenant_id = 'default' AND employee_no = 'EMP001';
UPDATE employee SET full_name = 'Trần Thị Bích Ngọc' WHERE tenant_id = 'default' AND employee_no = 'EMP002';
UPDATE employee SET full_name = 'Lê Hoàng Minh' WHERE tenant_id = 'default' AND employee_no = 'EMP003';
UPDATE employee SET full_name = 'Phạm Thị Hương' WHERE tenant_id = 'default' AND employee_no = 'EMP004';
UPDATE employee SET full_name = 'Vũ Đức Anh' WHERE tenant_id = 'default' AND employee_no = 'EMP005';
UPDATE employee SET full_name = 'Đỗ Quang Huy' WHERE tenant_id = 'default' AND employee_no = 'EMP006';
UPDATE employee SET full_name = 'Ngô Thị Lan Anh' WHERE tenant_id = 'default' AND employee_no = 'EMP007';
UPDATE employee SET full_name = 'Hoàng Xuân Sơn' WHERE tenant_id = 'default' AND employee_no = 'EMP008';
UPDATE employee SET full_name = 'Bùi Khánh Duy', employment_status = 'INACTIVE' WHERE tenant_id = 'default' AND employee_no = 'EMP009';
UPDATE employee SET full_name = 'Đinh Thị Thu Hà', employment_status = 'INACTIVE' WHERE tenant_id = 'default' AND employee_no = 'EMP010';
UPDATE employee SET full_name = 'Trịnh Văn Khang' WHERE tenant_id = 'default' AND employee_no = 'EMP011';
UPDATE employee SET full_name = 'Lý Thị Mai' WHERE tenant_id = 'default' AND employee_no = 'EMP012';
UPDATE employee SET full_name = 'Dương Quốc Bảo' WHERE tenant_id = 'default' AND employee_no = 'EMP013';
UPDATE employee SET full_name = 'Tạ Thị Yến', employment_status = 'INACTIVE' WHERE tenant_id = 'default' AND employee_no = 'EMP014';
UPDATE employee SET full_name = 'Nguyễn Minh Tú' WHERE tenant_id = 'default' AND employee_no = 'EMP015';
UPDATE employee SET full_name = 'Phan Thanh Tùng' WHERE tenant_id = 'default' AND employee_no = 'EMP016';
UPDATE employee SET full_name = 'Hồ Thị Diễm' WHERE tenant_id = 'default' AND employee_no = 'EMP017';
UPDATE employee SET full_name = 'Võ Hoài Nam' WHERE tenant_id = 'default' AND employee_no = 'EMP018';
UPDATE employee SET full_name = 'Trương Thị Thảo' WHERE tenant_id = 'default' AND employee_no = 'EMP019';
UPDATE employee SET full_name = 'Lưu Văn Phong' WHERE tenant_id = 'default' AND employee_no = 'EMP020';
UPDATE employee SET full_name = 'Mai Thị Kim Oanh' WHERE tenant_id = 'default' AND employee_no = 'EMP021';
UPDATE employee SET full_name = 'Cao Tuấn Kiệt' WHERE tenant_id = 'default' AND employee_no = 'EMP022';
UPDATE employee SET full_name = 'Đặng Thị Hiền' WHERE tenant_id = 'default' AND employee_no = 'EMP023';
UPDATE employee SET full_name = 'Ngô Quang Dũng' WHERE tenant_id = 'default' AND employee_no = 'EMP024';
UPDATE employee SET full_name = 'Bùi Thị Như Quỳnh' WHERE tenant_id = 'default' AND employee_no = 'EMP025';
UPDATE employee SET full_name = 'Nguyễn Thành Trung' WHERE tenant_id = 'default' AND employee_no = 'EMP026';
UPDATE employee SET full_name = 'Trần Thị Ái Vân' WHERE tenant_id = 'default' AND employee_no = 'EMP027';
UPDATE employee SET full_name = 'Lê Thị Ngọc Hân' WHERE tenant_id = 'default' AND employee_no = 'EMP028';
UPDATE employee SET full_name = 'Phạm Văn Toàn' WHERE tenant_id = 'default' AND employee_no = 'EMP029';
UPDATE employee SET full_name = 'Hoàng Thị Thu Trang', employment_status = 'INACTIVE' WHERE tenant_id = 'default' AND employee_no = 'EMP030';
UPDATE employee SET employment_status = 'INACTIVE' WHERE tenant_id = 'default' AND employment_status NOT IN ('ACTIVE', 'INACTIVE');

INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000011','default','ADMIN','Phòng Hành chính', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM department WHERE tenant_id = 'default' AND code = 'ADMIN');

INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000012','default','TRAINING','Phòng Đào tạo nội bộ', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM department WHERE tenant_id = 'default' AND code = 'TRAINING');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000031','default','EMP031','Nguyễn Thị Thanh Trúc','a1000000-0000-4000-8000-000000000011','2020-02-10','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP031');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000032','default','EMP032','Lê Gia Bảo','a1000000-0000-4000-8000-000000000011','2021-06-21','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP032');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000033','default','EMP033','Phạm Minh Châu','a1000000-0000-4000-8000-000000000012','2022-09-05','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP033');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000034','default','EMP034','Trần Quốc Hưng','a1000000-0000-4000-8000-000000000012','2023-01-16','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP034');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000035','default','EMP035','Võ Thị Mỹ Linh','a1000000-0000-4000-8000-000000000010','2024-04-08','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP035');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000036','default','EMP036','Đặng Minh Nhật','a1000000-0000-4000-8000-000000000006','2024-07-22','INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP036');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000001','default','Nguyễn Hải Đăng', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000001');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000002','default','Trần Minh Anh', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000002');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000003','default','Lê Quang Khải', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000003');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000004','default','Phạm Ngọc Mai', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000004');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000005','default','Vũ Anh Khoa', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000005');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000006','default','Đỗ Thùy Dương', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000006');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000007','default','Bùi Đức Long', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000007');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000008','default','Hoàng Bảo Ngân', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000008');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000001','default','Chuyên viên tuyển dụng cấp cao', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000001');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000002','default','Kỹ sư Backend Java', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000002');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000003','default','Chuyên viên phân tích tài chính', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000003');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000004','default','Nhân viên kinh doanh B2B', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000004');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000005','default','Chuyên viên đào tạo nội bộ', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000005');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000006','default','Kỹ sư kiểm thử tự động', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000006');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000001','default','c1000000-0000-4000-8000-000000000001','d1000000-0000-4000-8000-000000000002','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000001');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000002','default','c1000000-0000-4000-8000-000000000002','d1000000-0000-4000-8000-000000000001','OFFER_ACCEPTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000002');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000003','default','c1000000-0000-4000-8000-000000000003','d1000000-0000-4000-8000-000000000003','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000003');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000004','default','c1000000-0000-4000-8000-000000000004','d1000000-0000-4000-8000-000000000004','HIRED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000004');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000005','default','c1000000-0000-4000-8000-000000000005','d1000000-0000-4000-8000-000000000006','OFFER_ACCEPTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000005');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000006','default','c1000000-0000-4000-8000-000000000006','d1000000-0000-4000-8000-000000000005','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000006');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000007','default','c1000000-0000-4000-8000-000000000007','d1000000-0000-4000-8000-000000000002','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000007');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000008','default','c1000000-0000-4000-8000-000000000008','d1000000-0000-4000-8000-000000000001','OFFER_ACCEPTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000008');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000001','default','b1000000-0000-4000-8000-000000000001','2026-06-08','2026-06-10','APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000001');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000002','default','b1000000-0000-4000-8000-000000000004','2026-06-12','2026-06-12','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000002');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000003','default','b1000000-0000-4000-8000-000000000006','2026-06-15','2026-06-18','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000003');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000004','default','b1000000-0000-4000-8000-000000000012','2026-05-20','2026-05-21','REJECTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000004');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000005','default','b1000000-0000-4000-8000-000000000018','2026-07-01','2026-07-05','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000005');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000006','default','b1000000-0000-4000-8000-000000000022','2026-05-27','2026-05-29','APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000006');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000007','default','b1000000-0000-4000-8000-000000000027','2026-06-22','2026-06-23','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000007');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000008','default','b1000000-0000-4000-8000-000000000033','2026-06-24','2026-06-26','APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000008');

INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'f2000000-0000-4000-8000-000000000001','default','2026-04-01','2026-04-30','CLOSED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'f2000000-0000-4000-8000-000000000001');

INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'f2000000-0000-4000-8000-000000000002','default','2026-05-01','2026-05-31','CLOSED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'f2000000-0000-4000-8000-000000000002');

INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'f2000000-0000-4000-8000-000000000003','default','2026-06-01','2026-06-30','OPEN', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'f2000000-0000-4000-8000-000000000003');

INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'f3000000-0000-4000-8000-000000000001','default','f2000000-0000-4000-8000-000000000001','EXECUTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'f3000000-0000-4000-8000-000000000001');

INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'f3000000-0000-4000-8000-000000000002','default','f2000000-0000-4000-8000-000000000002','EXECUTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'f3000000-0000-4000-8000-000000000002');

INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'f3000000-0000-4000-8000-000000000003','default','f2000000-0000-4000-8000-000000000003','EXECUTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'f3000000-0000-4000-8000-000000000003');
