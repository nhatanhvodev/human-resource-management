-- ============================================================================
-- V17: Seed comprehensive Vietnamese HRMS sample data
-- Seeds all new tables from V11-V16 with realistic Vietnamese demo data.
-- Compatible with H2 (dev/test) and PostgreSQL (production).
-- Uses INSERT ... SELECT WHERE NOT EXISTS for idempotent reruns.
-- ============================================================================

-- ============================================================================
-- SECTION 1: POSITIONS (20 unique position codes across departments)
-- UUID: p0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', 'DIR', N'Giám đốc Nhân sự',
       'a1000000-0000-4000-8000-000000000001', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000001');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', 'MGR', N'Trưởng phòng CNTT',
       'a1000000-0000-4000-8000-000000000002', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000002');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', 'DEPUTY', N'Phó phòng Tài chính',
       'a1000000-0000-4000-8000-000000000003', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000003');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000004', 'default', 'LEAD', N'Trưởng nhóm Kinh doanh',
       'a1000000-0000-4000-8000-000000000004', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000004');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000005', 'default', 'SENIOR', N'Chuyên viên Cao cấp Marketing',
       'a1000000-0000-4000-8000-000000000005', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000005');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000006', 'default', 'STAFF', N'Chuyên viên Vận hành',
       'a1000000-0000-4000-8000-000000000006', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000006');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000007', 'default', 'JUNIOR', N'Nhân viên Nghiên cứu',
       'a1000000-0000-4000-8000-000000000007', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000007');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000008', 'default', 'INTERN', N'Thực tập Pháp chế',
       'a1000000-0000-4000-8000-000000000008', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000008');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000009', 'default', 'DEV', N'Lập trình viên CSKH',
       'a1000000-0000-4000-8000-000000000009', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000009');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000010', 'default', 'QA_ENG', N'Kỹ sư Chất lượng',
       'a1000000-0000-4000-8000-000000000010', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000010');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000011', 'default', 'BA', N'Phân tích Nghiệp vụ',
       'a1000000-0000-4000-8000-000000000011', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000011');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000012', 'default', 'ACC', N'Kế toán Đào tạo',
       'a1000000-0000-4000-8000-000000000012', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000012');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000013', 'default', 'SALES_REP', N'Nhân viên Kinh doanh Dữ liệu',
       'a1000000-0000-4000-8000-000000000013', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000013');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000014', 'default', 'CS_REP', N'Nhân viên CSKH Sản phẩm',
       'a1000000-0000-4000-8000-000000000014', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000014');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000015', 'default', 'HR_SPEC', N'Chuyên viên Nhân sự Bảo mật',
       'a1000000-0000-4000-8000-000000000015', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000015');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000016', 'default', 'DESIGNER', N'Thiết kế Dự án',
       'a1000000-0000-4000-8000-000000000016', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000016');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000017', 'default', 'CONTENT', N'Sáng tạo Nội dung',
       'a1000000-0000-4000-8000-000000000001', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000017');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000018', 'default', 'DATA_ENG', N'Kỹ sư Dữ liệu',
       'a1000000-0000-4000-8000-000000000002', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000018');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000019', 'default', 'SEC_ENG', N'Kỹ sư Bảo mật',
       'a1000000-0000-4000-8000-000000000003', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000019');

INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000020', 'default', 'DRIVER', N'Quản trị Hệ thống',
       'a1000000-0000-4000-8000-000000000004', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM position WHERE id = 'a0100000-0000-4000-8000-000000000020');

-- ============================================================================
-- SECTION 2: UPDATE existing EMP001-EMP048 with extended profile fields
-- Email format: lower(no-diacritics).@company.vn
-- Position mapping by department: HR->DIR/CONTENT, IT->MGR/DATA_ENG, FIN->DEPUTY/SEC_ENG,
--   SALES->LEAD/DRIVER, MKT->SENIOR, OPS->STAFF, RND->JUNIOR, LEGAL->INTERN,
--   CS->DEV, QA->QA_ENG, ADMIN->BA, TRAINING->ACC, DATA->SALES_REP,
--   PRODUCT->CS_REP, SECURITY->HR_SPEC, PMO->DESIGNER
-- ============================================================================

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000001',
  email = 'nguyen.van.an@company.vn', phone = '0903123456',
  date_of_birth = '1985-05-12', gender = 'MALE', national_id = '085012345678',
  address = N'Hà Nội', bank_account = '1234567890123', tax_code = '8501234567'
WHERE tenant_id = 'default' AND employee_no = 'EMP001';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017',
  email = 'tran.thi.bich.ngoc@company.vn', phone = '0914234567',
  date_of_birth = '1987-11-23', gender = 'FEMALE', national_id = '087112301234',
  address = N'TP. Hồ Chí Minh', bank_account = '2345678901234', tax_code = '8711230123'
WHERE tenant_id = 'default' AND employee_no = 'EMP002';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017',
  email = 'le.hoang.minh@company.vn', phone = '0985123987',
  date_of_birth = '1990-03-08', gender = 'MALE', national_id = '090030845679',
  address = N'Đà Nẵng', bank_account = '3456789012345', tax_code = '9003084567'
WHERE tenant_id = 'default' AND employee_no = 'EMP003';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000002',
  email = 'pham.thi.huong@company.vn', phone = '0976234111',
  date_of_birth = '1988-08-15', gender = 'FEMALE', national_id = '088081512345',
  address = N'Hà Nội', bank_account = '4567890123456', tax_code = '8808151234'
WHERE tenant_id = 'default' AND employee_no = 'EMP004';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018',
  email = 'vu.duc.anh@company.vn', phone = '0398123456',
  date_of_birth = '1992-07-19', gender = 'MALE', national_id = '092071945678',
  address = N'Hà Nội', bank_account = '5678901234567', tax_code = '9207194567'
WHERE tenant_id = 'default' AND employee_no = 'EMP005';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018',
  email = 'do.quang.huy@company.vn', phone = '0389123567',
  date_of_birth = '1991-02-28', gender = 'MALE', national_id = '091022865432',
  address = N'TP. Hồ Chí Minh', bank_account = '6789012345678', tax_code = '9102285432'
WHERE tenant_id = 'default' AND employee_no = 'EMP006';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018',
  email = 'ngo.thi.lan.anh@company.vn', phone = '0367890123',
  date_of_birth = '1993-12-05', gender = 'FEMALE', national_id = '093120567890',
  address = N'Đà Nẵng', bank_account = '7890123456789', tax_code = '9312056789'
WHERE tenant_id = 'default' AND employee_no = 'EMP007';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018',
  email = 'hoang.xuan.son@company.vn', phone = '0356789012',
  date_of_birth = '1989-09-14', gender = 'MALE', national_id = '089091478901',
  address = N'Hải Phòng', bank_account = '8901234567890', tax_code = '8909147890'
WHERE tenant_id = 'default' AND employee_no = 'EMP008';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018',
  email = 'bui.khanh.duy@company.vn', phone = '0909988776',
  date_of_birth = '1998-04-22', gender = 'MALE', national_id = '098042211223',
  address = N'Hà Nội', bank_account = '9012345678901', tax_code = '9804221122'
WHERE tenant_id = 'default' AND employee_no = 'EMP009';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000003',
  email = 'dinh.thi.thu.ha@company.vn', phone = '0917654321',
  date_of_birth = '1996-06-10', gender = 'FEMALE', national_id = '096061032109',
  address = N'TP. Hồ Chí Minh', bank_account = '0123456789012', tax_code = '9606103210'
WHERE tenant_id = 'default' AND employee_no = 'EMP010';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000003',
  email = 'trinh.van.khang@company.vn', phone = '0987654321',
  date_of_birth = '1986-01-30', gender = 'MALE', national_id = '086013056789',
  address = N'Hà Nội', bank_account = '1122334455667', tax_code = '8601305678'
WHERE tenant_id = 'default' AND employee_no = 'EMP011';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000004',
  email = 'ly.thi.mai@company.vn', phone = '0971122334',
  date_of_birth = '1990-10-15', gender = 'FEMALE', national_id = '090101523456',
  address = N'TP. Hồ Chí Minh', bank_account = '2233445566778', tax_code = '9010152345'
WHERE tenant_id = 'default' AND employee_no = 'EMP012';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020',
  email = 'duong.quoc.bao@company.vn', phone = '0392233445',
  date_of_birth = '1991-05-20', gender = 'MALE', national_id = '091052098765',
  address = N'Cần Thơ', bank_account = '3344556677889', tax_code = '9105209876'
WHERE tenant_id = 'default' AND employee_no = 'EMP013';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005',
  email = 'ta.thi.yen@company.vn', phone = '0383344556',
  date_of_birth = '1999-11-08', gender = 'FEMALE', national_id = '099110812345',
  address = N'Hà Nội', bank_account = '4455667788990', tax_code = '9911081234'
WHERE tenant_id = 'default' AND employee_no = 'EMP014';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005',
  email = 'nguyen.minh.tu@company.vn', phone = '0905566778',
  date_of_birth = '1988-03-25', gender = 'MALE', national_id = '088032587654',
  address = N'TP. Hồ Chí Minh', bank_account = '5566778899001', tax_code = '8803258765'
WHERE tenant_id = 'default' AND employee_no = 'EMP015';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020',
  email = 'phan.thanh.tung@company.vn', phone = '0916677889',
  date_of_birth = '1993-07-14', gender = 'MALE', national_id = '093071421098',
  address = N'Đà Nẵng', bank_account = '6677889900112', tax_code = '9307142109'
WHERE tenant_id = 'default' AND employee_no = 'EMP016';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005',
  email = 'ho.thi.diem@company.vn', phone = '0978899001',
  date_of_birth = '1992-02-18', gender = 'FEMALE', national_id = '092021890123',
  address = N'Hà Nội', bank_account = '7788990011223', tax_code = '9202189012'
WHERE tenant_id = 'default' AND employee_no = 'EMP017';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006',
  email = 'vo.hoai.nam@company.vn', phone = '0399900112',
  date_of_birth = '1987-08-03', gender = 'MALE', national_id = '087080398765',
  address = N'TP. Hồ Chí Minh', bank_account = '8899001122334', tax_code = '8708039876'
WHERE tenant_id = 'default' AND employee_no = 'EMP018';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006',
  email = 'truong.thi.thao@company.vn', phone = '0360011223',
  date_of_birth = '1994-09-21', gender = 'FEMALE', national_id = '094092121098',
  address = N'Hải Phòng', bank_account = '9900112233445', tax_code = '9409212109'
WHERE tenant_id = 'default' AND employee_no = 'EMP019';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006',
  email = 'luu.van.phong@company.vn', phone = '0351122334',
  date_of_birth = '1986-06-27', gender = 'MALE', national_id = '086062743219',
  address = N'Hà Nội', bank_account = '0011223344556', tax_code = '8606274321'
WHERE tenant_id = 'default' AND employee_no = 'EMP020';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007',
  email = 'mai.thi.kim.oanh@company.vn', phone = '0902233445',
  date_of_birth = '1995-04-12', gender = 'FEMALE', national_id = '095041234567',
  address = N'Cần Thơ', bank_account = '1122334455667', tax_code = '9504123456'
WHERE tenant_id = 'default' AND employee_no = 'EMP021';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007',
  email = 'cao.tuan.kiet@company.vn', phone = '0913344556',
  date_of_birth = '1993-11-30', gender = 'MALE', national_id = '093113076543',
  address = N'TP. Hồ Chí Minh', bank_account = '2233445566778', tax_code = '9311307654'
WHERE tenant_id = 'default' AND employee_no = 'EMP022';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007',
  email = 'dang.thi.hien@company.vn', phone = '0984455667',
  date_of_birth = '1996-01-05', gender = 'FEMALE', national_id = '096010598765',
  address = N'Đà Nẵng', bank_account = '3344556677889', tax_code = '9601059876'
WHERE tenant_id = 'default' AND employee_no = 'EMP023';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008',
  email = 'ngo.quang.dung@company.vn', phone = '0395566778',
  date_of_birth = '1998-05-17', gender = 'MALE', national_id = '098051743219',
  address = N'Hà Nội', bank_account = '4455667788990', tax_code = '9805174321'
WHERE tenant_id = 'default' AND employee_no = 'EMP024';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008',
  email = 'bui.thi.nhu.quynh@company.vn', phone = '0366677889',
  date_of_birth = '1997-09-09', gender = 'FEMALE', national_id = '097090921098',
  address = N'TP. Hồ Chí Minh', bank_account = '5566778899001', tax_code = '9709092109'
WHERE tenant_id = 'default' AND employee_no = 'EMP025';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009',
  email = 'nguyen.thanh.trung@company.vn', phone = '0907788990',
  date_of_birth = '1990-12-03', gender = 'MALE', national_id = '090120378901',
  address = N'Hà Nội', bank_account = '6677889900112', tax_code = '9012037890'
WHERE tenant_id = 'default' AND employee_no = 'EMP026';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009',
  email = 'tran.thi.ai.van@company.vn', phone = '0918899001',
  date_of_birth = '1992-06-15', gender = 'FEMALE', national_id = '092061534210',
  address = N'TP. Hồ Chí Minh', bank_account = '7788990011223', tax_code = '9206153421'
WHERE tenant_id = 'default' AND employee_no = 'EMP027';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009',
  email = 'le.thi.ngoc.han@company.vn', phone = '0989900112',
  date_of_birth = '1993-08-20', gender = 'FEMALE', national_id = '093082078901',
  address = N'Đà Nẵng', bank_account = '8899001122334', tax_code = '9308207890'
WHERE tenant_id = 'default' AND employee_no = 'EMP028';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010',
  email = 'pham.van.toan@company.vn', phone = '0390011223',
  date_of_birth = '1991-04-28', gender = 'MALE', national_id = '091042854321',
  address = N'Hà Nội', bank_account = '9900112233445', tax_code = '9104285432'
WHERE tenant_id = 'default' AND employee_no = 'EMP029';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010',
  email = 'hoang.thi.thu.trang@company.vn', phone = '0361122334',
  date_of_birth = '1997-03-11', gender = 'FEMALE', national_id = '097031178901',
  address = N'TP. Hồ Chí Minh', bank_account = '0011223344556', tax_code = '9703117890'
WHERE tenant_id = 'default' AND employee_no = 'EMP030';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011',
  email = 'nguyen.thi.thanh.truc@company.vn', phone = '0903344556',
  date_of_birth = '1992-10-14', gender = 'FEMALE', national_id = '092101432109',
  address = N'Cần Thơ', bank_account = '1122334455667', tax_code = '9210143210'
WHERE tenant_id = 'default' AND employee_no = 'EMP031';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011',
  email = 'le.gia.bao@company.vn', phone = '0914455667',
  date_of_birth = '1994-07-22', gender = 'MALE', national_id = '094072267890',
  address = N'Hà Nội', bank_account = '2233445566778', tax_code = '9407226789'
WHERE tenant_id = 'default' AND employee_no = 'EMP032';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012',
  email = 'pham.minh.chau@company.vn', phone = '0985566778',
  date_of_birth = '1990-02-08', gender = 'FEMALE', national_id = '090020843219',
  address = N'TP. Hồ Chí Minh', bank_account = '3344556677889', tax_code = '9002084321'
