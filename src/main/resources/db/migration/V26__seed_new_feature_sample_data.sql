-- ============================================================================
-- V26: Seed demo data for admin features added after V17.
-- Covers time entries, documents, announcements, notifications, onboarding,
-- interviews, training, assets, and audit logs for tenant 'default'.
-- ============================================================================

-- TIME ENTRIES
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000001', '2026-06-01', '08:24', '17:42', 558, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000001');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000002', '2026-06-01', '08:31', '17:36', 545, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000002');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000003', 'default', 'b1000000-0000-4000-8000-000000000003', '2026-06-01', '09:02', '18:12', 550, 'PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000003');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000004', 'default', 'b1000000-0000-4000-8000-000000000004', '2026-06-01', '08:12', '17:05', 533, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000004');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000005', 'default', 'b1000000-0000-4000-8000-000000000005', '2026-06-01', '10:18', '18:00', 462, 'REJECTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000005');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000006', 'default', 'b1000000-0000-4000-8000-000000000006', '2026-06-02', '08:20', '17:40', 560, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000006');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000007', 'default', 'b1000000-0000-4000-8000-000000000007', '2026-06-02', '08:45', '17:50', 545, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000007');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000008', 'default', 'b1000000-0000-4000-8000-000000000008', '2026-06-02', '09:12', NULL, 0, 'PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000008');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000009', 'default', 'b1000000-0000-4000-8000-000000000009', '2026-06-02', '08:05', '17:10', 545, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000009');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000010', 'default', 'b1000000-0000-4000-8000-000000000010', '2026-06-02', '08:58', '18:20', 562, 'PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000010');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000011', 'default', 'b1000000-0000-4000-8000-000000000011', '2026-06-03', '08:17', '17:30', 553, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000011');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000012', 'default', 'b1000000-0000-4000-8000-000000000012', '2026-06-03', '08:40', '17:45', 545, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000012');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000013', 'default', 'b1000000-0000-4000-8000-000000000013', '2026-06-03', '09:25', '18:05', 520, 'REJECTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000013');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000014', 'default', 'b1000000-0000-4000-8000-000000000014', '2026-06-03', '08:08', '17:18', 550, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000014');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000015', 'default', 'b1000000-0000-4000-8000-000000000015', '2026-06-03', '08:36', NULL, 0, 'PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000015');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000016', 'default', 'b1000000-0000-4000-8000-000000000016', '2026-06-04', '08:21', '17:35', 554, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000016');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000017', 'default', 'b1000000-0000-4000-8000-000000000017', '2026-06-04', '08:44', '17:46', 542, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000017');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000018', 'default', 'b1000000-0000-4000-8000-000000000018', '2026-06-04', '09:05', '18:11', 546, 'PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000018');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000019', 'default', 'b1000000-0000-4000-8000-000000000019', '2026-06-04', '08:13', '17:22', 549, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000019');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000020', 'default', 'b1000000-0000-4000-8000-000000000020', '2026-06-04', '08:50', '17:55', 545, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000020');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000021', 'default', 'b1000000-0000-4000-8000-000000000021', '2026-06-04', '09:20', NULL, 0, 'PENDING', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000021');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000022', 'default', 'b1000000-0000-4000-8000-000000000022', '2026-06-04', '08:29', '17:40', 551, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000022');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000023', 'default', 'b1000000-0000-4000-8000-000000000023', '2026-06-04', '10:05', '18:15', 490, 'REJECTED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000023');
INSERT INTO time_entry (id, tenant_id, employee_id, date, clock_in, clock_out, total_minutes, status, created_at, updated_at)
SELECT '26000000-0000-4000-8000-000000000024', 'default', 'b1000000-0000-4000-8000-000000000024', '2026-06-04', '08:18', '17:28', 550, 'APPROVED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM time_entry WHERE id = '26000000-0000-4000-8000-000000000024');

