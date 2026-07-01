-- ============================================================
-- Migration V40: Mở rộng schema + Seed dữ liệu mẫu cho HRMS
-- Mục tiêu: Khắc phục 15 vấn đề từ bản test
-- ============================================================

-- ===== PHẦN 1: MỞ RỘNG SCHEMA =====

-- Job Posting mở rộng (Vấn đề #4)
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS department_id UUID;
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS status VARCHAR(30) NOT NULL DEFAULT 'OPEN';
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS salary_range_min NUMERIC(19,2);
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS salary_range_max NUMERIC(19,2);
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS requirements TEXT;
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS location VARCHAR(255);
ALTER TABLE job_posting ADD COLUMN IF NOT EXISTS headcount INT NOT NULL DEFAULT 1;

-- Notification mở rộng (Vấn đề #13)
ALTER TABLE notification ADD COLUMN IF NOT EXISTS creator_id UUID;
ALTER TABLE notification ADD COLUMN IF NOT EXISTS creator_name VARCHAR(255);
ALTER TABLE notification ADD COLUMN IF NOT EXISTS detail TEXT;
ALTER TABLE notification ADD COLUMN IF NOT EXISTS file_url VARCHAR(500);
ALTER TABLE notification ADD COLUMN IF NOT EXISTS file_name VARCHAR(255);

-- Announcement mở rộng (Vấn đề #13)
ALTER TABLE announcement ADD COLUMN IF NOT EXISTS author_name VARCHAR(255);

-- Candidate mở rộng (Vấn đề #3)
ALTER TABLE candidate ADD COLUMN IF NOT EXISTS email VARCHAR(255);
ALTER TABLE candidate ADD COLUMN IF NOT EXISTS phone VARCHAR(20);
ALTER TABLE candidate ADD COLUMN IF NOT EXISTS source VARCHAR(50) DEFAULT 'DIRECT';

-- ===== PHẦN 2: SEED OUTBOX EVENTS (30 events cho Dashboard Activities - Vấn đề #1) =====

INSERT INTO outbox_event (id, tenant_id, event_type, payload, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'default', 'EMPLOYEE_HIRED', 'Nhân viên Nguyễn Hải Đăng đã được tuyển dụng vào Phòng IT', 'SENT', '2026-06-28 09:15:00+07', '2026-06-28 09:15:00+07'),
(gen_random_uuid(), 'default', 'LEAVE_APPROVED', 'Trần Minh Anh được duyệt nghỉ phép 3 ngày (15/06-17/06)', 'SENT', '2026-06-27 14:30:00+07', '2026-06-27 14:30:00+07'),
(gen_random_uuid(), 'default', 'PAYROLL_EXECUTED', 'Đã chạy lương tháng 06/2026 cho 138 nhân viên', 'SENT', '2026-06-27 10:00:00+07', '2026-06-27 10:00:00+07'),
(gen_random_uuid(), 'default', 'COURSE_ENROLLED', '12 nhân viên đã ghi danh khóa An toàn thông tin 2026', 'SENT', '2026-06-26 16:45:00+07', '2026-06-26 16:45:00+07'),
(gen_random_uuid(), 'default', 'EMPLOYEE_UPDATED', 'Cập nhật thông tin Lê Hoàng Minh - chuyển sang Phòng Tài chính', 'SENT', '2026-06-26 11:20:00+07', '2026-06-26 11:20:00+07'),
(gen_random_uuid(), 'default', 'REVIEW_SUBMITTED', 'Đánh giá Q2-2026: 45/138 nhân viên đã hoàn thành', 'SENT', '2026-06-25 15:00:00+07', '2026-06-25 15:00:00+07'),
(gen_random_uuid(), 'default', 'ANNOUNCEMENT_POSTED', 'Thông báo: Lịch nghỉ lễ Quốc khánh 2/9', 'SENT', '2026-06-25 08:00:00+07', '2026-06-25 08:00:00+07'),
(gen_random_uuid(), 'default', 'LEAVE_REQUESTED', 'Đỗ Minh Hoàng xin nghỉ phép 2 ngày (20/06-21/06)', 'SENT', '2026-06-24 10:30:00+07', '2026-06-24 10:30:00+07'),
(gen_random_uuid(), 'default', 'ASSET_ASSIGNED', 'Bàn giao laptop Dell XPS cho nhân viên mới Phạm Gia Huy', 'SENT', '2026-06-24 09:00:00+07', '2026-06-24 09:00:00+07'),
(gen_random_uuid(), 'default', 'INTERVIEW_SCHEDULED', 'Lịch phỏng vấn ứng viên Bùi Thanh Sơn - vị trí Kỹ sư Backend', 'SENT', '2026-06-23 14:00:00+07', '2026-06-23 14:00:00+07'),
(gen_random_uuid(), 'default', 'ONBOARDING_STARTED', 'Bắt đầu onboarding cho 3 nhân viên mới tháng 6', 'SENT', '2026-06-23 08:30:00+07', '2026-06-23 08:30:00+07'),
(gen_random_uuid(), 'default', 'CERTIFICATION_ISSUED', 'Cấp chứng chỉ OKR và phản hồi hiệu quả cho 8 nhân viên', 'SENT', '2026-06-22 16:00:00+07', '2026-06-22 16:00:00+07'),
(gen_random_uuid(), 'default', 'OVERTIME_APPROVED', 'Duyệt tăng ca cho team IT - dự án ERP (20 giờ)', 'SENT', '2026-06-22 11:00:00+07', '2026-06-22 11:00:00+07'),
(gen_random_uuid(), 'default', 'LEAVE_REJECTED', 'Từ chối đơn nghỉ phép - lý do thiếu nhân sự giai đoạn cao điểm', 'SENT', '2026-06-20 15:30:00+07', '2026-06-20 15:30:00+07'),
(gen_random_uuid(), 'default', 'DOCUMENT_UPLOADED', 'Tải lên tài liệu: Hợp đồng lao động Nguyễn Minh Anh.pdf', 'SENT', '2026-06-19 14:00:00+07', '2026-06-19 14:00:00+07'),
(gen_random_uuid(), 'default', 'APPLICATION_RECEIVED', 'Nhận hồ sơ ứng tuyển - vị trí Chuyên viên tuyển dụng', 'SENT', '2026-06-18 10:30:00+07', '2026-06-18 10:30:00+07'),
(gen_random_uuid(), 'default', 'TRAINING_COMPLETED', 'Hoàn thành khóa Kỹ năng phỏng vấn theo năng lực - 15 học viên', 'SENT', '2026-06-17 17:00:00+07', '2026-06-17 17:00:00+07'),
(gen_random_uuid(), 'default', 'POSITION_CHANGED', 'Phạm Đức Anh được thăng chức lên Trưởng phòng IT', 'SENT', '2026-06-16 11:00:00+07', '2026-06-16 11:00:00+07'),
(gen_random_uuid(), 'default', 'PAYROLL_CLOSED', 'Đã chốt lương tháng 05/2026', 'SENT', '2026-06-15 16:00:00+07', '2026-06-15 16:00:00+07'),
(gen_random_uuid(), 'default', 'HOLIDAY_ADDED', 'Thêm ngày nghỉ lễ: Giỗ tổ Hùng Vương (10/3 ÂL)', 'SENT', '2026-06-10 08:00:00+07', '2026-06-10 08:00:00+07'),
(gen_random_uuid(), 'default', 'REVIEW_CYCLE_STARTED', 'Bắt đầu chu kỳ đánh giá Q2-2026', 'SENT', '2026-06-01 08:00:00+07', '2026-06-01 08:00:00+07'),
(gen_random_uuid(), 'default', 'EMPLOYEE_HIRED', 'Tuyển dụng 5 nhân viên mới đợt tháng 5', 'SENT', '2026-05-28 09:00:00+07', '2026-05-28 09:00:00+07'),
(gen_random_uuid(), 'default', 'PAYROLL_EXECUTED', 'Đã chạy lương tháng 05/2026', 'SENT', '2026-05-27 10:00:00+07', '2026-05-27 10:00:00+07'),
(gen_random_uuid(), 'default', 'COURSE_CREATED', 'Tạo khóa học mới: Kỹ năng viết báo cáo chuyên nghiệp', 'SENT', '2026-05-25 15:00:00+07', '2026-05-25 15:00:00+07'),
(gen_random_uuid(), 'default', 'ANNOUNCEMENT_POSTED', 'Thông báo: Chính sách làm việc từ xa cập nhật', 'SENT', '2026-05-20 08:00:00+07', '2026-05-20 08:00:00+07'),
(gen_random_uuid(), 'default', 'ONBOARDING_COMPLETED', 'Hoàn thành onboarding đợt tháng 5 cho 5 nhân viên mới', 'SENT', '2026-05-15 17:00:00+07', '2026-05-15 17:00:00+07'),
(gen_random_uuid(), 'default', 'SYSTEM_UPDATE', 'Cập nhật hệ thống: Nâng cấp module Đánh giá nhân sự', 'SENT', '2026-06-05 09:00:00+07', '2026-06-05 09:00:00+07'),
(gen_random_uuid(), 'default', 'ASSET_RETURNED', 'Thu hồi tài sản từ nhân viên đã nghỉ việc: MacBook Pro', 'SENT', '2026-06-04 14:00:00+07', '2026-06-04 14:00:00+07'),
(gen_random_uuid(), 'default', 'DEPARTMENT_CREATED', 'Thành lập Phòng Chuyển đổi số', 'SENT', '2026-06-21 09:00:00+07', '2026-06-21 09:00:00+07'),
(gen_random_uuid(), 'default', 'EMPLOYEE_TERMINATED', 'Chấm dứt hợp đồng nhân viên', 'SENT', '2026-06-08 10:00:00+07', '2026-06-08 10:00:00+07');

-- ===== PHẦN 3: SEED JOB POSTING DATA (Vấn đề #4) =====

UPDATE job_posting SET description = 'Chịu trách nhiệm tuyển dụng nhân sự cấp trung và cấp cao cho các phòng ban. Xây dựng chiến lược thu hút nhân tài, quản lý kênh tuyển dụng, phỏng vấn và đánh giá ứng viên.', department_id = (SELECT id FROM department WHERE code='HR' LIMIT 1), status = 'OPEN', salary_range_min = 20000000, salary_range_max = 35000000, requirements = '- Tối thiểu 3 năm kinh nghiệm tuyển dụng' || E'\n' || '- Ưu tiên có kinh nghiệm tuyển dụng IT/Fintech' || E'\n' || '- Tiếng Anh giao tiếp tốt' || E'\n' || '- Kỹ năng phỏng vấn theo năng lực (Competency-based Interview)', location = 'Hà Nội', headcount = 1 WHERE title = 'Chuyên viên tuyển dụng cấp cao';

UPDATE job_posting SET description = 'Tham gia phát triển và bảo trì hệ thống HRMS nội bộ. Làm việc với microservices architecture trên nền tảng Spring Boot, PostgreSQL, Redis.', department_id = (SELECT id FROM department WHERE code='IT' LIMIT 1), status = 'OPEN', salary_range_min = 25000000, salary_range_max = 45000000, requirements = '- Tối thiểu 2 năm kinh nghiệm Java/Spring Boot' || E'\n' || '- Thành thạo PostgreSQL, JPA/Hibernate' || E'\n' || '- Có kinh nghiệm với Redis, RabbitMQ' || E'\n' || '- Hiểu biết về microservices, REST API design', location = 'Hà Nội', headcount = 2 WHERE title = 'Kỹ sư Backend Java';

UPDATE job_posting SET description = 'Phân tích báo cáo tài chính, lập ngân sách và dự báo. Hỗ trợ Ban Giám đốc ra quyết định tài chính thông qua phân tích dữ liệu.', department_id = (SELECT id FROM department WHERE code='FIN' LIMIT 1), status = 'OPEN', salary_range_min = 18000000, salary_range_max = 30000000, requirements = '- Tốt nghiệp ĐH chuyên ngành Tài chính, Kế toán' || E'\n' || '- Tối thiểu 2 năm kinh nghiệm phân tích tài chính' || E'\n' || '- Thành thạo Excel nâng cao (Pivot, VBA)', location = 'Hà Nội', headcount = 1 WHERE title = 'Chuyên viên phân tích tài chính';

UPDATE job_posting SET description = 'Phát triển khách hàng doanh nghiệp trong lĩnh vực giải pháp nhân sự. Tư vấn, demo sản phẩm và chốt hợp đồng.', department_id = (SELECT id FROM department WHERE code='SALES' LIMIT 1), status = 'OPEN', salary_range_min = 15000000, salary_range_max = 25000000, requirements = '- Tối thiểu 1 năm kinh nghiệm sales B2B' || E'\n' || '- Kỹ năng giao tiếp, đàm phán tốt' || E'\n' || '- Có kinh nghiệm bán SaaS/HR Tech là lợi thế', location = 'Hồ Chí Minh', headcount = 3 WHERE title = 'Nhân viên kinh doanh B2B';

UPDATE job_posting SET description = 'Thiết kế và triển khai chương trình đào tạo nội bộ. Đánh giá nhu cầu đào tạo, xây dựng lộ trình phát triển năng lực cho nhân viên.', department_id = (SELECT id FROM department WHERE code='TRAINING' LIMIT 1), status = 'DRAFT', salary_range_min = 16000000, salary_range_max = 28000000, requirements = '- Có kinh nghiệm thiết kế chương trình đào tạo' || E'\n' || '- Kỹ năng thuyết trình và facilitation tốt', location = 'Hà Nội', headcount = 1 WHERE title = 'Chuyên viên đào tạo nội bộ';

UPDATE job_posting SET description = 'Xây dựng và duy trì framework kiểm thử tự động. Viết test case, thực hiện regression testing và performance testing.', department_id = (SELECT id FROM department WHERE code='QA' LIMIT 1), status = 'OPEN', salary_range_min = 22000000, salary_range_max = 38000000, requirements = '- Thành thạo Selenium/Cypress/Playwright' || E'\n' || '- Có kinh nghiệm CI/CD (Jenkins, GitHub Actions)' || E'\n' || '- Biết Java/Python/JavaScript', location = 'Hà Nội', headcount = 2 WHERE title = 'Kỹ sư kiểm thử tự động';

UPDATE job_posting SET description = 'Phân tích dữ liệu nhân sự để hỗ trợ ra quyết định. Xây dựng dashboard HR metrics, phân tích xu hướng nhân sự, dự báo biến động.', department_id = (SELECT id FROM department WHERE code='DATA' LIMIT 1), status = 'OPEN', salary_range_min = 20000000, salary_range_max = 35000000, requirements = '- Thành thạo SQL và công cụ BI (Tableau/Power BI)' || E'\n' || '- Có kinh nghiệm Python/R cho phân tích dữ liệu' || E'\n' || '- Hiểu biết về HR metrics', location = 'Hà Nội', headcount = 1 WHERE title = 'Chuyên viên phân tích dữ liệu nhân sự';

UPDATE job_posting SET description = 'Quản lý roadmap sản phẩm HRMS nội bộ. Thu thập yêu cầu từ các phòng ban, ưu tiên tính năng và phối hợp với team phát triển.', department_id = (SELECT id FROM department WHERE code='PRODUCT' LIMIT 1), status = 'DRAFT', salary_range_min = 30000000, salary_range_max = 50000000, requirements = '- Tối thiểu 3 năm kinh nghiệm Product Management' || E'\n' || '- Có kiến thức cơ bản về UX/UI', location = 'Hà Nội', headcount = 1 WHERE title = 'Quản lý sản phẩm nội bộ';

UPDATE job_posting SET description = 'Đảm bảo an toàn thông tin cho hệ thống HRMS. Thực hiện penetration testing, code review về bảo mật, và xây dựng chính sách bảo mật.', department_id = (SELECT id FROM department WHERE code='SECURITY' LIMIT 1), status = 'OPEN', salary_range_min = 28000000, salary_range_max = 48000000, requirements = '- Tối thiểu 2 năm kinh nghiệm AppSec/DevSecOps' || E'\n' || '- Thành thạo OWASP Top 10, secure coding', location = 'Hà Nội', headcount = 1 WHERE title = 'Kỹ sư an toàn ứng dụng';

UPDATE job_posting SET description = 'Điều phối các dự án nội bộ, theo dõi tiến độ, quản lý rủi ro và báo cáo cho Ban Giám đốc.', department_id = (SELECT id FROM department WHERE code='PMO' LIMIT 1), status = 'OPEN', salary_range_min = 18000000, salary_range_max = 32000000, requirements = '- Kỹ năng tổ chức và quản lý thời gian tốt' || E'\n' || '- Thành thạo MS Project/Jira/Notion' || E'\n' || '- Kinh nghiệm Agile/Scrum', location = 'Hà Nội', headcount = 1 WHERE title = 'Điều phối viên dự án';

UPDATE job_posting SET status = 'CLOSED', description = 'Vị trí đã tuyển được ứng viên phù hợp.', department_id = (SELECT id FROM department WHERE code='HR' LIMIT 1) WHERE title = 'HR Operations Specialist';

UPDATE job_posting SET status = 'CLOSED', description = 'Vị trí đã tuyển được ứng viên phù hợp. Đã có 2 Kỹ sư Backend gia nhập team.', department_id = (SELECT id FROM department WHERE code='IT' LIMIT 1) WHERE title = 'Backend Engineer';

-- ===== PHẦN 4: SEED AUDIT LOG (Vấn đề #14) =====

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at)
SELECT gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'CREATE', 'EMPLOYEE', e.id, 'Tạo nhân viên mới: ' || e.employee_no || ' - ' || e.full_name || ', ' || d.name, '192.168.1.100', e.created_at
FROM employee e JOIN department d ON e.department_id = d.id WHERE e.employee_no IN ('NV000077', 'NV000078');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'UPDATE', 'EMPLOYEE', (SELECT id FROM employee WHERE employee_no='NV000001' LIMIT 1), 'Cập nhật email: tranquockhanh@company.vn', '192.168.1.101', '2026-06-27 15:30:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'CHANGE_STATUS', 'EMPLOYEE', (SELECT id FROM employee WHERE employee_no='NV000050' LIMIT 1), 'Chuyển trạng thái: ACTIVE → INACTIVE (nghỉ thai sản)', '192.168.1.101', '2026-06-26 11:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'ASSIGN_MANAGER', 'EMPLOYEE', (SELECT id FROM employee WHERE employee_no='NV000002' LIMIT 1), 'Phân công quản lý mới cho NV000002', '192.168.1.100', '2026-06-25 09:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'DELETE', 'EMPLOYEE', NULL, 'Xóa nhân viên đã nghỉ việc', '192.168.1.100', '2026-06-08 10:00:00+07');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='nv000002' LIMIT 1), 'CREATE', 'LEAVE_REQUEST', (SELECT id FROM leave_request ORDER BY created_at DESC LIMIT 1), 'Tạo đơn nghỉ phép: ANNUAL, lý do: Nghỉ phép năm', '192.168.1.102', '2026-06-09 08:30:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='line-manager' LIMIT 1), 'APPROVE', 'LEAVE_REQUEST', (SELECT id FROM leave_request WHERE status='APPROVED' LIMIT 1), 'Duyệt đơn nghỉ phép: ANNUAL, 03/06-05/06/2026', '192.168.1.103', '2026-06-02 16:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='line-manager' LIMIT 1), 'REJECT', 'LEAVE_REQUEST', (SELECT id FROM leave_request WHERE status='REJECTED' LIMIT 1), 'Từ chối đơn nghỉ phép: lý do thiếu nhân sự', '192.168.1.103', '2026-06-15 10:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='it-manager' LIMIT 1), 'APPROVE', 'LEAVE_REQUEST', (SELECT id FROM leave_request WHERE status='APPROVED' ORDER BY created_at DESC LIMIT 1), 'Duyệt đơn nghỉ phép: ANNUAL, 17/06-19/06/2026', '192.168.1.110', '2026-06-16 14:00:00+07');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'CREATE', 'CANDIDATE', (SELECT id FROM candidate LIMIT 1), 'Thêm ứng viên: Nguyễn Hải Đăng', '192.168.1.101', '2026-06-25 14:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'CREATE', 'JOB_POSTING', (SELECT id FROM job_posting WHERE title LIKE 'Chuyên viên%' LIMIT 1), 'Đăng tin tuyển dụng: Chuyên viên tuyển dụng cấp cao', '192.168.1.101', '2026-06-20 09:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'CREATE', 'APPLICATION', (SELECT id FROM recruitment_application LIMIT 1), 'Tạo hồ sơ ứng tuyển: Nguyễn Hải Đăng → Chuyên viên tuyển dụng', '192.168.1.101', '2026-06-21 10:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'CONVERT', 'APPLICATION', (SELECT id FROM recruitment_application WHERE status='HIRED' LIMIT 1), 'Chuyển ứng viên thành nhân viên chính thức', '192.168.1.100', '2026-06-28 10:10:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'SCHEDULE', 'INTERVIEW', (SELECT id FROM interview LIMIT 1), 'Lên lịch phỏng vấn: 25/06/2026 14:00, Phòng họp A', '192.168.1.101', '2026-06-23 14:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'FEEDBACK', 'INTERVIEW', (SELECT id FROM interview WHERE status='COMPLETED' LIMIT 1), 'Phỏng vấn hoàn thành: Đánh giá 4/5, đề xuất offer', '192.168.1.101', '2026-06-25 16:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='it-manager' LIMIT 1), 'FEEDBACK', 'INTERVIEW', (SELECT id FROM interview WHERE status='COMPLETED' ORDER BY created_at DESC LIMIT 1), 'Phỏng vấn technical: Đánh giá 5/5, kỹ năng xuất sắc', '192.168.1.110', '2026-06-24 12:00:00+07');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='training-manager' LIMIT 1), 'CREATE', 'COURSE', (SELECT id FROM course LIMIT 1), 'Tạo khóa học: HR Analytics cơ bản', '192.168.1.105', '2026-06-10 08:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='training-manager' LIMIT 1), 'ENROLL', 'COURSE', (SELECT id FROM course LIMIT 1), 'Ghi danh 15 nhân viên vào khóa HR Analytics cơ bản', '192.168.1.105', '2026-06-11 10:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='training-manager' LIMIT 1), 'ISSUE', 'CERTIFICATION', (SELECT id FROM certification LIMIT 1), 'Cấp chứng chỉ: OKR và phản hồi hiệu quả cho 8 nhân viên', '192.168.1.105', '2026-06-22 16:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='nv000011' LIMIT 1), 'ENROLL', 'COURSE', (SELECT id FROM course ORDER BY created_at LIMIT 1), 'Đăng ký khóa học: First-time Manager Essentials', '192.168.1.106', '2026-06-12 09:00:00+07');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'CREATE', 'ASSET', (SELECT id FROM asset LIMIT 1), 'Thêm tài sản mới: Laptop Dell XPS 15, SN: DL202606001', '192.168.1.100', '2026-06-22 08:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'ASSIGN', 'ASSET', (SELECT id FROM asset WHERE status='ASSIGNED' LIMIT 1), 'Bàn giao Laptop Dell XPS cho nhân viên mới', '192.168.1.100', '2026-06-28 10:30:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'UNASSIGN', 'ASSET', (SELECT id FROM asset WHERE status='AVAILABLE' LIMIT 1), 'Thu hồi tài sản từ nhân viên đã nghỉ việc', '192.168.1.100', '2026-06-08 10:00:00+07');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='finance-manager' LIMIT 1), 'EXECUTE', 'PAYROLL', (SELECT id FROM payroll_run LIMIT 1), 'Chạy lương tháng 06/2026: 138 nhân viên', '192.168.1.107', '2026-06-27 10:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='finance-manager' LIMIT 1), 'CLOSE', 'PAYROLL_PERIOD', (SELECT id FROM payroll_period WHERE status='CLOSED' LIMIT 1), 'Chốt kỳ lương tháng 05/2026', '192.168.1.107', '2026-06-15 16:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='finance-manager' LIMIT 1), 'CREATE', 'PAYROLL_PERIOD', (SELECT id FROM payroll_period ORDER BY created_at DESC LIMIT 1), 'Tạo kỳ lương tháng 07/2026 (01/07-31/07)', '192.168.1.107', '2026-06-28 08:00:00+07');

INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'CREATE', 'DEPARTMENT', (SELECT id FROM department WHERE code='PMO' LIMIT 1), 'Tạo phòng ban mới: Văn phòng Quản lý dự án (PMO)', '192.168.1.100', '2026-06-15 09:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'UPDATE', 'DEPARTMENT', (SELECT id FROM department WHERE code='IT' LIMIT 1), 'Đổi tên phòng ban: Phòng IT → Phòng Công nghệ thông tin', '192.168.1.100', '2026-06-10 11:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'CREATE', 'ANNOUNCEMENT', (SELECT id FROM announcement LIMIT 1), 'Đăng thông báo: Lịch nghỉ lễ Quốc khánh 2/9', '192.168.1.100', '2026-06-25 08:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'SEND', 'NOTIFICATION', (SELECT id FROM notification LIMIT 1), 'Gửi thông báo đến toàn bộ nhân viên', '192.168.1.100', '2026-06-28 08:00:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'LOGIN', 'AUTH', NULL, 'Đăng nhập thành công', '192.168.1.100', '2026-06-30 07:45:00+07'),
(gen_random_uuid(), 'default', (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'LOGIN', 'AUTH', NULL, 'Đăng nhập thành công', '192.168.1.101', '2026-06-30 08:00:00+07');

-- ===== PHẦN 5: CẬP NHẬT NOTIFICATION (Vấn đề #13) =====

UPDATE notification SET creator_id = (SELECT id FROM app_user WHERE username='admin' LIMIT 1), creator_name = 'Trần Quốc Khánh' WHERE creator_id IS NULL;

INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, creator_id, creator_name, detail, file_url, file_name, created_at, updated_at) VALUES
(gen_random_uuid(), 'default', (SELECT e.id FROM employee e WHERE e.employee_no='NV000001' LIMIT 1), 'Cập nhật chính sách làm việc từ xa 2026', 'Chính sách làm việc từ xa đã được cập nhật. Vui lòng đọc kỹ và xác nhận.', 'POLICY', false, (SELECT id FROM app_user WHERE username='admin' LIMIT 1), 'Trần Quốc Khánh', 'Chính sách làm việc từ xa mới áp dụng từ 01/07/2026. Nhân viên được phép làm việc từ xa tối đa 2 ngày/tuần. Cần đăng ký trước ít nhất 1 ngày qua hệ thống.', '/api/v1/documents/policy-remote-work-2026.pdf', 'Chinh_sach_lam_viec_tu_xa_2026.pdf', '2026-06-28 08:00:00+07', '2026-06-28 08:00:00+07'),

(gen_random_uuid(), 'default', (SELECT e.id FROM employee e WHERE e.employee_no='NV000020' LIMIT 1), 'Thẻ bảo hiểm sức khỏe 2026', 'Thẻ bảo hiểm sức khỏe của bạn đã sẵn sàng. Vui lòng tải về và kiểm tra thông tin.', 'DOCUMENT', false, (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'Lê Thu Trang', 'Thẻ bảo hiểm sức khỏe PVI Care 2026. Hạn mức: 200 triệu/năm. Áp dụng cho nội trú, ngoại trú, nha khoa.', '/api/v1/documents/insurance-card-2026.pdf', 'The_BH_PVI_2026.pdf', '2026-06-25 14:00:00+07', '2026-06-25 14:00:00+07'),

(gen_random_uuid(), 'default', (SELECT e.id FROM employee e WHERE e.employee_no='NV000077' LIMIT 1), 'Hợp đồng lao động - Vui lòng ký xác nhận', 'Hợp đồng lao động của bạn đã được soạn thảo. Vui lòng kiểm tra và ký xác nhận.', 'DOCUMENT', false, (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'Lê Thu Trang', 'Hợp đồng lao động số HDLD-2026-077. Thời hạn: 12 tháng (01/07/2026 - 30/06/2027). Vị trí: Kỹ sư Backend.', '/api/v1/documents/contract-NV000077.pdf', 'Hop_dong_lao_dong_NV000077.pdf', '2026-06-28 10:00:00+07', '2026-06-28 10:00:00+07'),

(gen_random_uuid(), 'default', (SELECT e.id FROM employee e WHERE e.employee_no='NV000002' LIMIT 1), 'Bạn được chỉ định tham gia khóa học: An toàn thông tin 2026', 'Khóa học bắt buộc dành cho toàn bộ nhân viên. Vui lòng hoàn thành trước 15/07/2026.', 'TRAINING', false, (SELECT id FROM app_user WHERE username='training-manager' LIMIT 1), 'NV000033', 'Khóa học gồm 4 module: Nhận diện phishing, Quản lý mật khẩu, Bảo vệ dữ liệu cá nhân, Quy trình báo cáo sự cố. Bài kiểm tra cuối khóa yêu cầu đạt tối thiểu 80%.', '/api/v1/documents/security-awareness-2026-syllabus.pdf', 'De_cuong_An_toan_thong_tin_2026.pdf', '2026-06-26 09:00:00+07', '2026-06-26 09:00:00+07'),

(gen_random_uuid(), 'default', (SELECT e.id FROM employee e WHERE e.employee_no='NV000011' LIMIT 1), 'Đánh giá hiệu suất Q2-2026 - Đã đến hạn', 'Bạn có 5 nhân viên cần đánh giá trong chu kỳ Q2-2026. Hạn chót: 05/07/2026.', 'PERFORMANCE', false, (SELECT id FROM app_user WHERE username='hr-manager' LIMIT 1), 'Lê Thu Trang', 'Chu kỳ đánh giá Q2-2026 (01/04-30/06/2026). Vui lòng hoàn thành đánh giá cho các nhân viên trong phòng ban của bạn.', '/api/v1/documents/performance-review-guide-Q2-2026.pdf', 'Huong_dan_danh_gia_Q2_2026.pdf', '2026-06-25 08:00:00+07', '2026-06-25 08:00:00+07');

-- ===== PHẦN 6: CẬP NHẬT ANNOUNCEMENT, LEAVEBALANCE, CANDIDATE =====

UPDATE announcement SET author_name = 'Trần Quốc Khánh' WHERE author_name IS NULL;

UPDATE leave_balance lb SET pending_days = (
  SELECT COUNT(*) FROM leave_request lr 
  WHERE lr.employee_id = lb.employee_id AND lr.leave_type = lb.leave_type 
    AND lr.status = 'PENDING' AND EXTRACT(YEAR FROM lr.from_date) = lb."year"
) WHERE EXISTS (
  SELECT 1 FROM leave_request lr2 
  WHERE lr2.employee_id = lb.employee_id AND lr2.leave_type = lb.leave_type AND lr2.status = 'PENDING'
);

UPDATE candidate SET email = 'nguyenhaidang@email.vn', phone = '0987654321', source = 'LINKEDIN' WHERE full_name = 'Nguyễn Hải Đăng';
UPDATE candidate SET email = 'traminhanh@email.vn', phone = '0912345678', source = 'TOP_CV' WHERE full_name = 'Trần Minh Anh';
UPDATE candidate SET email = 'dolanchi@email.vn', phone = '0978123456', source = 'REFERRAL' WHERE full_name = 'Do Lan Chi';
UPDATE candidate SET email = 'hoangmailinh@email.vn', phone = '0934567890', source = 'FACEBOOK' WHERE full_name = 'Hoang Mai Linh';
UPDATE candidate SET email = 'buithanhson@email.vn', phone = '0901234567', source = 'LINKEDIN' WHERE full_name = 'Bui Thanh Son';
UPDATE candidate SET email = LOWER(REPLACE(full_name, ' ', '')) || '@email.vn', phone = '09' || LPAD(FLOOR(RANDOM() * 100000000)::text, 8, '0'), source = (ARRAY['LINKEDIN','TOP_CV','REFERRAL','FACEBOOK','CAREERBUILDER'])[FLOOR(RANDOM() * 5 + 1)] WHERE email IS NULL;

-- ===== PHẦN 7: SEED PERFORMANCE DATA (Vấn đề #9) =====

INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', (SELECT id FROM appraisal_cycle WHERE name = 'Đánh giá Nửa đầu năm 2026' LIMIT 1), e.id, 'MANAGER', e.manager_id, ROUND((RANDOM() * 3 + 2)::numeric, 1), 
  (ARRAY['Kỹ năng chuyên môn tốt, hoàn thành deadline đúng hạn', 'Tinh thần làm việc nhóm cao, hỗ trợ đồng nghiệp hiệu quả', 'Khả năng tự học và thích nghi nhanh', 'Kỹ năng giao tiếp và thuyết trình xuất sắc', 'Tư duy phân tích và giải quyết vấn đề tốt'])[FLOOR(RANDOM() * 5 + 1)],
  (ARRAY['Cần cải thiện kỹ năng quản lý thời gian', 'Nên tham gia thêm các khóa đào tạo chuyên môn', 'Cần chủ động hơn trong báo cáo tiến độ', 'Nên phát triển kỹ năng tiếng Anh', 'Cần cải thiện kỹ năng viết tài liệu'])[FLOOR(RANDOM() * 5 + 1)],
  'SUBMITTED', NOW() - (FLOOR(RANDOM() * 30 + 1)::int || ' days')::INTERVAL, NOW(), NOW()
FROM employee e WHERE e.id NOT IN (SELECT DISTINCT employee_id FROM performance_review) AND e.employment_status = 'ACTIVE' LIMIT 15;

INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', pr.employee_id, (SELECT id FROM appraisal_cycle WHERE name = 'Đánh giá Nửa đầu năm 2026' LIMIT 1),
  k.title, k.description, k.target_score, ROUND((RANDOM() * (k.target_score + 1))::numeric, 1), k.weight, NOW(), NOW()
FROM performance_review pr
CROSS JOIN (VALUES 
  ('Hoàn thành dự án đúng hạn', 'Tỷ lệ dự án hoàn thành đúng deadline', 4.0, 30),
  ('Chất lượng công việc', 'Đánh giá chất lượng qua code review/QA', 4.0, 25),
  ('Phối hợp nhóm', 'Mức độ tham gia và đóng góp vào hoạt động nhóm', 3.5, 20),
  ('Phát triển bản thân', 'Hoàn thành các khóa đào tạo được giao', 3.0, 15),
  ('Sáng kiến cải tiến', 'Đề xuất và triển khai cải tiến quy trình', 3.0, 10)
) AS k(title, description, target_score, weight)
WHERE pr.employee_id NOT IN (SELECT DISTINCT employee_id FROM kpi);