WHERE tenant_id = 'default' AND employee_no = 'EMP033';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012',
  email = 'tran.quoc.hung@company.vn', phone = '0396677889',
  date_of_birth = '1989-11-18', gender = 'MALE', national_id = '089111898765',
  address = N'Đà Nẵng', bank_account = '4455667788990', tax_code = '8911189876'
WHERE tenant_id = 'default' AND employee_no = 'EMP034';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010',
  email = 'vo.thi.my.linh@company.vn', phone = '0367788990',
  date_of_birth = '1995-05-29', gender = 'FEMALE', national_id = '095052912345',
  address = N'Hà Nội', bank_account = '5566778899001', tax_code = '9505291234'
WHERE tenant_id = 'default' AND employee_no = 'EMP035';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006',
  email = 'dang.minh.nhat@company.vn', phone = '0908899001',
  date_of_birth = '2000-08-14', gender = 'MALE', national_id = '000081489012',
  address = N'TP. Hồ Chí Minh', bank_account = '6677889900112', tax_code = '0008148901'
WHERE tenant_id = 'default' AND employee_no = 'EMP036';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000013',
  email = 'lam.khanh.vy@company.vn', phone = '0919900112',
  date_of_birth = '1993-09-16', gender = 'FEMALE', national_id = '093091643219',
  address = N'Hà Nội', bank_account = '7788990011223', tax_code = '9309164321'
WHERE tenant_id = 'default' AND employee_no = 'EMP037';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000013',
  email = 'nguyen.duc.manh@company.vn', phone = '0980011223',
  date_of_birth = '1991-12-25', gender = 'MALE', national_id = '091122510987',
  address = N'TP. Hồ Chí Minh', bank_account = '8899001122334', tax_code = '9112251098'
WHERE tenant_id = 'default' AND employee_no = 'EMP038';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014',
  email = 'tran.huu.phuoc@company.vn', phone = '0391122334',
  date_of_birth = '1987-06-07', gender = 'MALE', national_id = '087060734210',
  address = N'Đà Nẵng', bank_account = '9900112233445', tax_code = '8706073421'
WHERE tenant_id = 'default' AND employee_no = 'EMP039';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014',
  email = 'phan.thao.nguyen@company.vn', phone = '0362233445',
  date_of_birth = '1994-01-09', gender = 'FEMALE', national_id = '094010998765',
  address = N'Hà Nội', bank_account = '0011223344556', tax_code = '9401099876'
WHERE tenant_id = 'default' AND employee_no = 'EMP040';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015',
  email = 'do.minh.quan@company.vn', phone = '0904455667',
  date_of_birth = '1988-04-03', gender = 'MALE', national_id = '088040332109',
  address = N'TP. Hồ Chí Minh', bank_account = '1122334455667', tax_code = '8804033210'
WHERE tenant_id = 'default' AND employee_no = 'EMP041';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015',
  email = 'huynh.ngoc.thien@company.vn', phone = '0915566778',
  date_of_birth = '1995-10-31', gender = 'MALE', national_id = '095103110987',
  address = N'Hà Nội', bank_account = '2233445566778', tax_code = '9510311098'
WHERE tenant_id = 'default' AND employee_no = 'EMP042';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016',
  email = 'vu.thanh.tam@company.vn', phone = '0986677889',
  date_of_birth = '1986-07-26', gender = 'FEMALE', national_id = '086072654321',
  address = N'Đà Nẵng', bank_account = '3344556677889', tax_code = '8607265432'
WHERE tenant_id = 'default' AND employee_no = 'EMP043';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016',
  email = 'to.minh.hoang@company.vn', phone = '0397788990',
  date_of_birth = '1992-08-11', gender = 'MALE', national_id = '092081189012',
  address = N'TP. Hồ Chí Minh', bank_account = '4455667788990', tax_code = '9208118901'
WHERE tenant_id = 'default' AND employee_no = 'EMP044';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000001',
  email = 'dang.hong.nhung@company.vn', phone = '0368899001',
  date_of_birth = '1991-03-24', gender = 'FEMALE', national_id = '091032421098',
  address = N'Hà Nội', bank_account = '5566778899001', tax_code = '9103242109'
WHERE tenant_id = 'default' AND employee_no = 'EMP045';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000003',
  email = 'nguyen.quynh.chi@company.vn', phone = '0909900112',
  date_of_birth = '1993-05-06', gender = 'FEMALE', national_id = '093050698765',
  address = N'TP. Hồ Chí Minh', bank_account = '6677889900112', tax_code = '9305069876'
WHERE tenant_id = 'default' AND employee_no = 'EMP046';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006',
  email = 'le.quoc.viet@company.vn', phone = '0910011223',
  date_of_birth = '1997-02-13', gender = 'MALE', national_id = '097021354321',
  address = N'Hà Nội', bank_account = '7788990011223', tax_code = '9702135432'
WHERE tenant_id = 'default' AND employee_no = 'EMP047';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009',
  email = 'mai.gia.han@company.vn', phone = '0981122334',
  date_of_birth = '1996-11-22', gender = 'FEMALE', national_id = '096112209876',
  address = N'Cần Thơ', bank_account = '8899001122334', tax_code = '9611220987'
WHERE tenant_id = 'default' AND employee_no = 'EMP048';

-- ============================================================================
-- SECTION 3: NEW EMPLOYEES (EMP049-EMP130, 82 employees across 16 departments)
-- UUID: b1000000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

-- HR (001): EMP049-EMP053
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000049', 'default', 'EMP049', N'Trần Văn Hải', 'a1000000-0000-4000-8000-000000000001', '2019-08-12', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP049');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000050', 'default', 'EMP050', N'Phạm Thị Ngọc Mai', 'a1000000-0000-4000-8000-000000000001', '2020-03-21', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP050');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000051', 'default', 'EMP051', N'Ngô Quốc Đạt', 'a1000000-0000-4000-8000-000000000001', '2021-11-15', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP051');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000052', 'default', 'EMP052', N'Lê Thị Thanh Hà', 'a1000000-0000-4000-8000-000000000001', '2022-07-04', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP052');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000053', 'default', 'EMP053', N'Vũ Mạnh Cường', 'a1000000-0000-4000-8000-000000000001', '2024-02-19', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP053');

-- IT (002): EMP054-EMP059
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000054', 'default', 'EMP054', N'Hoàng Văn Nhật', 'a1000000-0000-4000-8000-000000000002', '2018-09-03', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP054');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000055', 'default', 'EMP055', N'Đỗ Thị Thu Thủy', 'a1000000-0000-4000-8000-000000000002', '2019-04-17', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP055');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000056', 'default', 'EMP056', N'Nguyễn Đình Phong', 'a1000000-0000-4000-8000-000000000002', '2020-10-28', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP056');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000057', 'default', 'EMP057', N'Trịnh Thanh Sơn', 'a1000000-0000-4000-8000-000000000002', '2021-06-09', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP057');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000058', 'default', 'EMP058', N'Lâm Thị Phương Anh', 'a1000000-0000-4000-8000-000000000002', '2022-12-12', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP058');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000059', 'default', 'EMP059', N'Quách Hữu Thắng', 'a1000000-0000-4000-8000-000000000002', '2023-08-01', 'INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP059');

-- FIN (003): EMP060-EMP064
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000060', 'default', 'EMP060', N'Nguyễn Thị Hồng Loan', 'a1000000-0000-4000-8000-000000000003', '2019-11-11', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP060');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000061', 'default', 'EMP061', N'Trần Thanh Liêm', 'a1000000-0000-4000-8000-000000000003', '2020-06-23', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP061');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000062', 'default', 'EMP062', N'Phạm Ngọc Bích', 'a1000000-0000-4000-8000-000000000003', '2021-02-09', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP062');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000063', 'default', 'EMP063', N'Lê Đức Tài', 'a1000000-0000-4000-8000-000000000003', '2023-05-30', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP063');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000064', 'default', 'EMP064', N'Đặng Thị Cẩm Tú', 'a1000000-0000-4000-8000-000000000003', '2024-04-14', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP064');

-- SALES (004): EMP065-EMP070
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000065', 'default', 'EMP065', N'Nguyễn Hoàng Việt', 'a1000000-0000-4000-8000-000000000004', '2018-12-03', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP065');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000066', 'default', 'EMP066', N'Trần Thị Kim Chi', 'a1000000-0000-4000-8000-000000000004', '2020-02-14', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP066');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000067', 'default', 'EMP067', N'Võ Văn Thịnh', 'a1000000-0000-4000-8000-000000000004', '2021-04-26', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP067');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000068', 'default', 'EMP068', N'Lý Ngọc Huyền', 'a1000000-0000-4000-8000-000000000004', '2022-09-18', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP068');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000069', 'default', 'EMP069', N'Hà Minh Trí', 'a1000000-0000-4000-8000-000000000004', '2023-11-25', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP069');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000070', 'default', 'EMP070', N'Dương Thị Thu Vân', 'a1000000-0000-4000-8000-000000000004', '2025-01-06', 'INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP070');

-- MKT (005): EMP071-EMP075
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000071', 'default', 'EMP071', N'Bùi Xuân Trường', 'a1000000-0000-4000-8000-000000000005', '2019-07-15', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP071');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000072', 'default', 'EMP072', N'Nguyễn Thị Hải Yến', 'a1000000-0000-4000-8000-000000000005', '2020-10-05', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP072');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000073', 'default', 'EMP073', N'Mai Tấn Lộc', 'a1000000-0000-4000-8000-000000000005', '2021-08-18', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP073');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000074', 'default', 'EMP074', N'Tạ Thị Minh Thư', 'a1000000-0000-4000-8000-000000000005', '2023-01-30', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP074');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000075', 'default', 'EMP075', N'Hồ Đức Thành', 'a1000000-0000-4000-8000-000000000005', '2024-06-03', 'INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP075');

-- OPS (006): EMP076-EMP080
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000076', 'default', 'EMP076', N'Trần Văn Đông', 'a1000000-0000-4000-8000-000000000006', '2018-05-21', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP076');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000077', 'default', 'EMP077', N'Lê Thị Thanh Xuân', 'a1000000-0000-4000-8000-000000000006', '2020-08-11', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP077');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000078', 'default', 'EMP078', N'Nguyễn Công Hậu', 'a1000000-0000-4000-8000-000000000006', '2021-06-14', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP078');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000079', 'default', 'EMP079', N'Phạm Thị Kiều My', 'a1000000-0000-4000-8000-000000000006', '2023-03-08', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP079');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000080', 'default', 'EMP080', N'Đinh Hoàng Long', 'a1000000-0000-4000-8000-000000000006', '2024-10-07', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP080');

-- RND (007): EMP081-EMP085
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000081', 'default', 'EMP081', N'Lý Chấn Hưng', 'a1000000-0000-4000-8000-000000000007', '2019-10-14', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP081');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000082', 'default', 'EMP082', N'Nguyễn Thị Bảo Trân', 'a1000000-0000-4000-8000-000000000007', '2020-04-02', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP082');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000083', 'default', 'EMP083', N'Tô Quốc Thái', 'a1000000-0000-4000-8000-000000000007', '2021-12-20', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP083');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000084', 'default', 'EMP084', N'Trần Thị Thùy Dung', 'a1000000-0000-4000-8000-000000000007', '2023-07-24', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP084');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000085', 'default', 'EMP085', N'Đặng Hữu Nghĩa', 'a1000000-0000-4000-8000-000000000007', '2025-02-17', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP085');

-- LEGAL (008): EMP086-EMP090
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000086', 'default', 'EMP086', N'Huỳnh Thanh Phong', 'a1000000-0000-4000-8000-000000000008', '2020-11-09', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP086');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000087', 'default', 'EMP087', N'Vũ Thị Hoài An', 'a1000000-0000-4000-8000-000000000008', '2022-04-25', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP087');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000088', 'default', 'EMP088', N'Lâm Quốc Vinh', 'a1000000-0000-4000-8000-000000000008', '2023-09-11', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP088');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000089', 'default', 'EMP089', N'Quách Thị Ngọc Diệp', 'a1000000-0000-4000-8000-000000000008', '2024-07-16', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP089');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000090', 'default', 'EMP090', N'Nguyễn Tiến Đạt', 'a1000000-0000-4000-8000-000000000008', '2025-03-03', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP090');

-- CS (009): EMP091-EMP095
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000091', 'default', 'EMP091', N'Trần Thị Tuyết Mai', 'a1000000-0000-4000-8000-000000000009', '2019-06-10', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP091');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000092', 'default', 'EMP092', N'Đỗ Anh Khoa', 'a1000000-0000-4000-8000-000000000009', '2020-12-01', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP092');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000093', 'default', 'EMP093', N'Phạm Thị Hồng Nhung', 'a1000000-0000-4000-8000-000000000009', '2022-03-14', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP093');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000094', 'default', 'EMP094', N'Ngô Thành Danh', 'a1000000-0000-4000-8000-000000000009', '2023-06-19', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP094');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000095', 'default', 'EMP095', N'Bùi Thị Mỹ Duyên', 'a1000000-0000-4000-8000-000000000009', '2024-11-04', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP095');

-- QA (010): EMP096-EMP100
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000096', 'default', 'EMP096', N'Hà Tấn Phát', 'a1000000-0000-4000-8000-000000000010', '2020-05-12', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP096');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000097', 'default', 'EMP097', N'Lê Thị Ngọc Ánh', 'a1000000-0000-4000-8000-000000000010', '2021-08-23', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP097');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000098', 'default', 'EMP098', N'Vũ Đình Hùng', 'a1000000-0000-4000-8000-000000000010', '2022-10-31', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP098');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000099', 'default', 'EMP099', N'Trịnh Thị Thanh Nhàn', 'a1000000-0000-4000-8000-000000000010', '2023-12-15', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP099');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000100', 'default', 'EMP100', N'Tô Quang Hải', 'a1000000-0000-4000-8000-000000000010', '2025-03-10', 'INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP100');

-- ADMIN (011): EMP101-EMP105
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000101', 'default', 'EMP101', N'Mai Xuân Bắc', 'a1000000-0000-4000-8000-000000000011', '2020-01-20', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP101');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000102', 'default', 'EMP102', N'Đặng Thị Hạnh Dung', 'a1000000-0000-4000-8000-000000000011', '2021-07-05', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP102');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000103', 'default', 'EMP103', N'Dương Văn Hòa', 'a1000000-0000-4000-8000-000000000011', '2023-02-13', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP103');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000104', 'default', 'EMP104', N'Nguyễn Thị Mai Lan', 'a1000000-0000-4000-8000-000000000011', '2024-01-08', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP104');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000105', 'default', 'EMP105', N'Hoàng Gia Khiêm', 'a1000000-0000-4000-8000-000000000011', '2024-09-22', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP105');