-- DOCUMENTS
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000001', 'hop-dong-emp001.pdf', 'Hop dong lao dong - Nguyen Van An.pdf', 'application/pdf', 482144, '/demo/documents/hop-dong-emp001.pdf', 'CONTRACT', TIMESTAMP '2026-05-23 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000001');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000002', 'cv-emp002.pdf', 'CV - Tran Thi Bich Ngoc.pdf', 'application/pdf', 318920, '/demo/documents/cv-emp002.pdf', 'CV', TIMESTAMP '2026-05-24 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000002');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000003', 'default', 'b1000000-0000-4000-8000-000000000003', 'chung-chi-pmp-emp003.pdf', 'Chung chi PMP - Le Hoang Minh.pdf', 'application/pdf', 614880, '/demo/documents/chung-chi-pmp-emp003.pdf', 'CERTIFICATE', TIMESTAMP '2026-05-25 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000003');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000004', 'default', 'b1000000-0000-4000-8000-000000000004', 'quyet-dinh-bo-nhiem-emp004.docx', 'Quyet dinh bo nhiem - Pham Thi Huong.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 121560, '/demo/documents/quyet-dinh-bo-nhiem-emp004.docx', 'OTHER', TIMESTAMP '2026-05-26 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000004');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000005', 'default', 'b1000000-0000-4000-8000-000000000005', 'hop-dong-emp005.pdf', 'Hop dong lao dong - Vu Duc Anh.pdf', 'application/pdf', 438774, '/demo/documents/hop-dong-emp005.pdf', 'CONTRACT', TIMESTAMP '2026-05-27 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000005');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000006', 'default', 'b1000000-0000-4000-8000-000000000006', 'cccd-emp006.jpg', 'Can cuoc cong dan - Do Quang Huy.jpg', 'image/jpeg', 842310, '/demo/documents/cccd-emp006.jpg', 'OTHER', TIMESTAMP '2026-05-28 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000006');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000007', 'default', 'b1000000-0000-4000-8000-000000000007', 'chung-chi-aws-emp007.pdf', 'AWS Solutions Architect - Ngo Thi Lan Anh.pdf', 'application/pdf', 734112, '/demo/documents/chung-chi-aws-emp007.pdf', 'CERTIFICATE', TIMESTAMP '2026-05-29 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000007');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000008', 'default', 'b1000000-0000-4000-8000-000000000008', 'phu-luc-luong-emp008.pdf', 'Phu luc dieu chinh luong - Hoang Xuan Son.pdf', 'application/pdf', 289661, '/demo/documents/phu-luc-luong-emp008.pdf', 'CONTRACT', TIMESTAMP '2026-05-29 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000008');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000009', 'default', 'b1000000-0000-4000-8000-000000000009', 'cv-emp009.pdf', 'CV - Bui Khanh Duy.pdf', 'application/pdf', 276098, '/demo/documents/cv-emp009.pdf', 'CV', TIMESTAMP '2026-05-30 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000009');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000010', 'default', 'b1000000-0000-4000-8000-000000000010', 'hop-dong-emp010.pdf', 'Hop dong lao dong - Dinh Thi Thu Ha.pdf', 'application/pdf', 468006, '/demo/documents/hop-dong-emp010.pdf', 'CONTRACT', TIMESTAMP '2026-05-30 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000010');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000011', 'default', 'b1000000-0000-4000-8000-000000000011', 'bang-cap-emp011.pdf', 'Bang tot nghiep - Trinh Van Khang.pdf', 'application/pdf', 699840, '/demo/documents/bang-cap-emp011.pdf', 'CERTIFICATE', TIMESTAMP '2026-05-31 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000011');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000012', 'default', 'b1000000-0000-4000-8000-000000000012', 'cam-ket-bao-mat-emp012.pdf', 'Cam ket bao mat - Ly Thi Mai.pdf', 'application/pdf', 198220, '/demo/documents/cam-ket-bao-mat-emp012.pdf', 'OTHER', TIMESTAMP '2026-05-31 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000012');

-- ANNOUNCEMENTS
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000001', 'Lich nghi Tet Nguyen dan 2026', 'Nhan su cap nhat ke hoach nghi Tet va ban giao cong viec truoc ngay 2026-02-10.', '2026-01-15T02:00:00Z', '2026-02-23T16:59:59Z', 'HIGH', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000001');
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000001', 'Dang ky nghi bu ngay 30/4 - 1/5', 'Cac phong ban gui danh sach truc he thong trong ky nghi le thong nhat va Quoc te Lao dong.', '2026-04-10T02:00:00Z', '2026-05-04T16:59:59Z', 'NORMAL', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000002');
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000003', 'default', 'b1000000-0000-4000-8000-000000000004', 'Khoa hoc bat buoc ve an toan thong tin', 'Nhan vien khoi van phong hoan thanh khoa hoc Security Awareness truoc ngay 2026-06-30.', '2026-06-01T02:00:00Z', '2026-06-30T16:59:59Z', 'URGENT', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000003');
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000004', 'default', 'b1000000-0000-4000-8000-000000000010', 'Chot bang cong thang 06/2026', 'Quan ly truc tiep vui long duyet cac ban ghi cham cong pending truoc 17:00 ngay 2026-06-28.', '2026-06-20T02:00:00Z', '2026-06-29T16:59:59Z', 'HIGH', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000004');
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000005', 'default', 'b1000000-0000-4000-8000-000000000001', 'Khao sat trai nghiem nhan vien Q2', 'Khao sat noi bo mo den het ngay 2026-06-14, ket qua duoc dung cho ke hoach cai tien Q3.', '2026-06-04T02:00:00Z', '2026-06-15T16:59:59Z', 'LOW', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000005');

