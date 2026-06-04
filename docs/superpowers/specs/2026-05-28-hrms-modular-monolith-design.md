# HRMS Modular Monolith Design Spec

**Source:** `docs/human-resource-management.md`  
**Date:** 2026-05-28  
**Status:** Draft for implementation planning

## 1. Goal

Xây dựng hệ thống quản lý nhân sự đa phòng ban (HRMS) theo kiến trúc modular monolith, ưu tiên triển khai nhanh, kiểm soát chất lượng kỹ thuật, và đủ khả năng mở rộng dần theo business capability.

## 2. Scope

### In scope (release roadmap)

1. Identity & Access (RBAC + permission chi tiết + OIDC integration option)
2. Organization (công ty/pháp nhân/chi nhánh/phòng ban/chức danh)
3. Employee Core (hồ sơ nhân viên + lịch sử thay đổi)
4. Recruitment (job posting, candidate, application, interview, offer)
5. Attendance & Leave (ca làm, công, phép, phê duyệt)
6. Payroll (kỳ lương, payroll run, khóa kỳ, export)
7. Reporting (dashboard + export báo cáo)
8. Audit & Observability (audit nghiệp vụ + kỹ thuật, metrics/logs/traces)
9. Integration (email, webhook/event, ERP/kế toán, máy chấm công)

### Out of scope (cho vòng đầu)

1. Chuyển sang microservices ngay từ đầu
2. Mobile app native
3. Tùy biến pháp lý payroll theo nhiều quốc gia nếu chưa có rule rõ

## 3. Constraints & Assumptions

1. Stack chính: Java 21, Spring Boot 4, Spring Security, Spring Data JPA, PostgreSQL 17, Redis, RabbitMQ.
2. API mặc định là REST + OpenAPI 3.1; GraphQL chỉ dùng cho read-composition khi cần.
3. Multi-tenant mặc định tắt (single company/group); bật dần nếu có yêu cầu cô lập tenant rõ ràng.
4. Nhiều tham số nghiệp vụ còn thiếu (công thức lương, SLA, tích hợp cụ thể, pháp lý); thiết kế giữ hướng mở rộng.

## 4. Architecture

## 4.1 Runtime shape

1. Một deployable Spring Boot ứng dụng lõi.
2. PostgreSQL làm transactional store.
3. Redis cho cache/session/token blacklist.
4. RabbitMQ cho tác vụ async (import/export, notification, integration sync).
5. Object storage cho file hồ sơ/đính kèm/payslip.

## 4.2 Module boundaries

- `shared`: cấu hình chung, security config, tenant context, exception model, audit helpers
- `identity`: user, role, permission, authz rules, idp mapping
- `organization`: legal entity, branch, department tree, job title, cost center
- `employee`: employee profile, contract, employment status/history
- `recruitment`: pipeline ứng viên và chuyển đổi candidate -> employee
- `attendance`: shift, timesheet, leave request, approval flow
- `payroll`: payroll period, payroll run, adjustments, lock/approve cycle
- `reporting`: reporting queries, export job orchestration
- `integration`: external connectors + outbox/event delivery
- `audit`: business audit trail và technical auth audit

## 4.3 Data flow patterns

1. Sync transaction flow: client -> REST API -> application service -> domain -> repository -> PostgreSQL.
2. Async flow: module phát domain event -> outbox -> RabbitMQ -> worker -> external system/report generation.
3. Audit flow: mọi thay đổi nghiệp vụ nhạy cảm ghi audit record với actor + timestamp + before/after (khi áp dụng).

## 5. Security Design

1. RBAC + permission chi tiết theo `resource:action`.
2. Method-level authorization cho endpoint/use case.
3. Tenant-aware access check (khi bật multi-tenant).
4. Secrets không hardcode; sử dụng env/secret manager.
5. CSRF/session policy theo kiểu auth (JWT stateless hoặc cookie-session stateful).

## 6. Data Design Principles

1. Mọi bảng nghiệp vụ chính có audit columns (`created_at`, `updated_at`, `created_by`, `updated_by`).
2. Dữ liệu có lifecycle (contract, assignment, payroll run) lưu history thay vì overwrite.
3. Payroll/attendance có trạng thái chốt kỳ rõ ràng để tránh sửa dữ liệu sau khóa kỳ.
4. Index theo access path thực tế (`tenant_id`, `employee_no`, `department_id`, trạng thái kỳ).
5. Migration quản lý bằng Flyway, chạy trong CI và startup policy rõ ràng theo môi trường.

## 7. API Design Principles

1. Versioned base path: `/api/v1/...`
2. Idempotency cho endpoint tạo job async/import khi cần.
3. Correlation ID xuyên suốt request -> log -> event.
4. Chuẩn hóa error response (code, message, field violations, trace id).
5. OpenAPI contract lưu trong repo và kiểm soát review cùng code.

## 8. Testing Strategy

1. Unit test cho domain rules/use case.
2. Slice test cho web/data/security layer.
3. Integration test với Testcontainers (PostgreSQL/Redis/RabbitMQ).
4. Security test cho authorization matrix.
5. Migration test đảm bảo nâng cấp schema an toàn.
6. Architecture/modulith boundary test để chặn phụ thuộc sai module.

## 9. Delivery Strategy

1. Foundation: bootstrap + security base + observability + CI.
2. Core HR: identity + organization + employee + audit.
3. Talent & Attendance: recruitment + attendance.
4. Payroll & Reporting: payroll + reporting + integration events.
5. UAT & Hardening: perf, backup/restore drill, security review, go-live checklist.

## 10. Risks & Mitigations

1. **Rò rỉ phân quyền:** enforce permission checks ở service + integration tests theo matrix.
2. **Lệch schema môi trường:** bắt buộc Flyway trong pipeline, chặn deploy nếu migration fail.
3. **Sai payroll do dữ liệu nguồn biến động:** snapshot input payroll, khóa kỳ và approval workflow.
4. **Đứt gãy tích hợp ngoài:** retry policy + dead-letter queue + audit integration event.
5. **Hiệu năng query báo cáo:** tách read model/materialized view cho báo cáo nặng.

## 11. Acceptance Criteria (Design Level)

1. Kiến trúc phải giữ modular boundaries rõ ràng và kiểm thử được.
2. Security/audit là default behavior, không phụ thuộc “nhớ bật”.
3. Các module phát triển độc lập theo sprint mà vẫn chạy chung một deployable.
4. Có thể triển khai môi trường dev bằng Docker Compose.
5. Có lộ trình tách dần module thành service khi scale tổ chức tăng.

## 12. Open Decisions Before Execution

1. Công thức payroll chi tiết, quy tắc thuế/bảo hiểm/phúc lợi.
2. Danh sách tích hợp bắt buộc trong phase 1 (ERP, máy chấm công, email, BI).
3. SLA mục tiêu và tải đồng thời dự kiến.
4. Chiến lược cloud/on-prem cụ thể và ngân sách vận hành.