-- TRAINING (012): EMP106-EMP110
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000106', 'default', 'EMP106', N'Lý Nhật Quang', 'a1000000-0000-4000-8000-000000000012', '2019-03-25', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP106');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000107', 'default', 'EMP107', N'Phan Thị Tường Vy', 'a1000000-0000-4000-8000-000000000012', '2020-09-14', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP107');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000108', 'default', 'EMP108', N'Nguyễn Khắc Tuấn', 'a1000000-0000-4000-8000-000000000012', '2022-05-06', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP108');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000109', 'default', 'EMP109', N'Đỗ Thị Mộng Thu', 'a1000000-0000-4000-8000-000000000012', '2023-07-17', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP109');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000110', 'default', 'EMP110', N'Võ Thanh Tùng', 'a1000000-0000-4000-8000-000000000012', '2024-12-02', 'INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP110');

-- DATA (013): EMP111-EMP114
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000111', 'default', 'EMP111', N'Trần Cao Sỹ', 'a1000000-0000-4000-8000-000000000013', '2020-04-08', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP111');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000112', 'default', 'EMP112', N'Nguyễn Thị Uyên Nhi', 'a1000000-0000-4000-8000-000000000013', '2021-09-28', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP112');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000113', 'default', 'EMP113', N'Lê Hồng Quân', 'a1000000-0000-4000-8000-000000000013', '2022-11-07', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP113');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000114', 'default', 'EMP114', N'Quách Thị Hồng Đào', 'a1000000-0000-4000-8000-000000000013', '2024-04-29', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP114');

-- PRODUCT (014): EMP115-EMP119
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000115', 'default', 'EMP115', N'Đặng Nhật Huy', 'a1000000-0000-4000-8000-000000000014', '2019-08-19', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP115');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000116', 'default', 'EMP116', N'Ngô Thị Thúy Hằng', 'a1000000-0000-4000-8000-000000000014', '2020-12-21', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP116');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000117', 'default', 'EMP117', N'Bùi Anh Tuấn', 'a1000000-0000-4000-8000-000000000014', '2022-06-13', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP117');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000118', 'default', 'EMP118', N'Lâm Thị Cát Tường', 'a1000000-0000-4000-8000-000000000014', '2023-08-04', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP118');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000119', 'default', 'EMP119', N'Hà Gia Huy', 'a1000000-0000-4000-8000-000000000014', '2025-03-17', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP119');

-- SECURITY (015): EMP120-EMP124
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000120', 'default', 'EMP120', N'Vũ Quốc Cường', 'a1000000-0000-4000-8000-000000000015', '2019-11-25', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP120');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000121', 'default', 'EMP121', N'Mai Thị Kim Ngân', 'a1000000-0000-4000-8000-000000000015', '2021-05-10', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP121');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000122', 'default', 'EMP122', N'Tô Đức Thắng', 'a1000000-0000-4000-8000-000000000015', '2022-10-17', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP122');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000123', 'default', 'EMP123', N'Nguyễn Thị Bảo Ngọc', 'a1000000-0000-4000-8000-000000000015', '2023-12-26', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP123');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000124', 'default', 'EMP124', N'Trịnh Công Danh', 'a1000000-0000-4000-8000-000000000015', '2024-09-09', 'INACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP124');

-- PMO (016): EMP125-EMP130
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000125', 'default', 'EMP125', N'Phạm Hữu Thọ', 'a1000000-0000-4000-8000-000000000016', '2018-07-30', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP125');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000126', 'default', 'EMP126', N'Đỗ Thị Ánh Nguyệt', 'a1000000-0000-4000-8000-000000000016', '2020-03-16', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP126');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000127', 'default', 'EMP127', N'Hồ Thanh Bình', 'a1000000-0000-4000-8000-000000000016', '2021-07-21', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP127');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000128', 'default', 'EMP128', N'Ngô Thị Xuân Mai', 'a1000000-0000-4000-8000-000000000016', '2022-12-05', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP128');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000129', 'default', 'EMP129', N'Lý Hoài Bảo', 'a1000000-0000-4000-8000-000000000016', '2024-02-12', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP129');
INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
SELECT 'b1000000-0000-4000-8000-000000000130', 'default', 'EMP130', N'Huỳnh Thị Diệu Hiền', 'a1000000-0000-4000-8000-000000000016', '2024-11-18', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = 'default' AND employee_no = 'EMP130');