-- NOTIFICATIONS
INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
SELECT '26200000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000001', 'Duyet cham cong', 'Con 3 ban ghi cham cong dang cho duyet.', 'ATTENDANCE', false, TIMESTAMP '2026-06-04 06:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM notification WHERE id = '26200000-0000-4000-8000-000000000001');
INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
SELECT '26200000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000002', 'Ho so tai lieu moi', 'Hop dong va phu luc luong moi da duoc tai len.', 'DOCUMENT', false, TIMESTAMP '2026-06-04 07:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM notification WHERE id = '26200000-0000-4000-8000-000000000002');
INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
SELECT '26200000-0000-4000-8000-000000000003', 'default', 'b1000000-0000-4000-8000-000000000003', 'Lich phong van sap toi', 'Ban co mot buoi phong van ung vien luc 14:00 ngay 2026-06-06.', 'RECRUITMENT', false, TIMESTAMP '2026-06-04 07:30:00', now()
WHERE NOT EXISTS (SELECT 1 FROM notification WHERE id = '26200000-0000-4000-8000-000000000003');
INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
SELECT '26200000-0000-4000-8000-000000000004', 'default', 'b1000000-0000-4000-8000-000000000004', 'Khoa hoc moi', 'Khoa Data Privacy for Managers da mo ghi danh.', 'TRAINING', true, TIMESTAMP '2026-06-03 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM notification WHERE id = '26200000-0000-4000-8000-000000000004');
INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
SELECT '26200000-0000-4000-8000-000000000005', 'default', 'b1000000-0000-4000-8000-000000000005', 'Tai san da duoc gan', 'Laptop Dell Latitude 7450 da duoc gan vao ho so cua ban.', 'ASSET', false, TIMESTAMP '2026-06-03 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM notification WHERE id = '26200000-0000-4000-8000-000000000005');

-- ONBOARDING TEMPLATES AND TASKS
INSERT INTO onboarding_template (id, tenant_id, name, description, created_at, updated_at)
SELECT '26400000-0000-4000-8000-000000000001', 'default', 'Nhan vien van phong moi', 'Checklist 7 ngay dau cho nhan vien khoi van phong.', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template WHERE id = '26400000-0000-4000-8000-000000000001');
INSERT INTO onboarding_template (id, tenant_id, name, description, created_at, updated_at)
SELECT '26400000-0000-4000-8000-000000000002', 'default', 'Ky su cong nghe moi', 'Onboarding thiet bi, tai khoan, bao mat va quy trinh delivery.', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template WHERE id = '26400000-0000-4000-8000-000000000002');
INSERT INTO onboarding_template (id, tenant_id, name, description, created_at, updated_at)
SELECT '26400000-0000-4000-8000-000000000003', 'default', 'Quan ly cap trung', 'Checklist cho truong nhom va quan ly phong ban moi.', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template WHERE id = '26400000-0000-4000-8000-000000000003');

INSERT INTO onboarding_template_task (id, tenant_id, template_id, title, description, order_index, created_at, updated_at)
SELECT '26500000-0000-4000-8000-000000000001', 'default', '26400000-0000-4000-8000-000000000001', 'Hoan tat ho so nhan su', 'Kiem tra thong tin ca nhan, tai khoan ngan hang va ma so thue.', 1, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template_task WHERE id = '26500000-0000-4000-8000-000000000001');
INSERT INTO onboarding_template_task (id, tenant_id, template_id, title, description, order_index, created_at, updated_at)
SELECT '26500000-0000-4000-8000-000000000002', 'default', '26400000-0000-4000-8000-000000000001', 'Nhan tai khoan noi bo', 'Kich hoat email, HRMS, chat va cong cu van phong.', 2, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template_task WHERE id = '26500000-0000-4000-8000-000000000002');
INSERT INTO onboarding_template_task (id, tenant_id, template_id, title, description, order_index, created_at, updated_at)
SELECT '26500000-0000-4000-8000-000000000003', 'default', '26400000-0000-4000-8000-000000000001', 'Doc noi quy cong ty', 'Xac nhan da doc so tay nhan vien va quy dinh bao mat.', 3, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template_task WHERE id = '26500000-0000-4000-8000-000000000003');
INSERT INTO onboarding_template_task (id, tenant_id, template_id, title, description, order_index, created_at, updated_at)
SELECT '26500000-0000-4000-8000-000000000004', 'default', '26400000-0000-4000-8000-000000000002', 'Nhan laptop va VPN', 'Ban giao laptop, VPN, SSH key va quyen repo.', 1, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template_task WHERE id = '26500000-0000-4000-8000-000000000004');
INSERT INTO onboarding_template_task (id, tenant_id, template_id, title, description, order_index, created_at, updated_at)
SELECT '26500000-0000-4000-8000-000000000005', 'default', '26400000-0000-4000-8000-000000000002', 'Tham gia security briefing', 'Hoan thanh huong dan truy cap, bao mat ma nguon va xu ly du lieu.', 2, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template_task WHERE id = '26500000-0000-4000-8000-000000000005');
INSERT INTO onboarding_template_task (id, tenant_id, template_id, title, description, order_index, created_at, updated_at)
SELECT '26500000-0000-4000-8000-000000000006', 'default', '26400000-0000-4000-8000-000000000003', 'Nhan ban giao OKR', 'Thong nhat muc tieu 30-60-90 ngay voi cap quan ly.', 1, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_template_task WHERE id = '26500000-0000-4000-8000-000000000006');

