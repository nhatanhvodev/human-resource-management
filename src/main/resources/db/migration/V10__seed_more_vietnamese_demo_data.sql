-- Add another non-duplicating demo batch and normalize visible Vietnamese text.
-- This migration is additive so existing Flyway checksums remain stable.

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
UPDATE department SET name = 'Phòng Hành chính' WHERE tenant_id = 'default' AND code = 'ADMIN';
UPDATE department SET name = 'Phòng Đào tạo nội bộ' WHERE tenant_id = 'default' AND code = 'TRAINING';

UPDATE employee SET full_name = 'Nguyễn Văn An' WHERE tenant_id = 'default' AND employee_no = 'EMP001';
UPDATE employee SET full_name = 'Trần Thị Bích Ngọc' WHERE tenant_id = 'default' AND employee_no = 'EMP002';
UPDATE employee SET full_name = 'Lê Hoàng Minh' WHERE tenant_id = 'default' AND employee_no = 'EMP003';
UPDATE employee SET full_name = 'Phạm Thị Hương' WHERE tenant_id = 'default' AND employee_no = 'EMP004';
UPDATE employee SET full_name = 'Vũ Đức Anh' WHERE tenant_id = 'default' AND employee_no = 'EMP005';
UPDATE employee SET full_name = 'Đỗ Quang Huy' WHERE tenant_id = 'default' AND employee_no = 'EMP006';
UPDATE employee SET full_name = 'Ngô Thị Lan Anh' WHERE tenant_id = 'default' AND employee_no = 'EMP007';
UPDATE employee SET full_name = 'Hoàng Xuân Sơn' WHERE tenant_id = 'default' AND employee_no = 'EMP008';
UPDATE employee SET full_name = 'Bùi Khánh Duy' WHERE tenant_id = 'default' AND employee_no = 'EMP009';
UPDATE employee SET full_name = 'Đinh Thị Thu Hà' WHERE tenant_id = 'default' AND employee_no = 'EMP010';
UPDATE employee SET full_name = 'Trịnh Văn Khang' WHERE tenant_id = 'default' AND employee_no = 'EMP011';
UPDATE employee SET full_name = 'Lý Thị Mai' WHERE tenant_id = 'default' AND employee_no = 'EMP012';
UPDATE employee SET full_name = 'Dương Quốc Bảo' WHERE tenant_id = 'default' AND employee_no = 'EMP013';
UPDATE employee SET full_name = 'Tạ Thị Yến' WHERE tenant_id = 'default' AND employee_no = 'EMP014';
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
UPDATE employee SET full_name = 'Hoàng Thị Thu Trang' WHERE tenant_id = 'default' AND employee_no = 'EMP030';
UPDATE employee SET full_name = 'Nguyễn Thị Thanh Trúc' WHERE tenant_id = 'default' AND employee_no = 'EMP031';
UPDATE employee SET full_name = 'Lê Gia Bảo' WHERE tenant_id = 'default' AND employee_no = 'EMP032';
UPDATE employee SET full_name = 'Phạm Minh Châu' WHERE tenant_id = 'default' AND employee_no = 'EMP033';
UPDATE employee SET full_name = 'Trần Quốc Hưng' WHERE tenant_id = 'default' AND employee_no = 'EMP034';
UPDATE employee SET full_name = 'Võ Thị Mỹ Linh' WHERE tenant_id = 'default' AND employee_no = 'EMP035';
UPDATE employee SET full_name = 'Đặng Minh Nhật' WHERE tenant_id = 'default' AND employee_no = 'EMP036';

UPDATE candidate SET full_name = 'Nguyễn Hải Đăng' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000001';
UPDATE candidate SET full_name = 'Trần Minh Anh' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000002';
UPDATE candidate SET full_name = 'Lê Quang Khải' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000003';
UPDATE candidate SET full_name = 'Phạm Ngọc Mai' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000004';
UPDATE candidate SET full_name = 'Vũ Anh Khoa' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000005';
UPDATE candidate SET full_name = 'Đỗ Thùy Dương' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000006';
UPDATE candidate SET full_name = 'Bùi Đức Long' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000007';
UPDATE candidate SET full_name = 'Hoàng Bảo Ngân' WHERE tenant_id = 'default' AND id = 'c1000000-0000-4000-8000-000000000008';

UPDATE job_posting SET title = 'Chuyên viên tuyển dụng cấp cao' WHERE tenant_id = 'default' AND id = 'd1000000-0000-4000-8000-000000000001';
UPDATE job_posting SET title = 'Kỹ sư Backend Java' WHERE tenant_id = 'default' AND id = 'd1000000-0000-4000-8000-000000000002';
UPDATE job_posting SET title = 'Chuyên viên phân tích tài chính' WHERE tenant_id = 'default' AND id = 'd1000000-0000-4000-8000-000000000003';
UPDATE job_posting SET title = 'Nhân viên kinh doanh B2B' WHERE tenant_id = 'default' AND id = 'd1000000-0000-4000-8000-000000000004';
UPDATE job_posting SET title = 'Chuyên viên đào tạo nội bộ' WHERE tenant_id = 'default' AND id = 'd1000000-0000-4000-8000-000000000005';
UPDATE job_posting SET title = 'Kỹ sư kiểm thử tự động' WHERE tenant_id = 'default' AND id = 'd1000000-0000-4000-8000-000000000006';

INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000013','default','DATA','Phòng Dữ liệu và Phân tích', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM department WHERE tenant_id = 'default' AND code = 'DATA');

INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000014','default','PRODUCT','Phòng Sản phẩm', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM department WHERE tenant_id = 'default' AND code = 'PRODUCT');

INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000015','default','SECURITY','Phòng An toàn thông tin', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM department WHERE tenant_id = 'default' AND code = 'SECURITY');

INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000016','default','PMO','Văn phòng Quản lý dự án', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM department WHERE tenant_id = 'default' AND code = 'PMO');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000037','default','EMP037','Lâm Khánh Vy','a1000000-0000-4000-8000-000000000013','2021-03-08','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP037');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000038','default','EMP038','Nguyễn Đức Mạnh','a1000000-0000-4000-8000-000000000013','2022-05-17','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP038');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000039','default','EMP039','Trần Hữu Phước','a1000000-0000-4000-8000-000000000014','2020-10-12','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP039');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000040','default','EMP040','Phan Thảo Nguyên','a1000000-0000-4000-8000-000000000014','2023-02-20','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP040');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000041','default','EMP041','Đỗ Minh Quân','a1000000-0000-4000-8000-000000000015','2019-12-09','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP041');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000042','default','EMP042','Huỳnh Ngọc Thiện','a1000000-0000-4000-8000-000000000015','2024-01-22','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP042');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000043','default','EMP043','Vũ Thanh Tâm','a1000000-0000-4000-8000-000000000016','2018-06-25','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP043');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000044','default','EMP044','Tô Minh Hoàng','a1000000-0000-4000-8000-000000000016','2022-11-14','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP044');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000045','default','EMP045','Đặng Hồng Nhung','a1000000-0000-4000-8000-000000000001','2024-05-06','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP045');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000046','default','EMP046','Nguyễn Quỳnh Chi','a1000000-0000-4000-8000-000000000003','2021-01-18','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP046');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000047','default','EMP047','Lê Quốc Việt','a1000000-0000-4000-8000-000000000006','2020-04-27','INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP047');

INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000048','default','EMP048','Mai Gia Hân','a1000000-0000-4000-8000-000000000009','2023-09-04','ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP048');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000009','default','Nguyễn Bảo Châu', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000009');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000010','default','Trần Gia Huy', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000010');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000011','default','Lê Nhật Minh', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000011');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000012','default','Phạm Thùy Linh', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000012');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000013','default','Đặng Quốc Khánh', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000013');

INSERT INTO candidate (id, tenant_id, full_name, created_at, updated_at)
SELECT 'c1000000-0000-4000-8000-000000000014','default','Võ Kim Ngân', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM candidate WHERE id = 'c1000000-0000-4000-8000-000000000014');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000007','default','Chuyên viên phân tích dữ liệu nhân sự', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000007');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000008','default','Quản lý sản phẩm nội bộ', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000008');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000009','default','Kỹ sư an toàn ứng dụng', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000009');

INSERT INTO job_posting (id, tenant_id, title, created_at, updated_at)
SELECT 'd1000000-0000-4000-8000-000000000010','default','Điều phối viên dự án', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM job_posting WHERE id = 'd1000000-0000-4000-8000-000000000010');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000009','default','c1000000-0000-4000-8000-000000000009','d1000000-0000-4000-8000-000000000007','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000009');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000010','default','c1000000-0000-4000-8000-000000000010','d1000000-0000-4000-8000-000000000008','OFFER_ACCEPTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000010');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000011','default','c1000000-0000-4000-8000-000000000011','d1000000-0000-4000-8000-000000000009','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000011');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000012','default','c1000000-0000-4000-8000-000000000012','d1000000-0000-4000-8000-000000000010','OFFER_ACCEPTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000012');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000013','default','c1000000-0000-4000-8000-000000000013','d1000000-0000-4000-8000-000000000007','HIRED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000013');

INSERT INTO recruitment_application (id, tenant_id, candidate_id, job_posting_id, status, created_at, updated_at)
SELECT 'e1000000-0000-4000-8000-000000000014','default','c1000000-0000-4000-8000-000000000014','d1000000-0000-4000-8000-000000000008','APPLIED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM recruitment_application WHERE id = 'e1000000-0000-4000-8000-000000000014');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000009','default','b1000000-0000-4000-8000-000000000037','2026-07-06','2026-07-07','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000009');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000010','default','b1000000-0000-4000-8000-000000000039','2026-07-13','2026-07-15','APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000010');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000011','default','b1000000-0000-4000-8000-000000000041','2026-07-20','2026-07-20','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000011');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000012','default','b1000000-0000-4000-8000-000000000043','2026-06-29','2026-06-30','REJECTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000012');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000013','default','b1000000-0000-4000-8000-000000000045','2026-08-03','2026-08-05','PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000013');

INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, created_at, updated_at)
SELECT 'f1000000-0000-4000-8000-000000000014','default','b1000000-0000-4000-8000-000000000048','2026-08-10','2026-08-12','APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'f1000000-0000-4000-8000-000000000014');

INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'f2000000-0000-4000-8000-000000000004','default','2026-07-01','2026-07-31','OPEN', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'f2000000-0000-4000-8000-000000000004');

INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'f2000000-0000-4000-8000-000000000005','default','2026-08-01','2026-08-31','OPEN', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'f2000000-0000-4000-8000-000000000005');

INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'f2000000-0000-4000-8000-000000000006','default','2026-03-01','2026-03-31','CLOSED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'f2000000-0000-4000-8000-000000000006');

INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'f3000000-0000-4000-8000-000000000004','default','f2000000-0000-4000-8000-000000000004','EXECUTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'f3000000-0000-4000-8000-000000000004');

INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'f3000000-0000-4000-8000-000000000005','default','f2000000-0000-4000-8000-000000000005','EXECUTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'f3000000-0000-4000-8000-000000000005');

INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'f3000000-0000-4000-8000-000000000006','default','f2000000-0000-4000-8000-000000000006','EXECUTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'f3000000-0000-4000-8000-000000000006');