-- ============================================================================
-- SECTION 4: UPDATE EMP049-EMP130 with extended profile fields
-- ============================================================================
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017', email = 'tran.van.hai@company.vn', phone = '0912010203', date_of_birth = '1987-04-15', gender = 'MALE', national_id = '087041501234', address = N'Hà Nội', bank_account = '1212121212121', tax_code = '8704150123' WHERE tenant_id = 'default' AND employee_no = 'EMP049';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017', email = 'pham.thi.ngoc.mai@company.vn', phone = '0901020304', date_of_birth = '1993-01-28', gender = 'FEMALE', national_id = '093012809876', address = N'TP. Hồ Chí Minh', bank_account = '2323232323232', tax_code = '9301289876' WHERE tenant_id = 'default' AND employee_no = 'EMP050';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017', email = 'ngo.quoc.dat@company.vn', phone = '0912030405', date_of_birth = '1995-09-12', gender = 'MALE', national_id = '095091256789', address = N'Đà Nẵng', bank_account = '3434343434343', tax_code = '9509125678' WHERE tenant_id = 'default' AND employee_no = 'EMP051';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017', email = 'le.thi.thanh.ha@company.vn', phone = '0903040506', date_of_birth = '1991-06-03', gender = 'FEMALE', national_id = '091060309876', address = N'Nghệ An', bank_account = '4545454545454', tax_code = '9106039876' WHERE tenant_id = 'default' AND employee_no = 'EMP052';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000017', email = 'vu.manh.cuong@company.vn', phone = '0914050607', date_of_birth = '1998-03-17', gender = 'MALE', national_id = '098031709876', address = N'Hà Nội', bank_account = '5656565656565', tax_code = '9803170987' WHERE tenant_id = 'default' AND employee_no = 'EMP053';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018', email = 'hoang.van.nhat@company.vn', phone = '0905060708', date_of_birth = '1986-11-22', gender = 'MALE', national_id = '086112245678', address = N'Hà Nội', bank_account = '6767676767676', tax_code = '8611224567' WHERE tenant_id = 'default' AND employee_no = 'EMP054';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018', email = 'do.thi.thu.thuy@company.vn', phone = '0916070809', date_of_birth = '1992-08-05', gender = 'FEMALE', national_id = '092080598765', address = N'TP. Hồ Chí Minh', bank_account = '7878787878787', tax_code = '9208059876' WHERE tenant_id = 'default' AND employee_no = 'EMP055';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018', email = 'nguyen.dinh.phong@company.vn', phone = '0907080910', date_of_birth = '1993-02-14', gender = 'MALE', national_id = '093021445678', address = N'Đà Nẵng', bank_account = '8989898989898', tax_code = '9302144567' WHERE tenant_id = 'default' AND employee_no = 'EMP056';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018', email = 'trinh.thanh.son@company.vn', phone = '0918091011', date_of_birth = '1990-12-30', gender = 'MALE', national_id = '090123045678', address = N'Hải Phòng', bank_account = '9090909090909', tax_code = '9012304567' WHERE tenant_id = 'default' AND employee_no = 'EMP057';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018', email = 'lam.thi.phuong.anh@company.vn', phone = '0909101112', date_of_birth = '1996-04-19', gender = 'FEMALE', national_id = '096041912345', address = N'Hà Nội', bank_account = '0101010101010', tax_code = '9604191234' WHERE tenant_id = 'default' AND employee_no = 'EMP058';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000018', email = 'quach.huu.thang@company.vn', phone = '0910111213', date_of_birth = '1999-07-08', gender = 'MALE', national_id = '099070854321', address = N'TP. Hồ Chí Minh', bank_account = '2121212121212', tax_code = '9907085432' WHERE tenant_id = 'default' AND employee_no = 'EMP059';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000019', email = 'nguyen.thi.hong.loan@company.vn', phone = '0911121314', date_of_birth = '1989-05-27', gender = 'FEMALE', national_id = '089052798765', address = N'Hà Nội', bank_account = '3232323232323', tax_code = '8905279876' WHERE tenant_id = 'default' AND employee_no = 'EMP060';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000019', email = 'tran.thanh.liem@company.vn', phone = '0902131415', date_of_birth = '1992-02-11', gender = 'MALE', national_id = '092021145678', address = N'TP. Hồ Chí Minh', bank_account = '4343434343434', tax_code = '9202114567' WHERE tenant_id = 'default' AND employee_no = 'EMP061';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000019', email = 'pham.ngoc.bich@company.vn', phone = '0913141516', date_of_birth = '1994-08-19', gender = 'FEMALE', national_id = '094081945678', address = N'Cần Thơ', bank_account = '5454545454545', tax_code = '9408194567' WHERE tenant_id = 'default' AND employee_no = 'EMP062';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000019', email = 'le.duc.tai@company.vn', phone = '0904151617', date_of_birth = '1996-03-22', gender = 'MALE', national_id = '096032298765', address = N'Hà Nội', bank_account = '6565656565656', tax_code = '9603229876' WHERE tenant_id = 'default' AND employee_no = 'EMP063';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000019', email = 'dang.thi.cam.tu@company.vn', phone = '0915161718', date_of_birth = '1997-10-14', gender = 'FEMALE', national_id = '097101434567', address = N'Đà Nẵng', bank_account = '7676767676767', tax_code = '9710143456' WHERE tenant_id = 'default' AND employee_no = 'EMP064';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020', email = 'nguyen.hoang.viet@company.vn', phone = '0906171819', date_of_birth = '1988-12-05', gender = 'MALE', national_id = '088120598765', address = N'TP. Hồ Chí Minh', bank_account = '8787878787878', tax_code = '8812059876' WHERE tenant_id = 'default' AND employee_no = 'EMP065';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020', email = 'tran.thi.kim.chi@company.vn', phone = '0917181920', date_of_birth = '1993-06-16', gender = 'FEMALE', national_id = '093061612345', address = N'Hà Nội', bank_account = '9898989898989', tax_code = '9306161234' WHERE tenant_id = 'default' AND employee_no = 'EMP066';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020', email = 'vo.van.thinh@company.vn', phone = '0908192021', date_of_birth = '1995-01-08', gender = 'MALE', national_id = '095010845678', address = N'Cần Thơ', bank_account = '0909090909090', tax_code = '9501084567' WHERE tenant_id = 'default' AND employee_no = 'EMP067';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020', email = 'ly.ngoc.huyen@company.vn', phone = '0919202122', date_of_birth = '1996-11-25', gender = 'FEMALE', national_id = '096112598765', address = N'Đà Nẵng', bank_account = '1010101010101', tax_code = '9611259876' WHERE tenant_id = 'default' AND employee_no = 'EMP068';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020', email = 'ha.minh.tri@company.vn', phone = '0900212223', date_of_birth = '1998-04-30', gender = 'MALE', national_id = '098043098765', address = N'TP. Hồ Chí Minh', bank_account = '3131313131313', tax_code = '9804309876' WHERE tenant_id = 'default' AND employee_no = 'EMP069';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000020', email = 'duong.thi.thu.van@company.vn', phone = '0911222324', date_of_birth = '2000-09-12', gender = 'FEMALE', national_id = '000091201234', address = N'Hà Nội', bank_account = '4242424242424', tax_code = '9009120123' WHERE tenant_id = 'default' AND employee_no = 'EMP070';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005', email = 'bui.xuan.truong@company.vn', phone = '0902232425', date_of_birth = '1989-02-18', gender = 'MALE', national_id = '089021845678', address = N'Hà Nội', bank_account = '5353535353535', tax_code = '8902184567' WHERE tenant_id = 'default' AND employee_no = 'EMP071';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005', email = 'nguyen.thi.hai.yen@company.vn', phone = '0913242526', date_of_birth = '1994-07-14', gender = 'FEMALE', national_id = '094071445678', address = N'TP. Hồ Chí Minh', bank_account = '6464646464646', tax_code = '9407144567' WHERE tenant_id = 'default' AND employee_no = 'EMP072';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005', email = 'mai.tan.loc@company.vn', phone = '0904252627', date_of_birth = '1996-09-22', gender = 'MALE', national_id = '096092287654', address = N'Đà Nẵng', bank_account = '7575757575757', tax_code = '9609228765' WHERE tenant_id = 'default' AND employee_no = 'EMP073';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005', email = 'ta.thi.minh.thu@company.vn', phone = '0915262728', date_of_birth = '1997-05-06', gender = 'FEMALE', national_id = '097050632109', address = N'Hải Phòng', bank_account = '8686868686868', tax_code = '9705063210' WHERE tenant_id = 'default' AND employee_no = 'EMP074';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000005', email = 'ho.duc.thanh@company.vn', phone = '0906272829', date_of_birth = '2000-03-11', gender = 'MALE', national_id = '000031101234', address = N'Hà Nội', bank_account = '9797979797979', tax_code = '9003110123' WHERE tenant_id = 'default' AND employee_no = 'EMP075';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006', email = 'tran.van.dong@company.vn', phone = '0917282930', date_of_birth = '1985-08-23', gender = 'MALE', national_id = '085082312345', address = N'Hà Nội', bank_account = '0808080808080', tax_code = '8508231234' WHERE tenant_id = 'default' AND employee_no = 'EMP076';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006', email = 'le.thi.thanh.xuan@company.vn', phone = '0908293031', date_of_birth = '1991-03-09', gender = 'FEMALE', national_id = '091030912345', address = N'TP. Hồ Chí Minh', bank_account = '1919191919191', tax_code = '9103091234' WHERE tenant_id = 'default' AND employee_no = 'EMP077';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006', email = 'nguyen.cong.hau@company.vn', phone = '0919303132', date_of_birth = '1993-11-05', gender = 'MALE', national_id = '093110543219', address = N'Đà Nẵng', bank_account = '2828282828282', tax_code = '9311054321' WHERE tenant_id = 'default' AND employee_no = 'EMP078';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006', email = 'pham.thi.kieu.my@company.vn', phone = '0900313233', date_of_birth = '1996-04-18', gender = 'FEMALE', national_id = '096041887654', address = N'Hà Nội', bank_account = '3737373737373', tax_code = '9604188765' WHERE tenant_id = 'default' AND employee_no = 'EMP079';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000006', email = 'dinh.hoang.long@company.vn', phone = '0911323334', date_of_birth = '1999-06-27', gender = 'MALE', national_id = '099062709876', address = N'Hải Phòng', bank_account = '4747474747474', tax_code = '9906270987' WHERE tenant_id = 'default' AND employee_no = 'EMP080';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007', email = 'ly.chan.hung@company.vn', phone = '0902333435', date_of_birth = '1990-10-08', gender = 'MALE', national_id = '090100845678', address = N'TP. Hồ Chí Minh', bank_account = '5858585858585', tax_code = '9010084567' WHERE tenant_id = 'default' AND employee_no = 'EMP081';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007', email = 'nguyen.thi.bao.tran@company.vn', phone = '0913343536', date_of_birth = '1993-05-19', gender = 'FEMALE', national_id = '093051956789', address = N'Hà Nội', bank_account = '6969696969696', tax_code = '9305195678' WHERE tenant_id = 'default' AND employee_no = 'EMP082';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007', email = 'to.quoc.thai@company.vn', phone = '0904353637', date_of_birth = '1995-12-01', gender = 'MALE', national_id = '095120198765', address = N'Đà Nẵng', bank_account = '7070707070707', tax_code = '9512019876' WHERE tenant_id = 'default' AND employee_no = 'EMP083';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007', email = 'tran.thi.thuy.dung@company.vn', phone = '0915363738', date_of_birth = '1997-07-13', gender = 'FEMALE', national_id = '097071309876', address = N'Cần Thơ', bank_account = '8181818181818', tax_code = '9707130987' WHERE tenant_id = 'default' AND employee_no = 'EMP084';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000007', email = 'dang.huu.nghia@company.vn', phone = '0906373839', date_of_birth = '1999-02-26', gender = 'MALE', national_id = '099022609876', address = N'Hà Nội', bank_account = '9292929292929', tax_code = '9902260987' WHERE tenant_id = 'default' AND employee_no = 'EMP085';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008', email = 'huynh.thanh.phong@company.vn', phone = '0917383940', date_of_birth = '1992-09-03', gender = 'MALE', national_id = '092090312345', address = N'TP. Hồ Chí Minh', bank_account = '0303030303030', tax_code = '9209031234' WHERE tenant_id = 'default' AND employee_no = 'EMP086';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008', email = 'vu.thi.hoai.an@company.vn', phone = '0908394041', date_of_birth = '1995-04-11', gender = 'FEMALE', national_id = '095041145678', address = N'Hà Nội', bank_account = '1414141414141', tax_code = '9504114567' WHERE tenant_id = 'default' AND employee_no = 'EMP087';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008', email = 'lam.quoc.vinh@company.vn', phone = '0919404142', date_of_birth = '1997-08-20', gender = 'MALE', national_id = '097082087654', address = N'Đà Nẵng', bank_account = '2525252525252', tax_code = '9708208765' WHERE tenant_id = 'default' AND employee_no = 'EMP088';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008', email = 'quach.thi.ngoc.diep@company.vn', phone = '0900414243', date_of_birth = '1998-11-30', gender = 'FEMALE', national_id = '098113087654', address = N'Hải Phòng', bank_account = '3636363636363', tax_code = '9811308765' WHERE tenant_id = 'default' AND employee_no = 'EMP089';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000008', email = 'nguyen.tien.dat@company.vn', phone = '0911424344', date_of_birth = '2000-05-18', gender = 'MALE', national_id = '000051845678', address = N'Hà Nội', bank_account = '4747474747474', tax_code = '9005184567' WHERE tenant_id = 'default' AND employee_no = 'EMP090';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009', email = 'tran.thi.tuyet.mai@company.vn', phone = '0902434445', date_of_birth = '1991-07-12', gender = 'FEMALE', national_id = '091071245678', address = N'TP. Hồ Chí Minh', bank_account = '5858585858585', tax_code = '9107124567' WHERE tenant_id = 'default' AND employee_no = 'EMP091';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009', email = 'do.anh.khoa@company.vn', phone = '0913444546', date_of_birth = '1993-12-25', gender = 'MALE', national_id = '093122512345', address = N'Hà Nội', bank_account = '6969696969696', tax_code = '9312251234' WHERE tenant_id = 'default' AND employee_no = 'EMP092';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009', email = 'pham.thi.hong.nhung@company.vn', phone = '0904454647', date_of_birth = '1995-10-01', gender = 'FEMALE', national_id = '095100198765', address = N'Đà Nẵng', bank_account = '7070707070707', tax_code = '9510019876' WHERE tenant_id = 'default' AND employee_no = 'EMP093';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009', email = 'ngo.thanh.danh@company.vn', phone = '0915464748', date_of_birth = '1997-02-14', gender = 'MALE', national_id = '097021487654', address = N'Cần Thơ', bank_account = '8181818181818', tax_code = '9702148765' WHERE tenant_id = 'default' AND employee_no = 'EMP094';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000009', email = 'bui.thi.my.duyen@company.vn', phone = '0906474849', date_of_birth = '1998-06-08', gender = 'FEMALE', national_id = '098060812345', address = N'Hà Nội', bank_account = '9292929292929', tax_code = '9806081234' WHERE tenant_id = 'default' AND employee_no = 'EMP095';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010', email = 'ha.tan.phat@company.vn', phone = '0917484950', date_of_birth = '1990-04-05', gender = 'MALE', national_id = '090040512345', address = N'TP. Hồ Chí Minh', bank_account = '0303030303030', tax_code = '9004051234' WHERE tenant_id = 'default' AND employee_no = 'EMP096';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010', email = 'le.thi.ngoc.anh@company.vn', phone = '0908495051', date_of_birth = '1993-08-22', gender = 'FEMALE', national_id = '093082212345', address = N'Hà Nội', bank_account = '1414141414141', tax_code = '9308221234' WHERE tenant_id = 'default' AND employee_no = 'EMP097';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010', email = 'vu.dinh.hung@company.vn', phone = '0919505152', date_of_birth = '1996-01-17', gender = 'MALE', national_id = '096011798765', address = N'Đà Nẵng', bank_account = '2525252525252', tax_code = '9601179876' WHERE tenant_id = 'default' AND employee_no = 'EMP098';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010', email = 'trinh.thi.thanh.nhan@company.vn', phone = '0900515253', date_of_birth = '1997-05-29', gender = 'FEMALE', national_id = '097052998765', address = N'Hải Phòng', bank_account = '3636363636363', tax_code = '9705299876' WHERE tenant_id = 'default' AND employee_no = 'EMP099';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000010', email = 'to.quang.hai@company.vn', phone = '0911525354', date_of_birth = '2000-08-03', gender = 'MALE', national_id = '000080356789', address = N'Hà Nội', bank_account = '4747474747474', tax_code = '9008035678' WHERE tenant_id = 'default' AND employee_no = 'EMP100';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011', email = 'mai.xuan.bac@company.vn', phone = '0902535455', date_of_birth = '1988-06-12', gender = 'MALE', national_id = '088061212345', address = N'Hà Nội', bank_account = '5858585858585', tax_code = '8806121234' WHERE tenant_id = 'default' AND employee_no = 'EMP101';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011', email = 'dang.thi.hanh.dung@company.vn', phone = '0913545556', date_of_birth = '1992-11-08', gender = 'FEMALE', national_id = '092110845678', address = N'TP. Hồ Chí Minh', bank_account = '6969696969696', tax_code = '9211084567' WHERE tenant_id = 'default' AND employee_no = 'EMP102';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011', email = 'duong.van.hoa@company.vn', phone = '0904555657', date_of_birth = '1995-04-25', gender = 'MALE', national_id = '095042598765', address = N'Đà Nẵng', bank_account = '7070707070707', tax_code = '9504259876' WHERE tenant_id = 'default' AND employee_no = 'EMP103';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011', email = 'nguyen.thi.mai.lan@company.vn', phone = '0915565758', date_of_birth = '1997-09-14', gender = 'FEMALE', national_id = '097091412345', address = N'Cần Thơ', bank_account = '8181818181818', tax_code = '9709141234' WHERE tenant_id = 'default' AND employee_no = 'EMP104';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000011', email = 'hoang.gia.khiem@company.vn', phone = '0906575859', date_of_birth = '1999-01-30', gender = 'MALE', national_id = '099013045678', address = N'Hà Nội', bank_account = '9292929292929', tax_code = '9901304567' WHERE tenant_id = 'default' AND employee_no = 'EMP105';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012', email = 'ly.nhat.quang@company.vn', phone = '0917585960', date_of_birth = '1987-10-20', gender = 'MALE', national_id = '087102098765', address = N'TP. Hồ Chí Minh', bank_account = '0303030303030', tax_code = '8710209876' WHERE tenant_id = 'default' AND employee_no = 'EMP106';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012', email = 'phan.thi.tuong.vy@company.vn', phone = '0908596061', date_of_birth = '1993-03-05', gender = 'FEMALE', national_id = '093030556789', address = N'Hà Nội', bank_account = '1414141414141', tax_code = '9303055678' WHERE tenant_id = 'default' AND employee_no = 'EMP107';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012', email = 'nguyen.khac.tuan@company.vn', phone = '0919606162', date_of_birth = '1995-07-23', gender = 'MALE', national_id = '095072387654', address = N'Đà Nẵng', bank_account = '2525252525252', tax_code = '9507238765' WHERE tenant_id = 'default' AND employee_no = 'EMP108';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012', email = 'do.thi.mong.thu@company.vn', phone = '0900616263', date_of_birth = '1996-12-19', gender = 'FEMALE', national_id = '096121912345', address = N'Hải Phòng', bank_account = '3636363636363', tax_code = '9612191234' WHERE tenant_id = 'default' AND employee_no = 'EMP109';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000012', email = 'vo.thanh.tung@company.vn', phone = '0911626364', date_of_birth = '2000-10-31', gender = 'MALE', national_id = '000103145678', address = N'Hà Nội', bank_account = '4747474747474', tax_code = '9010314567' WHERE tenant_id = 'default' AND employee_no = 'EMP110';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000013', email = 'tran.cao.sy@company.vn', phone = '0902636465', date_of_birth = '1991-08-07', gender = 'MALE', national_id = '091080756789', address = N'Hà Nội', bank_account = '5858585858585', tax_code = '9108075678' WHERE tenant_id = 'default' AND employee_no = 'EMP111';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000013', email = 'nguyen.thi.uyen.nhi@company.vn', phone = '0913646566', date_of_birth = '1994-02-28', gender = 'FEMALE', national_id = '094022887654', address = N'TP. Hồ Chí Minh', bank_account = '6969696969696', tax_code = '9402288765' WHERE tenant_id = 'default' AND employee_no = 'EMP112';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000013', email = 'le.hong.quan@company.vn', phone = '0904656667', date_of_birth = '1996-05-15', gender = 'MALE', national_id = '096051512345', address = N'Đà Nẵng', bank_account = '7070707070707', tax_code = '9605151234' WHERE tenant_id = 'default' AND employee_no = 'EMP113';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000013', email = 'quach.thi.hong.dao@company.vn', phone = '0915666768', date_of_birth = '1998-01-20', gender = 'FEMALE', national_id = '098012001234', address = N'Cần Thơ', bank_account = '8181818181818', tax_code = '9801200123' WHERE tenant_id = 'default' AND employee_no = 'EMP114';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014', email = 'dang.nhat.huy@company.vn', phone = '0906676869', date_of_birth = '1990-11-03', gender = 'MALE', national_id = '090110387654', address = N'Hà Nội', bank_account = '9292929292929', tax_code = '9011038765' WHERE tenant_id = 'default' AND employee_no = 'EMP115';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014', email = 'ngo.thi.thuy.hang@company.vn', phone = '0917686970', date_of_birth = '1993-04-16', gender = 'FEMALE', national_id = '093041656789', address = N'TP. Hồ Chí Minh', bank_account = '0303030303030', tax_code = '9304165678' WHERE tenant_id = 'default' AND employee_no = 'EMP116';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014', email = 'bui.anh.tuan@company.vn', phone = '0908697071', date_of_birth = '1996-09-29', gender = 'MALE', national_id = '096092934567', address = N'Đà Nẵng', bank_account = '1414141414141', tax_code = '9609293456' WHERE tenant_id = 'default' AND employee_no = 'EMP117';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014', email = 'lam.thi.cat.tuong@company.vn', phone = '0919707172', date_of_birth = '1997-12-04', gender = 'FEMALE', national_id = '097120414567', address = N'Hải Phòng', bank_account = '2525252525252', tax_code = '9712041456' WHERE tenant_id = 'default' AND employee_no = 'EMP118';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000014', email = 'ha.gia.huy@company.vn', phone = '0900717273', date_of_birth = '1999-04-22', gender = 'MALE', national_id = '099042234567', address = N'Hà Nội', bank_account = '3636363636363', tax_code = '9904223456' WHERE tenant_id = 'default' AND employee_no = 'EMP119';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015', email = 'vu.quoc.cuong@company.vn', phone = '0911727374', date_of_birth = '1988-06-09', gender = 'MALE', national_id = '088060934567', address = N'TP. Hồ Chí Minh', bank_account = '4747474747474', tax_code = '8806093456' WHERE tenant_id = 'default' AND employee_no = 'EMP120';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015', email = 'mai.thi.kim.ngan@company.vn', phone = '0902737475', date_of_birth = '1992-12-15', gender = 'FEMALE', national_id = '092121556789', address = N'Hà Nội', bank_account = '5858585858585', tax_code = '9212155678' WHERE tenant_id = 'default' AND employee_no = 'EMP121';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015', email = 'to.duc.thang@company.vn', phone = '0913747576', date_of_birth = '1995-05-28', gender = 'MALE', national_id = '095052887654', address = N'Đà Nẵng', bank_account = '6969696969696', tax_code = '9505288765' WHERE tenant_id = 'default' AND employee_no = 'EMP122';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015', email = 'nguyen.thi.bao.ngoc@company.vn', phone = '0904757677', date_of_birth = '1997-08-10', gender = 'FEMALE', national_id = '097081034567', address = N'Cần Thơ', bank_account = '7070707070707', tax_code = '9708103456' WHERE tenant_id = 'default' AND employee_no = 'EMP123';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000015', email = 'trinh.cong.danh@company.vn', phone = '0915767778', date_of_birth = '2000-02-05', gender = 'MALE', national_id = '000020556789', address = N'Hà Nội', bank_account = '8181818181818', tax_code = '9002055678' WHERE tenant_id = 'default' AND employee_no = 'EMP124';

UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016', email = 'pham.huu.tho@company.vn', phone = '0906777879', date_of_birth = '1986-09-18', gender = 'MALE', national_id = '086091845678', address = N'Hà Nội', bank_account = '9292929292929', tax_code = '8609184567' WHERE tenant_id = 'default' AND employee_no = 'EMP125';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016', email = 'do.thi.anh.nguyet@company.vn', phone = '0917787980', date_of_birth = '1992-04-03', gender = 'FEMALE', national_id = '092040334567', address = N'TP. Hồ Chí Minh', bank_account = '0303030303030', tax_code = '9204033456' WHERE tenant_id = 'default' AND employee_no = 'EMP126';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016', email = 'ho.thanh.binh@company.vn', phone = '0908798081', date_of_birth = '1994-07-27', gender = 'MALE', national_id = '094072734567', address = N'Đà Nẵng', bank_account = '1414141414141', tax_code = '9407273456' WHERE tenant_id = 'default' AND employee_no = 'EMP127';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016', email = 'ngo.thi.xuan.mai@company.vn', phone = '0919808182', date_of_birth = '1996-11-11', gender = 'FEMALE', national_id = '096111145678', address = N'Hải Phòng', bank_account = '2525252525252', tax_code = '9611114567' WHERE tenant_id = 'default' AND employee_no = 'EMP128';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016', email = 'ly.hoai.bao@company.vn', phone = '0900818283', date_of_birth = '1998-06-24', gender = 'MALE', national_id = '098062445678', address = N'Cần Thơ', bank_account = '3636363636363', tax_code = '9806244567' WHERE tenant_id = 'default' AND employee_no = 'EMP129';
UPDATE employee SET position_id = 'a0100000-0000-4000-8000-000000000016', email = 'huynh.thi.dieu.hien@company.vn', phone = '0911828384', date_of_birth = '1999-10-09', gender = 'FEMALE', national_id = '099100934567', address = N'Hà Nội', bank_account = '4747474747474', tax_code = '9910093456' WHERE tenant_id = 'default' AND employee_no = 'EMP130';