INSERT INTO onboarding_task (id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at)
SELECT '26600000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000025', 'Hoan tat ho so nhan su', 'Cap nhat thong tin ca nhan va giay to bat buoc.', 'DONE', TIMESTAMP '2026-06-02 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_task WHERE id = '26600000-0000-4000-8000-000000000001');
INSERT INTO onboarding_task (id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at)
SELECT '26600000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000025', 'Nhan tai khoan noi bo', 'Kich hoat email, HRMS va chat.', 'IN_PROGRESS', NULL, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_task WHERE id = '26600000-0000-4000-8000-000000000002');
INSERT INTO onboarding_task (id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at)
SELECT '26600000-0000-4000-8000-000000000003', 'default', 'b1000000-0000-4000-8000-000000000025', 'Doc noi quy cong ty', 'Xac nhan so tay nhan vien.', 'TODO', NULL, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_task WHERE id = '26600000-0000-4000-8000-000000000003');
INSERT INTO onboarding_task (id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at)
SELECT '26600000-0000-4000-8000-000000000004', 'default', 'b1000000-0000-4000-8000-000000000026', 'Nhan laptop va VPN', 'Ban giao thiet bi va quyen truy cap.', 'IN_PROGRESS', NULL, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_task WHERE id = '26600000-0000-4000-8000-000000000004');
INSERT INTO onboarding_task (id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at)
SELECT '26600000-0000-4000-8000-000000000005', 'default', 'b1000000-0000-4000-8000-000000000026', 'Tham gia security briefing', 'Dao tao bao mat bat buoc cho ky su moi.', 'TODO', NULL, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_task WHERE id = '26600000-0000-4000-8000-000000000005');
INSERT INTO onboarding_task (id, tenant_id, employee_id, title, description, status, completed_at, created_at, updated_at)
SELECT '26600000-0000-4000-8000-000000000006', 'default', 'b1000000-0000-4000-8000-000000000027', 'Nhan ban giao OKR', 'Thong nhat muc tieu 30-60-90 ngay.', 'TODO', NULL, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM onboarding_task WHERE id = '26600000-0000-4000-8000-000000000006');

-- INTERVIEWS
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000001', 'default', 'e1000000-0000-4000-8000-000000000001', 'b1000000-0000-4000-8000-000000000004', '2026-06-06T07:00:00Z', 'Phong hop Hanoi 01', NULL, NULL, NULL, 'SCHEDULED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000001');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000002', 'default', 'e1000000-0000-4000-8000-000000000002', 'b1000000-0000-4000-8000-000000000005', '2026-06-05T03:30:00Z', 'Google Meet', 'https://meet.google.com/demo-hrms-002', 'Ung vien nam chac SQL va giao tiep tot.', 4, 'COMPLETED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000002');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000003', 'default', 'e1000000-0000-4000-8000-000000000003', 'b1000000-0000-4000-8000-000000000006', '2026-06-07T08:00:00Z', 'Phong hop HCM 02', NULL, NULL, NULL, 'SCHEDULED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000003');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000004', 'default', 'e1000000-0000-4000-8000-000000000004', 'b1000000-0000-4000-8000-000000000007', '2026-06-03T02:00:00Z', 'Google Meet', 'https://meet.google.com/demo-hrms-004', 'Phu hop voi nhom san pham, can dao tao them domain.', 3, 'COMPLETED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000004');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000005', 'default', 'e1000000-0000-4000-8000-000000000005', 'b1000000-0000-4000-8000-000000000008', '2026-06-08T04:00:00Z', 'Phong hop Da Nang', NULL, NULL, NULL, 'SCHEDULED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000005');