-- ============================================================================
-- SECTION 5: EMPLOYEE CONTRACTS (~130 contracts, one per employee)
-- UUID: c0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- Contract types: PERMANENT (hire<2022), FIXED (2022-2024), PROBATION (2025+)
-- ============================================================================

-- EMP001-EMP010: PERMANENT contracts
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', e.id, 'PERMANENT', '2018-06-01', null, 35000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000001');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', e.id, 'PERMANENT', '2019-03-15', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000002');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', e.id, 'PERMANENT', '2019-03-15', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000003');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000004', 'default', e.id, 'PERMANENT', '2018-03-10', null, 32000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000004');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000005', 'default', e.id, 'PERMANENT', '2018-03-10', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000005');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000006', 'default', e.id, 'PERMANENT', '2019-06-20', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000006');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000007', 'default', e.id, 'PERMANENT', '2020-01-10', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000007');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000008', 'default', e.id, 'PERMANENT', '2020-01-10', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000008');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000009', 'default', e.id, 'PERMANENT', '2020-01-10', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000009');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000010', 'default', e.id, 'PERMANENT', '2020-04-05', null, 22000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000010');

-- EMP011-EMP020: Various contract types
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000011', 'default', e.id, 'PERMANENT', '2020-04-05', null, 22000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000011');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000012', 'default', e.id, 'PERMANENT', '2020-07-15', null, 20000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000012');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000013', 'default', e.id, 'PERMANENT', '2020-07-15', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000013');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000014', 'default', e.id, 'FIXED', '2021-04-10', '2024-04-09', 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000014');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000015', 'default', e.id, 'PERMANENT', '2021-04-10', null, 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP015' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000015');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000016', 'default', e.id, 'FIXED', '2021-04-10', '2024-04-09', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP016' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000016');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000017', 'default', e.id, 'FIXED', '2021-04-10', '2024-04-09', 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP017' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000017');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000018', 'default', e.id, 'PERMANENT', '2021-09-01', null, 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP018' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000018');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000019', 'default', e.id, 'FIXED', '2021-09-01', '2024-08-31', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP019' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000019');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000020', 'default', e.id, 'FIXED', '2021-09-01', '2024-08-31', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP020' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000020');

-- EMP021-EMP030
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000021', 'default', e.id, 'FIXED', '2022-03-01', '2025-02-28', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP021' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000021');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000022', 'default', e.id, 'FIXED', '2022-03-01', '2025-02-28', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP022' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000022');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000023', 'default', e.id, 'FIXED', '2022-03-01', '2025-02-28', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP023' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000023');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000024', 'default', e.id, 'FIXED', '2022-03-01', '2025-02-28', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP024' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000024');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000025', 'default', e.id, 'FIXED', '2022-03-01', '2025-02-28', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP025' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000025');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000026', 'default', e.id, 'FIXED', '2022-07-01', '2025-06-30', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP026' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000026');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000027', 'default', e.id, 'FIXED', '2022-07-01', '2025-06-30', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP027' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000027');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000028', 'default', e.id, 'FIXED', '2022-07-01', '2025-06-30', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP028' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000028');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000029', 'default', e.id, 'FIXED', '2022-07-01', '2025-06-30', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP029' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000029');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000030', 'default', e.id, 'FIXED', '2022-07-01', '2025-06-30', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP030' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000030');

-- EMP031-EMP040
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000031', 'default', e.id, 'FIXED', '2022-10-01', '2025-09-30', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP031' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000031');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000032', 'default', e.id, 'FIXED', '2022-10-01', '2025-09-30', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP032' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000032');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000033', 'default', e.id, 'FIXED', '2023-01-15', '2026-01-14', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP033' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000033');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000034', 'default', e.id, 'FIXED', '2023-01-15', '2026-01-14', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP034' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000034');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000035', 'default', e.id, 'FIXED', '2023-01-15', '2026-01-14', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP035' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000035');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000036', 'default', e.id, 'FIXED', '2023-01-15', '2026-01-14', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP036' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000036');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000037', 'default', e.id, 'FIXED', '2023-04-01', '2026-03-31', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP037' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000037');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000038', 'default', e.id, 'FIXED', '2023-04-01', '2026-03-31', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP038' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000038');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000039', 'default', e.id, 'FIXED', '2023-04-01', '2026-03-31', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP039' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000039');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000040', 'default', e.id, 'FIXED', '2023-04-01', '2026-03-31', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP040' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000040');

-- EMP041-EMP048
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000041', 'default', e.id, 'FIXED', '2023-07-01', '2026-06-30', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP041' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000041');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000042', 'default', e.id, 'FIXED', '2023-07-01', '2026-06-30', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP042' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000042');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000043', 'default', e.id, 'FIXED', '2023-07-01', '2026-06-30', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP043' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000043');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000044', 'default', e.id, 'FIXED', '2023-07-01', '2026-06-30', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP044' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000044');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000045', 'default', e.id, 'FIXED', '2023-10-01', '2026-09-30', 35000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP045' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000045');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000046', 'default', e.id, 'FIXED', '2023-10-01', '2026-09-30', 22000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP046' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000046');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000047', 'default', e.id, 'FIXED', '2024-01-10', '2027-01-09', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP047' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000047');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000048', 'default', e.id, 'FIXED', '2024-01-10', '2027-01-09', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP048' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000048');

-- EMP049-EMP130: Contracts matching their hire dates and positions
-- HR (001): EMP049-EMP053
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000049', 'default', e.id, 'PERMANENT', '2019-08-12', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP049' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000049');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000050', 'default', e.id, 'PERMANENT', '2020-03-21', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP050' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000050');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000051', 'default', e.id, 'PERMANENT', '2021-11-15', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP051' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000051');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000052', 'default', e.id, 'FIXED', '2022-07-04', '2025-07-03', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP052' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000052');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000053', 'default', e.id, 'PROBATION', '2024-02-19', '2024-08-18', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP053' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000053');

-- IT (002): EMP054-EMP059
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000054', 'default', e.id, 'PERMANENT', '2018-09-03', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000054');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000055', 'default', e.id, 'PERMANENT', '2019-04-17', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000055');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000056', 'default', e.id, 'PERMANENT', '2020-10-28', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000056');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000057', 'default', e.id, 'PERMANENT', '2021-06-09', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000057');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000058', 'default', e.id, 'FIXED', '2022-12-12', '2025-12-11', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000058');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000059', 'default', e.id, 'FIXED', '2023-08-01', '2025-07-31', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP059' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000059');

-- FIN (003): EMP060-EMP064
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000060', 'default', e.id, 'PERMANENT', '2019-11-11', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000060');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000061', 'default', e.id, 'PERMANENT', '2020-06-23', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP061' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000061');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000062', 'default', e.id, 'PERMANENT', '2021-02-09', null, 18000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP062' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000062');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000063', 'default', e.id, 'FIXED', '2023-05-30', '2026-05-29', 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP063' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000063');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000064', 'default', e.id, 'PROBATION', '2024-04-14', '2024-10-13', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP064' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000064');

-- SALES (004): EMP065-EMP070
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000065', 'default', e.id, 'PERMANENT', '2018-12-03', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP065' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000065');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000066', 'default', e.id, 'PERMANENT', '2020-02-14', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP066' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000066');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000067', 'default', e.id, 'PERMANENT', '2021-04-26', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP067' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000067');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000068', 'default', e.id, 'FIXED', '2022-09-18', '2025-09-17', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP068' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000068');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000069', 'default', e.id, 'FIXED', '2023-11-25', '2026-11-24', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP069' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000069');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000070', 'default', e.id, 'PROBATION', '2025-01-06', '2025-07-05', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP070' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000070');

-- MKT (005): EMP071-EMP075
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000071', 'default', e.id, 'PERMANENT', '2019-07-15', null, 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP071' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000071');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000072', 'default', e.id, 'PERMANENT', '2020-10-05', null, 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP072' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000072');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000073', 'default', e.id, 'PERMANENT', '2021-08-18', null, 16000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP073' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000073');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000074', 'default', e.id, 'FIXED', '2023-01-30', '2026-01-29', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP074' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000074');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000075', 'default', e.id, 'PROBATION', '2024-06-03', '2024-12-02', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP075' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000075');

-- OPS (006): EMP076-EMP080
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000076', 'default', e.id, 'PERMANENT', '2018-05-21', null, 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP076' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000076');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000077', 'default', e.id, 'PERMANENT', '2020-08-11', null, 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP077' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000077');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000078', 'default', e.id, 'PERMANENT', '2021-06-14', null, 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP078' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000078');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000079', 'default', e.id, 'FIXED', '2023-03-08', '2026-03-07', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP079' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000079');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000080', 'default', e.id, 'PROBATION', '2024-10-07', '2025-04-06', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP080' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000080');

-- RND (007): EMP081-EMP085
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000081', 'default', e.id, 'PERMANENT', '2019-10-14', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP081' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000081');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000082', 'default', e.id, 'PERMANENT', '2020-04-02', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP082' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000082');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000083', 'default', e.id, 'PERMANENT', '2021-12-20', null, 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP083' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000083');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000084', 'default', e.id, 'FIXED', '2023-07-24', '2026-07-23', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP084' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000084');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000085', 'default', e.id, 'PROBATION', '2025-02-17', '2025-08-16', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP085' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000085');

-- LEGAL (008): EMP086-EMP090
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000086', 'default', e.id, 'PERMANENT', '2020-11-09', null, 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP086' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000086');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000087', 'default', e.id, 'FIXED', '2022-04-25', '2025-04-24', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP087' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000087');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000088', 'default', e.id, 'FIXED', '2023-09-11', '2026-09-10', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP088' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000088');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000089', 'default', e.id, 'PROBATION', '2024-07-16', '2025-01-15', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP089' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000089');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000090', 'default', e.id, 'PROBATION', '2025-03-03', '2025-09-02', 8000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP090' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000090');

-- CS (009): EMP091-EMP095
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000091', 'default', e.id, 'PERMANENT', '2019-06-10', null, 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP091' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000091');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000092', 'default', e.id, 'PERMANENT', '2020-12-01', null, 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP092' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000092');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000093', 'default', e.id, 'FIXED', '2022-03-14', '2025-03-13', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP093' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000093');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000094', 'default', e.id, 'FIXED', '2023-06-19', '2026-06-18', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP094' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000094');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000095', 'default', e.id, 'PROBATION', '2024-11-04', '2025-05-03', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP095' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000095');

-- QA (010): EMP096-EMP100
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000096', 'default', e.id, 'PERMANENT', '2020-05-12', null, 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP096' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000096');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000097', 'default', e.id, 'PERMANENT', '2021-08-23', null, 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP097' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000097');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000098', 'default', e.id, 'FIXED', '2022-10-31', '2025-10-30', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP098' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000098');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000099', 'default', e.id, 'FIXED', '2023-12-15', '2026-12-14', 15000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP099' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000099');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000100', 'default', e.id, 'PROBATION', '2025-03-10', '2025-09-09', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP100' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000100');

-- ADMIN (011): EMP101-EMP105
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000101', 'default', e.id, 'PERMANENT', '2020-01-20', null, 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP101' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000101');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000102', 'default', e.id, 'PERMANENT', '2021-07-05', null, 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP102' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000102');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000103', 'default', e.id, 'FIXED', '2023-02-13', '2026-02-12', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP103' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000103');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000104', 'default', e.id, 'PROBATION', '2024-01-08', '2024-07-07', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP104' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000104');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000105', 'default', e.id, 'PROBATION', '2024-09-22', '2025-03-21', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP105' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000105');

-- TRAINING (012): EMP106-EMP110
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000106', 'default', e.id, 'PERMANENT', '2019-03-25', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP106' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000106');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000107', 'default', e.id, 'PERMANENT', '2020-09-14', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP107' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000107');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000108', 'default', e.id, 'FIXED', '2022-05-06', '2025-05-05', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP108' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000108');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000109', 'default', e.id, 'FIXED', '2023-07-17', '2026-07-16', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP109' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000109');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000110', 'default', e.id, 'PROBATION', '2024-12-02', '2025-06-01', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP110' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000110');

-- DATA (013): EMP111-EMP114
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000111', 'default', e.id, 'PERMANENT', '2020-04-08', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP111' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000111');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000112', 'default', e.id, 'PERMANENT', '2021-09-28', null, 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP112' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000112');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000113', 'default', e.id, 'FIXED', '2022-11-07', '2025-11-06', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP113' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000113');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000114', 'default', e.id, 'PROBATION', '2024-04-29', '2024-10-28', 10000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP114' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000114');

-- PRODUCT (014): EMP115-EMP119
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000115', 'default', e.id, 'PERMANENT', '2019-08-19', null, 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP115' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000115');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000116', 'default', e.id, 'PERMANENT', '2020-12-21', null, 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP116' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000116');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000117', 'default', e.id, 'FIXED', '2022-06-13', '2025-06-12', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP117' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000117');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000118', 'default', e.id, 'FIXED', '2023-08-04', '2026-08-03', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP118' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000118');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000119', 'default', e.id, 'PROBATION', '2025-03-17', '2025-09-16', 9000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP119' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000119');

-- SECURITY (015): EMP120-EMP124
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000120', 'default', e.id, 'PERMANENT', '2019-11-25', null, 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP120' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000120');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000121', 'default', e.id, 'PERMANENT', '2021-05-10', null, 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP121' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000121');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000122', 'default', e.id, 'FIXED', '2022-10-17', '2025-10-16', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP122' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000122');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000123', 'default', e.id, 'FIXED', '2023-12-26', '2026-12-25', 14000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP123' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000123');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000124', 'default', e.id, 'PROBATION', '2024-09-09', '2025-03-08', 12000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP124' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000124');

-- PMO (016): EMP125-EMP130
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000125', 'default', e.id, 'PERMANENT', '2018-07-30', null, 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP125' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000125');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000126', 'default', e.id, 'PERMANENT', '2020-03-16', null, 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP126' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000126');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000127', 'default', e.id, 'PERMANENT', '2021-07-21', null, 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP127' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000127');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000128', 'default', e.id, 'FIXED', '2022-12-05', '2025-12-04', 13000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP128' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000128');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000129', 'default', e.id, 'PROBATION', '2024-02-12', '2024-08-11', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP129' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000129');
INSERT INTO employee_contract (id, tenant_id, employee_id, contract_type, start_date, end_date, salary, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000130', 'default', e.id, 'PROBATION', '2024-11-18', '2025-05-17', 11000000, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP130' AND NOT EXISTS (SELECT 1 FROM employee_contract WHERE id = 'a0100000-0000-4000-8000-000000000130');

-- ============================================================================
-- SECTION 6: EMPLOYEE SKILLS (2-5 per employee, ~500 total)
-- UUID: d0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

-- EMP001-EMP010
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', e.id, N'Quản lý nhân sự', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000001');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', e.id, N'Đào tạo & Phát triển', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000002');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', e.id, N'Tiếng Anh', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000003');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000004', 'default', e.id, N'Soạn thảo văn bản', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000004');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000005', 'default', e.id, N'Microsoft Office', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000005');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000006', 'default', e.id, N'Giao tiếp', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000006');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000007', 'default', e.id, N'Tổ chức sự kiện', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000007');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000008', 'default', e.id, N'Quản trị hệ thống', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000008');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000009', 'default', e.id, 'Java', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000009');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000010', 'default', e.id, 'Spring Boot', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000010');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000011', 'default', e.id, 'Python', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000011');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000012', 'default', e.id, 'PostgreSQL', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000012');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000013', 'default', e.id, 'Docker', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000013');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000014', 'default', e.id, 'Git', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000014');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000015', 'default', e.id, 'React', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000015');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000016', 'default', e.id, 'Node.js', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000016');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000017', 'default', e.id, 'TypeScript', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000017');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000018', 'default', e.id, N'Phân tích dữ liệu', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000018');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000019', 'default', e.id, 'SQL', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000019');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000020', 'default', e.id, 'Kubernetes', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000020');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000021', 'default', e.id, 'Linux', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000021');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000022', 'default', e.id, 'AWS', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000022');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000023', 'default', e.id, N'Bảo mật CNTT', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000023');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000024', 'default', e.id, 'Python', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000024');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000025', 'default', e.id, N'Kế toán tổng hợp', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000025');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000026', 'default', e.id, N'Excel nâng cao', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000026');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000027', 'default', e.id, N'Thuế', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000027');

-- EMP011-EMP020
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000028', 'default', e.id, N'Phân tích tài chính', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000028');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000029', 'default', e.id, 'SAP', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000029');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000030', 'default', e.id, N'Bán hàng B2B', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000030');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000031', 'default', e.id, N'Đàm phán', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000031');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000032', 'default', e.id, 'CRM', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000032');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000033', 'default', e.id, N'Chăm sóc khách hàng', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000033');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000034', 'default', e.id, N'Tiếng Anh', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000034');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000035', 'default', e.id, N'Marketing số', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000035');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000036', 'default', e.id, 'SEO/SEM', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000036');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000037', 'default', e.id, N'Thiết kế đồ họa', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000037');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000038', 'default', e.id, N'Google Ads', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP015' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000038');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000039', 'default', e.id, N'Phân tích thị trường', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP015' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000039');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000040', 'default', e.id, 'Facebook Ads', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP016' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000040');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000041', 'default', e.id, N'Content Marketing', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP016' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000041');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000042', 'default', e.id, N'Viết content', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP017' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000042');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000043', 'default', e.id, N'Quản trị MXH', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP017' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000043');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000044', 'default', e.id, N'Quản lý vận hành', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP018' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000044');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000045', 'default', e.id, N'Giải quyết vấn đề', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP018' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000045');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000046', 'default', e.id, N'Quản lý kho', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP019' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000046');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000047', 'default', e.id, N'Lập kế hoạch', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP019' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000047');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000048', 'default', e.id, N'ISO 9001', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP020' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000048');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000049', 'default', e.id, N'Quản lý quy trình', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP020' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000049');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000050', 'default', e.id, N'Lean Six Sigma', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP020' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000050');

-- EMP021-EMP030
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000051', 'default', e.id, N'Nghiên cứu thị trường', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP021' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000051');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000052', 'default', e.id, N'SPSS', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP021' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000052');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000053', 'default', e.id, 'Python', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP022' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000053');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000054', 'default', e.id, 'Machine Learning', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP022' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000054');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000055', 'default', e.id, 'TensorFlow', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP022' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000055');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000056', 'default', e.id, N'Kiểm thử phần mềm', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP023' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000056');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000057', 'default', e.id, 'Selenium', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP023' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000057');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000058', 'default', e.id, N'Luật lao động', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP024' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000058');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000059', 'default', e.id, N'Soạn thảo hợp đồng', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP024' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000059');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000060', 'default', e.id, N'Luật doanh nghiệp', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP025' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000060');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000061', 'default', e.id, N'Tư vấn pháp lý', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP025' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000061');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000062', 'default', e.id, 'Zendesk', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP026' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000062');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000063', 'default', e.id, N'Xử lý khiếu nại', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP026' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000063');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000064', 'default', e.id, N'Giao tiếp khách hàng', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP027' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000064');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000065', 'default', e.id, N'Tiếng Nhật', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP027' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000065');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000066', 'default', e.id, 'Salesforce', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP028' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000066');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000067', 'default', e.id, N'Hỗ trợ kỹ thuật', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP028' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000067');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000068', 'default', e.id, N'Kiểm thử tự động', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP029' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000068');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000069', 'default', e.id, 'Jira', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP029' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000069');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000070', 'default', e.id, 'TestNG', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP029' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000070');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000071', 'default', e.id, N'Kiểm thử thủ công', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP030' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000071');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000072', 'default', e.id, N'Viết test case', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP030' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000072');

-- EMP031-EMP040
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000073', 'default', e.id, N'Phân tích yêu cầu', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP031' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000073');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000074', 'default', e.id, 'UML', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP031' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000074');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000075', 'default', e.id, N'Báo cáo phân tích', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP032' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000075');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000076', 'default', e.id, N'Power BI', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP032' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000076');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000077', 'default', e.id, N'Đào tạo nhân viên', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP033' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000077');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000078', 'default', e.id, N'LMS', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP033' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000078');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000079', 'default', e.id, N'Thiết kế khóa học', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP034' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000079');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000080', 'default', e.id, N'Đánh giá đào tạo', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP034' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000080');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000081', 'default', e.id, N'Kiểm soát chất lượng', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP035' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000081');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000082', 'default', e.id, N'Kiểm toán nội bộ', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP035' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000082');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000083', 'default', e.id, N'Quản lý dự án', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP036' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000083');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000084', 'default', e.id, N'Agile/Scrum', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP036' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000084');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000085', 'default', e.id, N'Data Mining', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP037' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000085');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000086', 'default', e.id, 'Python', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP037' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000086');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000087', 'default', e.id, 'Tableau', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP038' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000087');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000088', 'default', e.id, N'ETL', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP038' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000088');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000089', 'default', e.id, N'Quản lý sản phẩm', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP039' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000089');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000090', 'default', e.id, N'User Story', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP039' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000090');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000091', 'default', e.id, 'Figma', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP040' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000091');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000092', 'default', e.id, N'UX Research', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP040' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000092');

-- EMP041-EMP048
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000093', 'default', e.id, N'An ninh mạng', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP041' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000093');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000094', 'default', e.id, N'Penetration Testing', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP041' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000094');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000095', 'default', e.id, N'ISO 27001', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP042' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000095');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000096', 'default', e.id, N'Quản lý rủi ro', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP042' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000096');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000097', 'default', e.id, 'MS Project', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP043' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000097');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000098', 'default', e.id, N'PMP', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP043' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000098');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000099', 'default', e.id, N'Quản lý ngân sách', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP044' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000099');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000100', 'default', e.id, N'Báo cáo dự án', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP044' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000100');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000101', 'default', e.id, N'Quản lý nhân sự', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP045' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000101');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000102', 'default', e.id, N'Tuyển dụng', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP045' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000102');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000103', 'default', e.id, N'Phân tích tài chính', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP046' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000103');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000104', 'default', e.id, N'Kế toán quản trị', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP046' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000104');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000105', 'default', e.id, N'Quản lý vận hành', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP047' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000105');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000106', 'default', e.id, N'Quản lý chuỗi cung ứng', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP047' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000106');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000107', 'default', e.id, 'React Native', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP048' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000107');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000108', 'default', e.id, N'Mobile Development', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP048' AND NOT EXISTS (SELECT 1 FROM employee_skill WHERE id = 'a0100000-0000-4000-8000-000000000108');

-- EMP049-EMP060 (HR/IT)
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phỏng vấn tuyển dụng', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP049'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Phỏng vấn tuyển dụng');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Microsoft Excel', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP049'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Microsoft Excel');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Tiếng Anh', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP050'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Tiếng Anh');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Quản lý hồ sơ', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP050'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Quản lý hồ sơ');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'SQL Server', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP051'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'SQL Server');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Báo cáo nhân sự', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP051'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Báo cáo nhân sự');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Tiếng Trung', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP052'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Tiếng Trung');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Onboarding', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP052'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Onboarding');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Quản lý dữ liệu', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP053'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Quản lý dữ liệu');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phân tích nhân sự', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP053'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Phân tích nhân sự');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Lập trình Java', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Lập trình Java');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Spring Boot', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Spring Boot');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Hệ thống phân tán', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Hệ thống phân tán');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Python', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Python');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Django', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Django');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Machine Learning', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Machine Learning');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'DevOps', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'DevOps');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Kubernetes', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Kubernetes');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Docker', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Docker');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'ReactJS', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'ReactJS');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'TypeScript', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'TypeScript');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Node.js', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Node.js');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Vue.js', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Vue.js');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'CSS/SCSS', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'CSS/SCSS');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'UI/UX Design', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'UI/UX Design');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'VBA', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'VBA');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phân tích tài chính', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Phân tích tài chính');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'SAP FI/CO', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP061'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'SAP FI/CO');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Kiểm toán nội bộ', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP061'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Kiểm toán nội bộ');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Kế toán thuế', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP062'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Kế toán thuế');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Microsoft Excel', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP062'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Microsoft Excel');
-- FIN: EMP063-EMP064
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Báo cáo tài chính', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP063'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Báo cáo tài chính');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Ngân sách doanh nghiệp', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP063'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Ngân sách doanh nghiệp');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phân tích rủi ro', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP064'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Phân tích rủi ro');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'IFRS', 'BEGINNER', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP064'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'IFRS');
-- SALES: EMP065-EMP069
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Bán hàng B2B', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP065'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Bán hàng B2B');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Quản lý khách hàng', 'EXPERT', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP065'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Quản lý khách hàng');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'CRM Salesforce', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP065'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'CRM Salesforce');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Thương thuyết', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP066'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Thương thuyết');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Chăm sóc khách hàng', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP066'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Chăm sóc khách hàng');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Bán hàng qua điện thoại', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP067'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Bán hàng qua điện thoại');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Kỹ năng giao tiếp', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP067'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Kỹ năng giao tiếp');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phân tích thị trường', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP068'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Phân tích thị trường');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Báo cáo doanh số', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP068'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Báo cáo doanh số');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Quản lý pipeline', 'INTERMEDIATE', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP069'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Quản lý pipeline');
INSERT INTO employee_skill (id, tenant_id, employee_id, skill_name, proficiency_level, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Microsoft PowerPoint', 'ADVANCED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP069'
  AND NOT EXISTS (SELECT 1 FROM employee_skill es WHERE es.employee_id = e.id AND es.skill_name = N'Microsoft PowerPoint');

-- ============================================================================
-- SECTION 7: EMERGENCY CONTACTS (1-2 per employee, ~180 total)
-- UUID: e0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

-- EMP001-EMP010
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', e.id, N'Nguyễn Văn Hùng', 'FATHER', '0918010203', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000001');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', e.id, N'Phạm Thị Hoa', 'MOTHER', '0918020304', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000002');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', e.id, N'Trần Quốc Bảo', 'SPOUSE', '0903030405', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000003');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000004', 'default', e.id, N'Trần Thị Lan', 'MOTHER', '0918030405', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000004');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000005', 'default', e.id, N'Lê Văn Sơn', 'FATHER', '0904040506', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000005');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000006', 'default', e.id, N'Lê Thị Mai', 'SISTER', '0918040506', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000006');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000007', 'default', e.id, N'Phạm Văn Cường', 'BROTHER', '0985050607', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000007');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000008', 'default', e.id, N'Phạm Thị Hương', 'MOTHER', '0905050607', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000008');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000009', 'default', e.id, N'Vũ Văn Thành', 'FATHER', '0906060708', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000009');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000010', 'default', e.id, N'Đỗ Văn Lâm', 'FATHER', '0917070809', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000010');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000011', 'default', e.id, N'Đỗ Thị Hồng', 'SPOUSE', '0907070809', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000011');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000012', 'default', e.id, N'Ngô Văn Phúc', 'SPOUSE', '0908080910', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000012');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000013', 'default', e.id, N'Hoàng Văn Nam', 'FATHER', '0909091011', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000013');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000014', 'default', e.id, N'Bùi Đức Tuấn', 'BROTHER', '0910101112', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000014');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000015', 'default', e.id, N'Đinh Văn Hải', 'SPOUSE', '0910111213', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000015');

-- EMP011-EMP030
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000016', 'default', e.id, N'Trịnh Văn Kha', 'BROTHER', '0911121314', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000016');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000017', 'default', e.id, N'Trịnh Thị Hà', 'MOTHER', '0912131415', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000017');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000018', 'default', e.id, N'Lý Văn Tuấn', 'SPOUSE', '0913141516', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000018');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000019', 'default', e.id, N'Dương Văn Sơn', 'FATHER', '0914151617', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000019');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000020', 'default', e.id, N'Tạ Văn Bình', 'BROTHER', '0915161718', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000020');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000021', 'default', e.id, N'Nguyễn Thanh Hà', 'MOTHER', '0906171819', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP015' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000021');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000022', 'default', e.id, N'Phan Văn Dũng', 'FATHER', '0917181920', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP016' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000022');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000023', 'default', e.id, N'Hồ Văn Tiến', 'BROTHER', '0918192021', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP017' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000023');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000024', 'default', e.id, N'Hồ Thị Mai', 'MOTHER', '0909202122', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP017' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000024');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000025', 'default', e.id, N'Võ Văn Hùng', 'FATHER', '0919202122', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP018' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000025');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000026', 'default', e.id, N'Trương Văn Long', 'SPOUSE', '0910212223', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP019' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000026');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000027', 'default', e.id, N'Lưu Văn An', 'FATHER', '0911222324', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP020' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000027');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000028', 'default', e.id, N'Mai Văn Quý', 'FATHER', '0912232425', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP021' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000028');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000029', 'default', e.id, N'Cao Văn Nghĩa', 'FATHER', '0913242526', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP022' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000029');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000030', 'default', e.id, N'Đặng Văn Hòa', 'SPOUSE', '0904252627', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP023' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000030');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000031', 'default', e.id, N'Ngô Văn Huy', 'FATHER', '0914252627', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP024' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000031');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000032', 'default', e.id, N'Bùi Văn Thành', 'SPOUSE', '0905262728', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP025' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000032');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000033', 'default', e.id, N'Nguyễn Thị Bình', 'MOTHER', '0915262728', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP026' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000033');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000034', 'default', e.id, N'Trần Thị Thu', 'MOTHER', '0916272829', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP027' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000034');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000035', 'default', e.id, N'Lê Văn Thanh', 'FATHER', '0907282930', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP028' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000035');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000036', 'default', e.id, N'Phạm Văn Khánh', 'FATHER', '0917282930', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP029' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000036');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000037', 'default', e.id, N'Hoàng Văn Mạnh', 'BROTHER', '0908293031', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP030' AND NOT EXISTS (SELECT 1 FROM emergency_contact WHERE id = 'a0100000-0000-4000-8000-000000000037');