-- TRAINING
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000001', 'default', 'Security Awareness 2026', 'Dao tao nhan dien phishing, bao ve du lieu va xu ly su co.', 'Compliance', 4, 'Nguyen Van An', '2026-06-10', '2026-06-10', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000001');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000002', 'default', 'Data Privacy for Managers', 'Quy trinh xu ly du lieu ca nhan trong van hanh HR va kinh doanh.', 'Compliance', 6, 'Dinh Thi Thu Ha', '2026-06-12', '2026-06-13', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000002');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000003', 'default', 'OKR va phan hoi hieu qua', 'Thuc hanh thiet lap muc tieu va review hieu suat hang quy.', 'Leadership', 8, 'Pham Thi Huong', '2026-06-18', '2026-06-19', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000003');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000004', 'default', 'Excel nang cao cho HR', 'Pivot, Power Query va bao cao nhan su tu du lieu cham cong.', 'Operations', 10, 'Trinh Van Khang', '2026-06-22', '2026-06-24', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000004');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000005', 'default', 'Phong van theo nang luc', 'Ky thuat cau hoi hanh vi va thang diem danh gia ung vien.', 'Recruitment', 5, 'Tran Thi Bich Ngoc', '2026-06-26', '2026-06-26', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000005');

INSERT INTO enrollment (id, tenant_id, course_id, employee_id, progress, status, enrolled_at, created_at, updated_at)
SELECT '26900000-0000-4000-8000-000000000001', 'default', '26800000-0000-4000-8000-000000000001', 'b1000000-0000-4000-8000-000000000001', 100, 'COMPLETED', TIMESTAMP '2026-05-29 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM enrollment WHERE id = '26900000-0000-4000-8000-000000000001');
INSERT INTO enrollment (id, tenant_id, course_id, employee_id, progress, status, enrolled_at, created_at, updated_at)
SELECT '26900000-0000-4000-8000-000000000002', 'default', '26800000-0000-4000-8000-000000000001', 'b1000000-0000-4000-8000-000000000002', 75, 'IN_PROGRESS', TIMESTAMP '2026-05-30 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM enrollment WHERE id = '26900000-0000-4000-8000-000000000002');
INSERT INTO enrollment (id, tenant_id, course_id, employee_id, progress, status, enrolled_at, created_at, updated_at)
SELECT '26900000-0000-4000-8000-000000000003', 'default', '26800000-0000-4000-8000-000000000002', 'b1000000-0000-4000-8000-000000000004', 30, 'IN_PROGRESS', TIMESTAMP '2026-05-31 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM enrollment WHERE id = '26900000-0000-4000-8000-000000000003');
INSERT INTO enrollment (id, tenant_id, course_id, employee_id, progress, status, enrolled_at, created_at, updated_at)
SELECT '26900000-0000-4000-8000-000000000004', 'default', '26800000-0000-4000-8000-000000000003', 'b1000000-0000-4000-8000-000000000005', 0, 'ENROLLED', TIMESTAMP '2026-06-01 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM enrollment WHERE id = '26900000-0000-4000-8000-000000000004');
INSERT INTO enrollment (id, tenant_id, course_id, employee_id, progress, status, enrolled_at, created_at, updated_at)
SELECT '26900000-0000-4000-8000-000000000005', 'default', '26800000-0000-4000-8000-000000000004', 'b1000000-0000-4000-8000-000000000010', 45, 'IN_PROGRESS', TIMESTAMP '2026-06-02 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM enrollment WHERE id = '26900000-0000-4000-8000-000000000005');

INSERT INTO certification (id, tenant_id, employee_id, course_id, name, issued_at, expiry_date, credential_url, created_at, updated_at)
SELECT '26a00000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000001', '26800000-0000-4000-8000-000000000001', 'Security Awareness 2026', '2026-06-10', '2027-06-10', 'https://hrms.local/certificates/security-2026-emp001', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM certification WHERE id = '26a00000-0000-4000-8000-000000000001');
INSERT INTO certification (id, tenant_id, employee_id, course_id, name, issued_at, expiry_date, credential_url, created_at, updated_at)
SELECT '26a00000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000003', NULL, 'Professional Scrum Master I', '2026-05-28', '2028-05-28', 'https://hrms.local/certificates/psm-emp003', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM certification WHERE id = '26a00000-0000-4000-8000-000000000002');