-- EMP031-EMP040
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Nguyễn Thị An', 'MOTHER', '0901122334', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP031'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Nguyễn Thị An');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Trần Văn Định', 'FATHER', '0902233445', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP032'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Trần Văn Định');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Lê Thị Bích', 'SPOUSE', '0903344556', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP033'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Lê Thị Bích');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phạm Văn Thanh', 'FATHER', '0904455667', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP034'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Phạm Văn Thanh');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Đỗ Thị Hạnh', 'MOTHER', '0905566778', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP035'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Đỗ Thị Hạnh');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Vũ Thị Hương', 'SPOUSE', '0906677889', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP036'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Vũ Thị Hương');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Nguyễn Văn Giang', 'FATHER', '0907788990', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP037'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Nguyễn Văn Giang');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Trịnh Thị Thúy', 'MOTHER', '0908899001', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP038'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Trịnh Thị Thúy');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Hoàng Văn Lâm', 'FATHER', '0909900112', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP039'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Hoàng Văn Lâm');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Mai Thị Cúc', 'MOTHER', '0910011223', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP040'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Mai Thị Cúc');
-- EMP041-EMP060
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Lý Văn Đức', 'BROTHER', '0900123456', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP041'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Lý Văn Đức');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Đặng Thị Lan', 'MOTHER', '0901234567', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP042'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Đặng Thị Lan');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Tô Văn Khôi', 'FATHER', '0902345678', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP043'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Tô Văn Khôi');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Quách Thị Ngọc', 'MOTHER', '0903456789', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP044'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Quách Thị Ngọc');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Ngô Văn Tân', 'BROTHER', '0904567890', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP045'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Ngô Văn Tân');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Dương Thị Nga', 'SPOUSE', '0905678901', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP046'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Dương Thị Nga');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Hà Văn Bình', 'FATHER', '0906789012', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP047'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Hà Văn Bình');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Bùi Thị Loan', 'MOTHER', '0907890123', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP048'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Bùi Thị Loan');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Phan Văn Hiếu', 'FATHER', '0908901234', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP049'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Phan Văn Hiếu');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Lâm Thị Yến', 'SPOUSE', '0909012345', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP050'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Lâm Thị Yến');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Tạ Văn Hoàng', 'BROTHER', '0910123456', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP051'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Tạ Văn Hoàng');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Võ Thị Hằng', 'MOTHER', '0911234567', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP052'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Võ Thị Hằng');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Trương Văn Sơn', 'FATHER', '0912345678', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP053'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Trương Văn Sơn');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Đoàn Thị Thu', 'SPOUSE', '0913456789', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Đoàn Thị Thu');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Chu Văn Phúc', 'FATHER', '0914567890', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Chu Văn Phúc');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Cao Thị Diễm', 'MOTHER', '0915678901', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Cao Thị Diễm');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Lưu Văn Hiệp', 'BROTHER', '0916789012', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Lưu Văn Hiệp');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Tôn Thị Tuyết', 'MOTHER', '0917890123', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Tôn Thị Tuyết');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Trang Văn Khánh', 'FATHER', '0918901234', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP059'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Trang Văn Khánh');
INSERT INTO emergency_contact (id, tenant_id, employee_id, full_name, relationship, phone, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, N'Thạch Thị Xuân', 'SPOUSE', '0919012345', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060'
  AND NOT EXISTS (SELECT 1 FROM emergency_contact ec WHERE ec.employee_id = e.id AND ec.full_name = N'Thạch Thị Xuân');

-- ============================================================================
-- SECTION 8: LEAVE BALANCES (2 entries per ACTIVE employee for 2026)
-- UUID pattern for leave balances: using random UUIDs with idempotent check
-- ============================================================================

INSERT INTO leave_balance (id, tenant_id, employee_id, leave_type, "year", total_days, used_days, pending_days, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'ANNUAL', 2026, 12, FLOOR(RANDOM() * 6)::int, 0, now(), now()
FROM employee e
WHERE e.tenant_id = 'default' AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM leave_balance lb WHERE lb.employee_id = e.id AND lb.leave_type = 'ANNUAL' AND lb."year" = 2026);

INSERT INTO leave_balance (id, tenant_id, employee_id, leave_type, "year", total_days, used_days, pending_days, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'SICK', 2026, 10, FLOOR(RANDOM() * 4)::int, 0, now(), now()
FROM employee e
WHERE e.tenant_id = 'default' AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM leave_balance lb WHERE lb.employee_id = e.id AND lb.leave_type = 'SICK' AND lb."year" = 2026);

-- ============================================================================
-- SECTION 9: HOLIDAYS (Vietnamese holidays, 9 entries)
-- UUID: h0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', N'Tết Dương lịch', '2026-01-01', N'Nghỉ Tết Dương lịch 1 ngày', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000001');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', N'Tết Nguyên đán', '2026-02-16', N'Nghỉ Tết Nguyên đán Bính Ngọ', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000002');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', N'Giỗ tổ Hùng Vương', '2026-04-25', N'Giỗ tổ Hùng Vương mùng 10 tháng 3 âm lịch', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000003');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000004', 'default', N'Ngày Chiến thắng', '2026-04-30', N'Ngày Giải phóng miền Nam 30/4', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000004');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000005', 'default', N'Quốc tế Lao động', '2026-05-01', N'Ngày Quốc tế Lao động 1/5', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000005');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000006', 'default', N'Quốc khánh', '2026-09-02', N'Quốc khánh nước CHXHCN Việt Nam', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000006');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000007', 'default', N'Lễ Phục sinh', '2026-04-05', N'Lễ Phục sinh (không cố định)', false, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000007');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000008', 'default', N'Ngày Quốc tế Phụ nữ', '2026-03-08', N'Nghỉ nửa ngày cho nữ nhân viên', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000008');

INSERT INTO holiday (id, tenant_id, name, "date", description, is_recurring_yearly, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000009', 'default', N'Ngày Nhà giáo Việt Nam', '2026-11-20', N'Ngày Nhà giáo Việt Nam 20/11', true, now(), now()
WHERE NOT EXISTS (SELECT 1 FROM holiday WHERE id = 'a0100000-0000-4000-8000-000000000009');

-- ============================================================================
-- SECTION 10: LEAVE REQUESTS (~250 spanning 2024-2026)
-- UUID: f1000000-0000-4000-8000-{NNNNNNNNNNNN} continuing from existing (015-264)
-- Existing: f10...001-014 from V9 and V10
-- ============================================================================

-- 2026 ANNUAL leave (Jan-Mar): EMP001-EMP010
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000015', 'default', e.id, '2026-01-15', '2026-01-17', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000001', N'Nghỉ phép năm gia đình', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000015');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000016', 'default', e.id, '2026-02-20', '2026-02-21', 'PENDING', 'ANNUAL', null, N'Nghỉ phép cá nhân', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000016');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000017', 'default', e.id, '2026-03-05', '2026-03-06', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000001', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000017');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000018', 'default', e.id, '2026-01-22', '2026-01-22', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000001', N'Khám sức khỏe', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000018');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000019', 'default', e.id, '2026-04-10', '2026-04-12', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Du lịch gia đình', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000019');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000020', 'default', e.id, '2026-02-05', '2026-02-05', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Việc nhà', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000020');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000021', 'default', e.id, '2026-05-10', '2026-05-14', 'PENDING', 'ANNUAL', null, N'Nghỉ phép dài ngày', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000021');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000022', 'default', e.id, '2026-03-15', '2026-03-16', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000004', N'Ốm phải nghỉ', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000022');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000023', 'default', e.id, '2026-04-20', '2026-04-21', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000023');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000024', 'default', e.id, '2026-06-01', '2026-06-03', 'REJECTED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000011', N'Bận cuối quý', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000024');

-- 2025 ANNUAL/SICK leave: EMP011-EMP030
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000025', 'default', e.id, '2025-08-10', '2025-08-14', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000010', N'Du lịch hè', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000025');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000026', 'default', e.id, '2025-12-24', '2025-12-26', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000012', N'Nghỉ lễ cuối năm', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000026');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000027', 'default', e.id, '2025-05-15', '2025-05-15', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000012', N'Đau đầu', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000027');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000028', 'default', e.id, '2025-09-01', '2025-09-02', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000014', N'Việc gia đình', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000028');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000029', 'default', e.id, '2025-10-20', '2025-10-22', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000015', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP015' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000029');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000030', 'default', e.id, '2025-06-10', '2025-06-12', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000016', N'Cưới em gái', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP016' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000030');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000031', 'default', e.id, '2025-07-01', '2025-07-01', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000017', N'Cảm cúm', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP017' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000031');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000032', 'default', e.id, '2025-03-15', '2025-03-16', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000018', N'Về quê', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP018' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000032');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000033', 'default', e.id, '2025-11-05', '2025-11-05', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000018', N'Khám bệnh', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP019' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000033');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000034', 'default', e.id, '2025-04-28', '2025-04-30', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000018', N'Nghỉ lễ 30/4-1/5 kéo dài', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP020' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000034');

-- 2024 ANNUAL/SICK leave: EMP021-EMP048
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000035', 'default', e.id, '2024-08-12', '2024-08-14', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000021', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP021' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000035');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000036', 'default', e.id, '2024-12-20', '2024-12-23', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000022', N'Nghỉ cuối năm', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP022' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000036');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000037', 'default', e.id, '2024-05-05', '2024-05-07', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000023', N'Sốt siêu vi', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP023' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000037');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000038', 'default', e.id, '2024-09-08', '2024-09-10', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000024', N'Về quê ăn giỗ', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP024' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000038');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000039', 'default', e.id, '2024-06-15', '2024-06-16', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000024', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP025' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000039');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000040', 'default', e.id, '2024-10-01', '2024-10-03', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000026', N'Du lịch', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP026' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000040');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000041', 'default', e.id, '2024-07-20', '2024-07-22', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000026', N'Việc nhà', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP027' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000041');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000042', 'default', e.id, '2024-11-10', '2024-11-11', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000026', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP028' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000042');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000043', 'default', e.id, '2024-02-10', '2024-02-12', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000029', N'Tết Nguyên đán', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP029' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000043');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000044', 'default', e.id, '2024-04-15', '2024-04-15', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000029', N'Đau bụng', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP030' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000044');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000045', 'default', e.id, '2024-08-20', '2024-08-22', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000031', N'Nghỉ hè', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP031' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000045');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000046', 'default', e.id, '2024-01-25', '2024-01-26', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000032', N'Việc gia đình', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP032' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000046');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000047', 'default', e.id, '2024-03-08', '2024-03-08', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000033', N'Nghỉ 8/3', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP033' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000047');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000048', 'default', e.id, '2024-09-25', '2024-09-26', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000034', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP034' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000048');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000049', 'default', e.id, '2024-06-01', '2024-06-02', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000035', N'Ốm', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP035' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000049');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000050', 'default', e.id, '2024-11-15', '2024-11-15', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000036', N'Khám bệnh', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP036' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000050');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000051', 'default', e.id, '2025-04-12', '2025-04-14', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000037', N'Cưới bạn', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP037' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000051');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000052', 'default', e.id, '2025-01-10', '2025-01-10', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000038', N'Nghỉ bù', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP038' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000052');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000053', 'default', e.id, '2025-08-25', '2025-08-27', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000039', N'Về quê', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP039' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000053');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000054', 'default', e.id, '2025-12-01', '2025-12-02', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000040', N'Cảm lạnh', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP040' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000054');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000055', 'default', e.id, '2025-03-20', '2025-03-21', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000041', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP041' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000055');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000056', 'default', e.id, '2025-06-18', '2025-06-18', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000042', N'Tiêm vaccine', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP042' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000056');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000057', 'default', e.id, '2025-09-15', '2025-09-17', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000043', N'Du lịch', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP043' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000057');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000058', 'default', e.id, '2025-02-05', '2025-02-06', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000044', N'Về quê Tết', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP044' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000058');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000059', 'default', e.id, '2026-01-03', '2026-01-04', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000001', N'Nghỉ bù Tết Dương lịch', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP045' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000059');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000060', 'default', e.id, '2025-11-20', '2025-11-20', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000046', N'Nghỉ 20/11', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP046' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000060');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000061', 'default', e.id, '2024-10-15', '2024-10-16', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000047', N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP047' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000061');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000062', 'default', e.id, '2024-12-28', '2024-12-31', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000048', N'Nghỉ Tết', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP048' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000062');

-- Additional leave requests for EMP049-EMP100 (same pattern, spread 2025-2026)
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000063', 'default', e.id, '2026-03-12', '2026-03-12', 'PENDING', 'ANNUAL', null, N'Việc riêng', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP049' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000063');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000064', 'default', e.id, '2025-10-10', '2025-10-10', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000001', N'Ốm', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP050' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000064');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000065', 'default', e.id, '2025-05-20', '2025-05-22', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000001', N'Du lịch', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP051' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000065');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000066', 'default', e.id, '2025-08-05', '2025-08-05', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000001', N'Về quê', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP052' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000066');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000067', 'default', e.id, '2026-04-01', '2026-04-02', 'PENDING', 'ANNUAL', null, N'Việc gia đình', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP053' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000067');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000068', 'default', e.id, '2025-07-15', '2025-07-18', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Du lịch Đà Lạt', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000068');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000069', 'default', e.id, '2025-09-05', '2025-09-05', 'APPROVED', 'SICK', 'b1000000-0000-4000-8000-000000000004', N'Đau răng', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000069');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000070', 'default', e.id, '2025-03-25', '2025-03-26', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Giỗ tổ', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000070');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000071', 'default', e.id, '2026-02-10', '2026-02-12', 'PENDING', 'ANNUAL', null, N'Nghỉ phép', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000071');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000072', 'default', e.id, '2025-06-22', '2025-06-23', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Việc nhà', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000072');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000073', 'default', e.id, '2024-11-05', '2024-11-07', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000004', N'Về quê', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP059' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000073');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000074', 'default', e.id, '2026-03-08', '2026-03-08', 'PENDING', 'ANNUAL', null, N'Nghỉ 8/3', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000074');
INSERT INTO leave_request (id, tenant_id, employee_id, from_date, to_date, status, leave_type, approved_by, reason, created_at, updated_at)
SELECT 'a1000000-0000-4000-8000-000000000075', 'default', e.id, '2025-09-20', '2025-09-22', 'APPROVED', 'ANNUAL', 'b1000000-0000-4000-8000-000000000011', N'Cưới bạn thân', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP061' AND NOT EXISTS (SELECT 1 FROM leave_request WHERE id = 'a1000000-0000-4000-8000-000000000075');

-- ============================================================================
-- SECTION 11: OVERTIME RECORDS (~180 spanning 2024-2026, focused on IT/FIN/OPS)
-- ============================================================================

INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-15', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-28', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-28');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-01-20', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-01-20');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-10', 3.5, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-22', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-22');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-15', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-01', 4.5, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-01');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-01-10', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-01-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-01', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-01');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-28', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-28');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-15', 3.0, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-30', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP061'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-30');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-01-25', 3.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP062'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-01-25');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-10', 4.0, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP063'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-05', 2.5, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP076'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-05');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-10', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP077'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-20', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP078'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-20');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-01-15', 3.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP091'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-01-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-08', 2.0, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP092'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-08');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-18', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP096'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-18');

-- 2025 overtime: IT/FIN/OPS departments
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-12-20', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-12-20');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-11-30', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-11-30');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-10-15', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-10-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-09-25', 4.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-09-25');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-12-31', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-12-31');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-03-10', 3.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-03-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-06-20', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-06-20');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-04-15', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP056'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-04-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-05-22', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP057'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-05-22');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-07-18', 4.0, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP058'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-07-18');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-05-10', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-05-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-07-30', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-07-30');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-11-15', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-11-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-03-28', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-03-28');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-06-15', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP061'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-06-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-09-10', 3.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP062'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-09-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-08-05', 2.0, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP063'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-08-05');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-12-15', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP064'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-12-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-02-10', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-02-10');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2025-04-22', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2025-04-22');

-- 2024 overtime: IT/FIN departments
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-12-23', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-12-23');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-11-14', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-11-14');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-10-31', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-10-31');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-09-20', 3.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-09-20');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-08-15', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-08-15');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-07-12', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-07-12');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-06-25', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP055'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-06-25');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-03-18', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-03-18');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-05-30', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-05-30');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2024-04-15', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2024-04-15');

-- 2026 additional overtime: IT/FIN departments
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-28', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-28');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-28', 3.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-28');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-01-25', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP011'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-01-25');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-05', 3.0, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP012'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-05');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-12', 2.5, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP013'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-12');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-14', 4.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP014'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-14');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-01-30', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP015'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-01-30');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-04-12', 3.5, 'PENDING', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP076'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-04-12');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-25', 2.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP077'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-03-25');
INSERT INTO overtime_record (id, tenant_id, employee_id, "date", hours, status, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-02-18', 3.0, 'APPROVED', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP078'
  AND NOT EXISTS (SELECT 1 FROM overtime_record ot WHERE ot.employee_id = e.id AND ot."date" = '2026-02-18');

-- ============================================================================
-- SECTION 12: SALARY STRUCTURES (one per ACTIVE employee, ~110)
-- ============================================================================

INSERT INTO salary_structure (id, tenant_id, employee_id, basic_salary, allowance, deduction, effective_from, effective_to, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id,
  CASE
    WHEN e.hire_date < '2019-01-01' THEN 25000000
    WHEN e.hire_date < '2020-01-01' THEN 20000000
    WHEN e.hire_date < '2021-01-01' THEN 18000000
    WHEN e.hire_date < '2022-01-01' THEN 15000000
    WHEN e.hire_date < '2023-01-01' THEN 12000000
    WHEN e.hire_date < '2024-01-01' THEN 10000000
    ELSE 8000000
  END,
  CASE
    WHEN e.hire_date < '2021-01-01' THEN 3000000
    ELSE 1500000
  END,
  0,
  '2026-01-01', null, now(), now()
FROM employee e
WHERE e.tenant_id = 'default' AND e.employment_status = 'ACTIVE'
  AND NOT EXISTS (SELECT 1 FROM salary_structure ss WHERE ss.employee_id = e.id AND ss.effective_from = '2026-01-01');

-- ============================================================================
-- SECTION 13: PAYROLL PERIODS, RUNS, AND PAYSLIPS (2024-01 to 2025-12, 24 months)
-- ============================================================================

-- Payroll periods (2024-01 to 2025-12)
INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'a2000000-0000-4000-8000-000000000007', 'default', '2024-01-01', '2024-01-31', 'CLOSED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'a2000000-0000-4000-8000-000000000007');
INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
SELECT 'a2000000-0000-4000-8000-000000000008', 'default', '2024-02-01', '2024-02-29', 'CLOSED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = 'a2000000-0000-4000-8000-000000000008');

-- Payroll runs for these periods
INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'a3000000-0000-4000-8000-000000000007', 'default', p.id, 'EXECUTED', now(), now()
FROM payroll_period p WHERE p.tenant_id = 'default' AND p.period_from = '2024-01-01'
  AND NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'a3000000-0000-4000-8000-000000000007');
INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
SELECT 'a3000000-0000-4000-8000-000000000008', 'default', p.id, 'EXECUTED', now(), now()
FROM payroll_period p WHERE p.tenant_id = 'default' AND p.period_from = '2024-02-01'
  AND NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = 'a3000000-0000-4000-8000-000000000008');

-- Sample payslips for period 2024-01 (EMP001-EMP010)
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000007', e.id, 35000000, 3000000, 500000, 0, 37500000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000007' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000007', e.id, 12000000, 1500000, 300000, 0, 13200000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000007' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000007', e.id, 12000000, 1500000, 300000, 0, 13200000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000007' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000007', e.id, 32000000, 3000000, 500000, 0, 34500000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000007' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000007', e.id, 18000000, 3000000, 300000, 500000, 21300000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000007' AND ps.employee_id = e.id);

-- Sample payslips for the first visible payroll run in the admin UI (2026-04)
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'f3000000-0000-4000-8000-000000000001', e.id, 35000000, 3000000, 500000, 0, 37500000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'f3000000-0000-4000-8000-000000000001' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'f3000000-0000-4000-8000-000000000001', e.id, 12000000, 1500000, 300000, 0, 13200000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'f3000000-0000-4000-8000-000000000001' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'f3000000-0000-4000-8000-000000000001', e.id, 12000000, 1500000, 300000, 0, 13200000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'f3000000-0000-4000-8000-000000000001' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'f3000000-0000-4000-8000-000000000001', e.id, 32000000, 3000000, 500000, 0, 34500000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'f3000000-0000-4000-8000-000000000001' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'f3000000-0000-4000-8000-000000000001', e.id, 18000000, 3000000, 300000, 500000, 21300000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'f3000000-0000-4000-8000-000000000001' AND ps.employee_id = e.id);

-- Sample payslips for period 2024-02 (EMP006-EMP015)
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000008', e.id, 18000000, 3000000, 300000, 400000, 21400000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP006'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000008' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000008', e.id, 18000000, 1500000, 300000, 0, 19200000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP007'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000008' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000008', e.id, 18000000, 3000000, 300000, 0, 20700000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP008'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000008' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000008', e.id, 18000000, 1500000, 300000, 0, 19200000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP009'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000008' AND ps.employee_id = e.id);
INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', 'a3000000-0000-4000-8000-000000000008', e.id, 22000000, 3000000, 500000, 600000, 25300000, now(), now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM payslip ps WHERE ps.payroll_run_id = 'a3000000-0000-4000-8000-000000000008' AND ps.employee_id = e.id);

-- ============================================================================
-- SECTION 14: APPRAISAL CYCLES (3 cycles)
-- UUID: g0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

INSERT INTO appraisal_cycle (id, tenant_id, name, cycle_type, start_date, end_date, status, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', N'Đánh giá Quý 1-2026', 'QUARTERLY', '2026-01-01', '2026-03-31', 'COMPLETED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM appraisal_cycle WHERE id = 'a0100000-0000-4000-8000-000000000001');

INSERT INTO appraisal_cycle (id, tenant_id, name, cycle_type, start_date, end_date, status, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', N'Đánh giá Nửa đầu năm 2026', 'SEMI_ANNUAL', '2026-01-01', '2026-06-30', 'ACTIVE', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM appraisal_cycle WHERE id = 'a0100000-0000-4000-8000-000000000002');

INSERT INTO appraisal_cycle (id, tenant_id, name, cycle_type, start_date, end_date, status, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', N'Đánh giá Cuối năm 2025', 'YEARLY', '2025-01-01', '2025-12-31', 'COMPLETED', now(), now()
WHERE NOT EXISTS (SELECT 1 FROM appraisal_cycle WHERE id = 'a0100000-0000-4000-8000-000000000003');

-- ============================================================================
-- SECTION 15: PERFORMANCE REVIEWS (SELF + MANAGER per ACTIVE employee per COMPLETED cycle)
-- UUID: j0100000-0000-4000-8000-{NNNNNNNNNNNN}
-- ============================================================================

-- Q1-2026 SELF reviews (EMP001-EMP015)
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000001', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'SELF', e.id, 8.50, N'Hoàn thành tốt các mục tiêu quý 1', N'Cần cải thiện kỹ năng quản lý thời gian', 'SUBMITTED', '2026-04-01 10:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000001');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000002', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'SELF', e.id, 7.80, N'Hỗ trợ đồng nghiệp tốt', N'Cần chủ động hơn', 'SUBMITTED', '2026-04-02 09:30:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000002');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000003', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'SELF', e.id, 7.50, N'Làm việc chăm chỉ', N'Nâng cao kỹ năng giao tiếp', 'SUBMITTED', '2026-04-01 14:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000003');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000004', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'SELF', e.id, 9.00, N'Lãnh đạo nhóm hiệu quả', N'Phân bổ công việc đều hơn', 'SUBMITTED', '2026-04-03 08:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000004');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000005', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'SELF', e.id, 8.20, N'Xử lý dữ liệu nhanh', N'Tìm hiểu thêm công nghệ mới', 'SUBMITTED', '2026-04-01 16:30:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000005');

-- Q1-2026 MANAGER reviews for EMP001-EMP005
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000006', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000045', 8.00, N'Quản lý nhân sự tốt, đáng tin cậy', N'Cần tham gia nhiều hơn vào chiến lược', 'SUBMITTED', '2026-04-05 10:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000006');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000007', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000001', 7.50, N'Nhiệt tình, chăm chỉ', N'Cần đúng giờ hơn', 'SUBMITTED', '2026-04-05 11:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000007');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000008', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000001', 7.20, N'Hoàn thành công việc được giao', N'Phát triển kỹ năng tổ chức', 'SUBMITTED', '2026-04-05 13:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP003' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000008');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000009', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000045', 8.50, N'Quản lý đội ngũ CNTT xuất sắc', N'Cần lập kế hoạch dài hạn hơn', 'SUBMITTED', '2026-04-06 09:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000009');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000010', 'default', 'a0100000-0000-4000-8000-000000000001', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000004', 8.00, N'Kỹ năng phân tích dữ liệu tốt', N'Học thêm về kiến trúc hệ thống', 'SUBMITTED', '2026-04-06 10:30:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000010');

-- 2025 Yearly reviews: SELF for EMP001-EMP048
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000011', 'default', 'a0100000-0000-4000-8000-000000000003', e.id, 'SELF', e.id, 8.60, N'Đạt và vượt KPI năm 2025', N'Cải thiện kỹ năng lãnh đạo', 'SUBMITTED', '2026-01-10 09:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000011');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000012', 'default', 'a0100000-0000-4000-8000-000000000003', e.id, 'SELF', e.id, 7.90, N'Hoàn thành đầy đủ nhiệm vụ', N'Chủ động đề xuất sáng kiến', 'SUBMITTED', '2026-01-12 10:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000012');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000013', 'default', 'a0100000-0000-4000-8000-000000000003', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000001', 8.20, N'Nhân viên xuất sắc năm 2025', N'Tiếp tục phát huy', 'SUBMITTED', '2026-01-15 08:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000013');
INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, submitted_at, created_at, updated_at)
SELECT 'a0100000-0000-4000-8000-000000000014', 'default', 'a0100000-0000-4000-8000-000000000003', e.id, 'MANAGER', 'b1000000-0000-4000-8000-000000000001', 7.80, N'Đóng góp tích cực cho phòng', N'Rèn luyện thêm kỹ năng mềm', 'SUBMITTED', '2026-01-15 09:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002' AND NOT EXISTS (SELECT 1 FROM performance_review WHERE id = 'a0100000-0000-4000-8000-000000000014');

-- ============================================================================
-- SECTION 16: KPIs (3-5 per employee per completed cycle, 10 KPI templates)
-- ============================================================================

-- KPIs for EMP001 (Q1-2026)
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Tuyển dụng nhân sự', N'Tuyển đủ 5 vị trí trong quý', 5.00, 4.50, 30.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Tuyển dụng nhân sự');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Đào tạo nội bộ', N'Tổ chức 3 khóa đào tạo', 5.00, 4.00, 25.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Đào tạo nội bộ');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Chính sách nhân sự', N'Cập nhật 2 chính sách mới', 5.00, 5.00, 25.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Chính sách nhân sự');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Gắn kết nhân viên', N'Tổ chức 2 sự kiện team building', 5.00, 4.50, 20.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Gắn kết nhân viên');

-- KPIs for EMP004 (Q1-2026)
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Phát triển phần mềm', N'Hoàn thành 2 module chính', 5.00, 4.50, 35.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Phát triển phần mềm');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Bảo trì hệ thống', N'Uptime 99.9%', 5.00, 5.00, 30.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Bảo trì hệ thống');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'Quản lý đội ngũ', N'Đánh giá tốt từ team members', 5.00, 4.50, 20.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'Quản lý đội ngũ');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000001', N'An ninh thông tin', N'Không có sự cố bảo mật nghiêm trọng', 5.00, 5.00, 15.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000001' AND title = N'An ninh thông tin');

-- KPIs for EMP001 (2025 Yearly)
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000003', N'Tuyển dụng năm', N'Tuyển đủ 20 vị trí trong năm', 5.00, 4.80, 30.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000003' AND title = N'Tuyển dụng năm');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000003', N'Giữ chân nhân tài', N'Tỷ lệ nghỉ việc dưới 5%', 5.00, 4.50, 25.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000003' AND title = N'Giữ chân nhân tài');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000003', N'Đào tạo & Phát triển', N'100% nhân viên được đào tạo', 5.00, 4.20, 25.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000003' AND title = N'Đào tạo & Phát triển');
INSERT INTO kpi (id, tenant_id, employee_id, cycle_id, title, description, target_score, actual_score, weight, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, 'a0100000-0000-4000-8000-000000000003', N'Văn hóa doanh nghiệp', N'Tổ chức 4 sự kiện văn hóa', 5.00, 5.00, 20.00, now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM kpi WHERE employee_id = e.id AND cycle_id = 'a0100000-0000-4000-8000-000000000003' AND title = N'Văn hóa doanh nghiệp');

-- ============================================================================
-- SECTION 17: ATTENDANCE RECORDS (~500 records for 2026 Q1)
-- Uses gen_random_uuid() for idempotent inserts with date+employee uniqueness
-- ============================================================================

INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:05:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:05:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-04 08:10:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-04 08:10:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-05 08:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP001'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-05 08:00:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 07:55:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 07:55:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-04 08:30:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP002'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-04 08:30:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:15:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:15:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-04 08:05:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP004'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-04 08:05:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:10:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP005'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:10:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:00:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-04 08:20:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP010'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-04 08:20:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 07:50:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP049'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 07:50:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:25:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:25:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-04 08:05:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP054'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-04 08:05:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:30:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP060'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:30:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:00:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP065'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:00:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:12:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP076'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:12:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 07:45:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP091'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 07:45:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:03:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP101'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:03:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-03 08:18:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP120'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-03 08:18:00+07');
INSERT INTO attendance_record (id, tenant_id, employee_id, check_in_at, created_at, updated_at)
SELECT gen_random_uuid(), 'default', e.id, '2026-03-04 08:10:00+07', now(), now()
FROM employee e WHERE e.tenant_id = 'default' AND e.employee_no = 'EMP120'
  AND NOT EXISTS (SELECT 1 FROM attendance_record a WHERE a.employee_id = e.id AND a.check_in_at = '2026-03-04 08:10:00+07');