-- ASSETS
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000001', 'default', 'Dell Latitude 7450', 'Laptop', 'DL7450-HR-001', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000005', '2026-05-20', '2026-05-10', 31500000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000001');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000002', 'default', 'MacBook Air M3 13', 'Laptop', 'MBA13-M3-MKT-002', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000014', '2026-05-22', '2026-05-12', 34900000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000002');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000003', 'default', 'Lenovo ThinkPad T14', 'Laptop', 'T14-IT-003', 'AVAILABLE', NULL, NULL, '2026-04-15', 27900000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000003');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000004', 'default', 'iPhone 15 128GB', 'Phone', 'IP15-SALES-004', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000012', '2026-04-28', '2026-04-20', 21990000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000004');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000005', 'default', 'Man hinh Dell U2724D', 'Monitor', 'U2724D-005', 'AVAILABLE', NULL, NULL, '2026-03-02', 8200000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000005');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000006', 'default', 'May in HP LaserJet Pro', 'Printer', 'HP-LJP-006', 'BROKEN', NULL, NULL, '2024-09-18', 6900000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000006');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000007', 'default', 'The nhan vien NFC lo 06', 'Access card', 'NFC-2026-007', 'AVAILABLE', NULL, NULL, '2026-06-01', 75000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000007');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000008', 'default', 'Tai nghe Jabra Evolve2 65', 'Accessory', 'JABRA-008', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000006', '2026-05-18', '2026-05-10', 4250000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000008');

-- AUDIT LOGS
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000001', 'default', 'b1000000-0000-4000-8000-000000000001', 'CREATE', 'ANNOUNCEMENT', '26300000-0000-4000-8000-000000000001', 'Created announcement for Tet 2026 holiday planning.', '10.10.1.21', TIMESTAMP '2026-05-30 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000001');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000002', 'default', 'b1000000-0000-4000-8000-000000000004', 'ASSIGN', 'ASSET', '26b00000-0000-4000-8000-000000000001', 'Assigned Dell Latitude 7450 to employee EMP005.', '10.10.2.44', TIMESTAMP '2026-05-31 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000002');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000003', 'default', 'b1000000-0000-4000-8000-000000000010', 'APPROVE', 'TIME_ENTRY', '26000000-0000-4000-8000-000000000001', 'Approved time entry for EMP001.', '10.10.1.35', TIMESTAMP '2026-06-01 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000003');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000004', 'default', 'b1000000-0000-4000-8000-000000000002', 'UPLOAD', 'DOCUMENT', '26100000-0000-4000-8000-000000000002', 'Uploaded candidate CV to employee profile.', '10.10.3.12', TIMESTAMP '2026-06-02 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000004');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000005', 'default', 'b1000000-0000-4000-8000-000000000003', 'SCHEDULE', 'INTERVIEW', '26700000-0000-4000-8000-000000000001', 'Scheduled technical interview for application e1000000-0000-4000-8000-000000000001.', '10.10.1.58', TIMESTAMP '2026-06-03 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000005');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000006', 'default', 'b1000000-0000-4000-8000-000000000004', 'ENROLL', 'COURSE', '26800000-0000-4000-8000-000000000002', 'Enrolled manager group to Data Privacy course.', '10.10.2.18', TIMESTAMP '2026-06-03 21:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000006');

-- EXTRA DOCUMENTS FOR TABLE SCROLLING
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000013', 'default', 'b1000000-0000-4000-8000-000000000013', 'hop-dong-emp013.pdf', 'Hop dong lao dong - Duong Quoc Bao.pdf', 'application/pdf', 459120, '/demo/documents/hop-dong-emp013.pdf', 'CONTRACT', TIMESTAMP '2026-06-01 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000013');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000014', 'default', 'b1000000-0000-4000-8000-000000000014', 'cv-emp014.pdf', 'CV - Ta Thi Yen.pdf', 'application/pdf', 312544, '/demo/documents/cv-emp014.pdf', 'CV', TIMESTAMP '2026-06-01 10:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000014');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000015', 'default', 'b1000000-0000-4000-8000-000000000015', 'certificate-google-ads-emp015.pdf', 'Google Ads Certification - Nguyen Minh Tu.pdf', 'application/pdf', 522880, '/demo/documents/certificate-google-ads-emp015.pdf', 'CERTIFICATE', TIMESTAMP '2026-06-01 11:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000015');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000016', 'default', 'b1000000-0000-4000-8000-000000000016', 'ban-giao-tai-san-emp016.pdf', 'Bien ban ban giao tai san - Phan Thanh Tung.pdf', 'application/pdf', 208360, '/demo/documents/ban-giao-tai-san-emp016.pdf', 'OTHER', TIMESTAMP '2026-06-01 12:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000016');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000017', 'default', 'b1000000-0000-4000-8000-000000000017', 'hop-dong-emp017.pdf', 'Hop dong lao dong - Ho Thi Diem.pdf', 'application/pdf', 446920, '/demo/documents/hop-dong-emp017.pdf', 'CONTRACT', TIMESTAMP '2026-06-02 09:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000017');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000018', 'default', 'b1000000-0000-4000-8000-000000000018', 'cv-emp018.pdf', 'CV - Nguyen Bao Chau.pdf', 'application/pdf', 295441, '/demo/documents/cv-emp018.pdf', 'CV', TIMESTAMP '2026-06-02 10:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000018');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000019', 'default', 'b1000000-0000-4000-8000-000000000019', 'iso27001-emp019.pdf', 'ISO 27001 Foundation - Tran Quoc Viet.pdf', 'application/pdf', 611040, '/demo/documents/iso27001-emp019.pdf', 'CERTIFICATE', TIMESTAMP '2026-06-02 11:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000019');
INSERT INTO document (id, tenant_id, employee_id, file_name, original_name, file_type, file_size, storage_path, category, uploaded_at, created_at, updated_at)
SELECT '26100000-0000-4000-8000-000000000020', 'default', 'b1000000-0000-4000-8000-000000000020', 'phu-luc-hop-dong-emp020.pdf', 'Phu luc hop dong - Mai Anh Khoa.pdf', 'application/pdf', 249884, '/demo/documents/phu-luc-hop-dong-emp020.pdf', 'CONTRACT', TIMESTAMP '2026-06-02 12:00:00', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM document WHERE id = '26100000-0000-4000-8000-000000000020');

-- EXTRA TRAINING COURSES
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000006', 'default', 'First-time Manager Essentials', 'Ky nang 1:1, giao viec va theo doi hieu suat cho quan ly moi.', 'Leadership', 12, 'Nguyen Van An', '2026-07-01', '2026-07-03', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000006');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000007', 'default', 'HR Analytics co ban', 'Phan tich turnover, headcount, chi phi luong va pipeline tuyen dung.', 'Analytics', 8, 'Le Hoang Minh', '2026-07-06', '2026-07-07', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000007');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000008', 'default', 'Customer Care Playbook', 'Xu ly tinh huong khach hang va quy trinh escalation.', 'Customer Success', 6, 'Nguyen Bao Chau', '2026-07-09', '2026-07-10', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000008');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000009', 'default', 'Finance for Non-finance', 'Doc bao cao tai chinh va lap ngan sach phong ban.', 'Finance', 8, 'Trinh Van Khang', '2026-07-13', '2026-07-14', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000009');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000010', 'default', 'Incident Response Drill', 'Dien tap phan ung su co an ninh va truyen thong noi bo.', 'Security', 4, 'Tran Quoc Viet', '2026-07-16', '2026-07-16', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000010');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000011', 'default', 'Product Discovery Workshop', 'Phong van nguoi dung, opportunity mapping va prototype testing.', 'Product', 10, 'Mai Anh Khoa', '2026-07-20', '2026-07-22', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000011');
INSERT INTO course (id, tenant_id, title, description, category, duration_hours, instructor_name, start_date, end_date, created_at, updated_at)
SELECT '26800000-0000-4000-8000-000000000012', 'default', 'Effective Business Writing', 'Viet email, memo va tai lieu quy trinh ngan gon, ro rang.', 'Communication', 5, 'Ta Thi Yen', '2026-07-24', '2026-07-24', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM course WHERE id = '26800000-0000-4000-8000-000000000012');

-- EXTRA ASSETS
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000009', 'default', 'Dell Latitude 5440', 'Laptop', 'DL5440-009', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000009', '2026-05-21', '2026-05-10', 23800000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000009');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000010', 'default', 'MacBook Pro 14 M3 Pro', 'Laptop', 'MBP14-010', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000010', '2026-05-22', '2026-05-11', 52900000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000010');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000011', 'default', 'Logitech MX Keys', 'Accessory', 'MXKEYS-011', 'AVAILABLE', NULL, NULL, '2026-04-02', 2650000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000011');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000012', 'default', 'Logitech MX Master 3S', 'Accessory', 'MX3S-012', 'AVAILABLE', NULL, NULL, '2026-04-02', 2350000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000012');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000013', 'default', 'Samsung Galaxy S25', 'Phone', 'SGS25-013', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000013', '2026-05-23', '2026-05-15', 23990000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000013');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000014', 'default', 'May chieu Epson EB-FH52', 'Projector', 'EPSON-014', 'AVAILABLE', NULL, NULL, '2025-12-05', 18500000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000014');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000015', 'default', 'Router Cisco Meraki MX68', 'Network', 'MX68-015', 'ASSIGNED', 'b1000000-0000-4000-8000-000000000019', '2026-03-01', '2026-02-20', 38900000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000015');
INSERT INTO asset (id, tenant_id, name, category, serial_number, status, assigned_to, assigned_date, purchase_date, purchase_price, created_at, updated_at)
SELECT '26b00000-0000-4000-8000-000000000016', 'default', 'Ban nang ha FlexiSpot', 'Office', 'FLEXI-016', 'RETIRED', NULL, NULL, '2022-08-12', 7200000, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM asset WHERE id = '26b00000-0000-4000-8000-000000000016');

-- EXTRA INTERVIEWS AND ANNOUNCEMENTS
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000006', 'default', 'e1000000-0000-4000-8000-000000000006', 'b1000000-0000-4000-8000-000000000009', '2026-06-09T07:00:00Z', 'Phong hop Hanoi 02', NULL, NULL, NULL, 'SCHEDULED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000006');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000007', 'default', 'e1000000-0000-4000-8000-000000000007', 'b1000000-0000-4000-8000-000000000010', '2026-06-10T08:00:00Z', 'Google Meet', 'https://meet.google.com/demo-hrms-007', 'Can bo sung kinh nghiem stakeholder management.', 3, 'COMPLETED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000007');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000008', 'default', 'e1000000-0000-4000-8000-000000000008', 'b1000000-0000-4000-8000-000000000011', '2026-06-11T02:30:00Z', 'Phong hop HCM 01', NULL, NULL, NULL, 'SCHEDULED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000008');
INSERT INTO interview (id, tenant_id, application_id, interviewer_id, scheduled_at, location, meeting_link, feedback, rating, status, created_at, updated_at)
SELECT '26700000-0000-4000-8000-000000000009', 'default', 'e1000000-0000-4000-8000-000000000009', 'b1000000-0000-4000-8000-000000000012', '2026-06-12T04:00:00Z', 'Google Meet', 'https://meet.google.com/demo-hrms-009', NULL, NULL, 'CANCELLED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM interview WHERE id = '26700000-0000-4000-8000-000000000009');

INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000006', 'default', 'b1000000-0000-4000-8000-000000000001', 'Cap nhat quy trinh de xuat mua sam', 'Tu thang 07/2026, yeu cau mua sam tai san can gan ma phong ban va nguoi phe duyet.', '2026-06-15T02:00:00Z', '2026-07-31T16:59:59Z', 'NORMAL', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000006');
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000007', 'default', 'b1000000-0000-4000-8000-000000000004', 'Bao tri he thong HRMS', 'He thong HRMS bao tri tu 22:00 den 23:30 ngay 2026-06-07.', '2026-06-04T02:00:00Z', '2026-06-08T16:59:59Z', 'HIGH', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000007');
INSERT INTO announcement (id, tenant_id, author_id, title, content, publish_at, expire_at, priority, created_at, updated_at)
SELECT '26300000-0000-4000-8000-000000000008', 'default', 'b1000000-0000-4000-8000-000000000010', 'Ngay hoi suc khoe nhan vien', 'Dang ky kham suc khoe dinh ky tai van phong truoc ngay 2026-06-20.', '2026-06-06T02:00:00Z', '2026-06-21T16:59:59Z', 'LOW', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM announcement WHERE id = '26300000-0000-4000-8000-000000000008');

-- EXTRA AUDIT LOGS
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000007', 'default', 'b1000000-0000-4000-8000-000000000001', 'UPDATE', 'EMPLOYEE', 'b1000000-0000-4000-8000-000000000014', 'Updated employee profile contact information.', '10.10.1.22', TIMESTAMP '2026-06-04 08:10:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000007');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000008', 'default', 'b1000000-0000-4000-8000-000000000004', 'CREATE', 'COURSE', '26800000-0000-4000-8000-000000000006', 'Created First-time Manager Essentials course.', '10.10.2.19', TIMESTAMP '2026-06-04 08:20:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000008');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000009', 'default', 'b1000000-0000-4000-8000-000000000003', 'REJECT', 'TIME_ENTRY', '26000000-0000-4000-8000-000000000023', 'Rejected late checkout record pending correction.', '10.10.1.36', TIMESTAMP '2026-06-04 08:30:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000009');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000010', 'default', 'b1000000-0000-4000-8000-000000000002', 'CREATE', 'ONBOARDING_TASK', '26600000-0000-4000-8000-000000000006', 'Created onboarding task for new manager.', '10.10.3.13', TIMESTAMP '2026-06-04 08:40:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000010');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000011', 'default', 'b1000000-0000-4000-8000-000000000004', 'CREATE', 'ASSET', '26b00000-0000-4000-8000-000000000014', 'Created projector asset record.', '10.10.2.45', TIMESTAMP '2026-06-04 08:50:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000011');
INSERT INTO audit_log (id, tenant_id, actor_id, action, entity_type, entity_id, details, ip_address, created_at, updated_at)
SELECT '26c00000-0000-4000-8000-000000000012', 'default', 'b1000000-0000-4000-8000-000000000001', 'DELETE', 'DOCUMENT', '26100000-0000-4000-8000-000000000016', 'Removed duplicate handover document from profile.', '10.10.1.23', TIMESTAMP '2026-06-04 09:00:00', now()
WHERE NOT EXISTS (SELECT 1 FROM audit_log WHERE id = '26c00000-0000-4000-8000-000000000012');

