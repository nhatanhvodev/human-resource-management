# HRMS Upgrade — Design Spec

**Date:** 2026-06-04
**Scope:** Nâng cấp toàn diện 14 tính năng mới
**Context:** Hệ thống nội bộ, công ty <50 NV, tiếng Việt + tiếng Anh

## Summary of Decisions

| Decision | Choice |
|----------|--------|
| Architecture | Monolith mở rộng (single Spring Boot + single React app) |
| ESS approach | Role-based routing trong cùng React app |
| Chart library | ECharts |
| i18n | react-i18next (Vi + En) |
| File storage | Local filesystem (nâng lên S3/MinIO sau) |
| Drag-and-drop | @dnd-kit |

---

## Section 1: Employee Self-Service (ESS) Portal

### Backend

Thêm claim `role` vào JWT token (ADMIN | EMPLOYEE). Endpoints hiện có đã dùng `@PreAuthorize` — employee chỉ xem dữ liệu của chính mình.

Thêm endpoint:
- `GET /api/v1/employees/me` — profile user đang login
- `GET /api/v1/payslips/mine?periodId=` — payslip cá nhân
- Các endpoint `/leave-requests`, `/time-entries`, `/documents` filter theo employeeId từ JWT

### Frontend

```
web-admin/src/
├── app/
│   ├── layout/
│   │   ├── AdminShell.tsx        (rename từ AppShell)
│   │   └── EmployeeShell.tsx     MỚI
│   └── router.tsx                (thêm role check)
├── features/
│   ├── dashboard/                (admin — existing, enhanced)
│   ├── employees/                (admin — existing)
│   ├── departments/              (admin — existing)
│   ├── leave/                    (admin — existing)
│   ├── payroll/                  (admin — existing)
│   ├── performance/              (admin — existing)
│   ├── recruitment/              (admin — existing, enhanced)
│   ├── settings/                 (admin — existing)
│   ├── attendance/               MỚI (admin time tracking)
│   ├── documents/                MỚI (admin document management)
│   ├── onboarding/               MỚI (admin onboarding management)
│   ├── training/                 MỚI (admin training management)
│   ├── assets/                   MỚI (admin asset management)
│   ├── announcements/            MỚI (admin announcement management)
│   ├── audit/                    MỚI (admin audit log viewer)
│   └── ess/                      MỚI (employee portal)
│       ├── EssDashboardPage.tsx
│       ├── MyProfilePage.tsx
│       ├── MyPayslipsPage.tsx
│       ├── MyLeavePage.tsx
│       ├── MyAttendancePage.tsx
│       ├── MyDocumentsPage.tsx
│       ├── MyOnboardingPage.tsx
│       └── MyTrainingPage.tsx
├── shared/
│   ├── auth/
│   │   └── useRole.ts            MỚI (hook: đọc role từ JWT)
│   └── i18n/                     MỚI
│       ├── index.ts
│       ├── locales/vi.json
│       ├── locales/en.json
│       └── LanguageSwitcher.tsx
```

### EmployeeShell navigation
- Tổng quan (mini dashboard: giờ làm tuần, ngày nghỉ còn lại, thông báo)
- Hồ sơ của tôi (view + edit limited fields)
- Phiếu lương (danh sách + chi tiết)
- Nghỉ phép (tạo đơn + xem lịch sử)
- Chấm công (clock in/out + timesheet)
- Tài liệu (xem + upload)
- Onboarding (nếu đang trong quá trình)
- Đào tạo (khóa học đang tham gia)

---

## Section 2: Advanced Dashboard & Analytics

### Backend

Thêm vào DashboardController:
- `GET /api/v1/dashboard/employee-trend?months=6` — số liệu theo tháng
- `GET /api/v1/dashboard/department-distribution` — pie chart data
- `GET /api/v1/dashboard/leave-summary?year=` — nghỉ phép theo loại
- `GET /api/v1/dashboard/payroll-summary?year=` — chi phí lương theo tháng
- `GET /api/v1/dashboard/export?type=summary&format=pdf` — export báo cáo

### Frontend

DashboardPage nâng cấp:
1. Row 1: 5 Statistic cards (existing, enhanced với trend indicator)
2. Row 2: Employee trend line chart (ECharts) + Department pie chart
3. Row 3: Department headcount horizontal bar chart (thay thế bar thủ công hiện tại)
4. Row 4: Leave summary + Payroll cost trend
5. Row 5: Recent activities table (existing)
6. Toolbar: Date range picker + Export button (PDF/Excel)

---

## Section 3: Organization Chart

### Backend
`GET /api/v1/departments/tree` → cấu trúc cây:
```json
[
  {
    "id": "...", "code": "ENG", "name": "Engineering",
    "children": [],
    "employees": [
      { "id": "...", "employeeNo": "E001", "fullName": "...", "positionTitle": "...", "avatar": null }
    ]
  }
]
```

### Frontend
ECharts tree chart hoặc custom React horizontal tree component. Node: avatar placeholder + tên + chức danh. Click node → drawer detail.

---

## Section 4: i18n (Việt + Anh)

Dùng `react-i18next` + `i18next`. Text cứng extract ra JSON:

- `vi.json`: Vietnamese labels
- `en.json`: English labels

LanguageSwitcher: Select dropdown trong header. Lưu preference vào localStorage.
Ant Design i18n: `ConfigProvider` với `antd/locale/vi_VN` và `antd/locale/en_US`.

---

## Section 5: Time Tracking / Chấm công

### Backend (mở rộng module attendance)

```
attendance/
├── domain/
│   ├── TimeEntry.java           MỚI
│   │   fields: id, tenantId, employeeId, date, clockIn, clockOut, totalMinutes, status
│   └── TimeEntryStatus.java     MỚI: PENDING, APPROVED, REJECTED
├── application/
│   └── TimeTrackingService.java MỚI
├── infrastructure/
│   └── TimeEntryRepository.java MỚI
└── interfaces/api/
    └── TimeTrackingController.java MỚI
```

Endpoints:
- `POST /api/v1/time-entries/clock-in`
- `POST /api/v1/time-entries/clock-out`
- `GET  /api/v1/time-entries/mine?from=&to=` (ESS)
- `GET  /api/v1/time-entries?employeeId=&from=&to=&status=` (admin)
- `POST /api/v1/time-entries/{id}/approve`
- `POST /api/v1/time-entries/{id}/reject`
- `GET  /api/v1/time-entries/timesheet?employeeId=&weekStart=` (tổng hợp tuần)

### Frontend
- **Admin:** `features/attendance/AttendancePage.tsx` — table filterable + approve/reject
- **ESS:** `features/ess/MyAttendancePage.tsx` — nút Clock In/Out + timesheet tuần hiện tại

---

## Section 6: Document Management

### Backend (module mới: document)

```
document/
├── domain/
│   └── Document.java
│       fields: id, tenantId, employeeId, fileName, originalName, fileType,
│               fileSize, storagePath, category (CONTRACT/CV/CERTIFICATE/OTHER), uploadedAt
├── application/
│   └── DocumentService.java
├── infrastructure/
│   └── DocumentRepository.java
└── interfaces/api/
    └── DocumentController.java
```

Endpoints:
- `POST /api/v1/documents/upload` (multipart: file + employeeId + category)
- `GET  /api/v1/documents/{id}/download` (stream file)
- `GET  /api/v1/documents?employeeId=&category=` (list)
- `DELETE /api/v1/documents/{id}`
- `GET  /api/v1/documents/mine` (ESS)

Storage pattern: `{base-path}/tenants/{tenantId}/{year}/{month}/{uuid}-{originalName}`

### Frontend
- **Admin:** `features/documents/DocumentsPage.tsx` — table + Upload + filter + preview
- **ESS:** `features/ess/MyDocumentsPage.tsx` — upload + view own docs

---

## Section 7: Notifications System

### Backend (mở rộng integration module)

```
integration/
├── domain/
│   └── Notification.java
│       fields: id, tenantId, recipientId, title, body, type, isRead, createdAt
├── application/
│   └── NotificationService.java
└── interfaces/api/
    └── NotificationController.java
```

Endpoints:
- `GET  /api/v1/notifications/mine?unreadOnly=` (ESS)
- `GET  /api/v1/notifications/mine/count` (badge count)
- `POST /api/v1/notifications/{id}/read`
- `POST /api/v1/notifications` (admin — gửi thông báo)

Trigger points (`NotificationService.create()`):
- LeaveRequest approve/reject → thông báo employee
- PayrollRun hoàn thành → "Phiếu lương đã sẵn sàng"
- RecruitmentService.convertToEmployee() → thông báo chào mừng
- PerformanceReview submitted → thông báo manager

### Frontend
- `NotificationBell.tsx` — Badge icon + dropdown (5 items gần nhất) + click mark read
- Tích hợp vào AdminShell và EmployeeShell header

---

## Section 8: Announcements / Company News

### Backend

```
integration/
├── domain/
│   └── Announcement.java
│       fields: id, tenantId, authorId, title, content, publishAt, expireAt,
│               priority (LOW/NORMAL/HIGH/URGENT), createdAt
├── application/
│   └── AnnouncementService.java
└── interfaces/api/
    └── AnnouncementController.java
```

Endpoints:
- `GET/POST/PUT/DELETE /api/v1/announcements`
- `GET /api/v1/announcements/active` (public)

### Frontend
- **Admin:** `features/announcements/AnnouncementsPage.tsx` — CRUD + rich text editor (react-quill)
- **Employee:** card list trên ESS dashboard
- URGENT announcements: banner ở top

---

## Section 9: Onboarding / Offboarding Automation

### Backend (module mới: onboarding)

```
onboarding/
├── domain/
│   ├── OnboardingTask.java
│   ├── OnboardingTemplate.java
│   └── OnboardingTemplateTask.java
├── application/
│   └── OnboardingService.java
├── infrastructure/
│   ├── OnboardingTaskRepository.java
│   └── OnboardingTemplateRepository.java
└── interfaces/api/
    └── OnboardingController.java
```

Endpoints:
- `POST /api/v1/onboarding/start?employeeId=&templateId=`
- `GET  /api/v1/onboarding/{employeeId}/tasks`
- `POST /api/v1/onboarding/tasks/{id}/complete`
- `GET/POST/PUT/DELETE /api/v1/onboarding/templates` (admin)
- `POST /api/v1/onboarding/{employeeId}/offboard`

Auto-trigger: `RecruitmentService.convertToEmployee()` → start onboarding template mặc định.

### Frontend
- **Admin:** `features/onboarding/OnboardingPage.tsx` — templates + progress tracking
- **Admin:** `features/onboarding/OnboardingBoard.tsx` — Kanban: TODO/IN PROGRESS/DONE
- **ESS:** `features/ess/MyOnboardingPage.tsx` — checklist + checkbox

---

## Section 10: Recruitment Pipeline nâng cao

### Backend (mở rộng recruitment)

Thêm entity Interview:
```
├── domain/
│   └── Interview.java           MỚI
│       fields: id, applicationId, interviewerId, scheduledAt, location,
│               meetingLink, feedback, rating (1-5), status (SCHEDULED/COMPLETED/CANCELLED)
```

Thêm endpoints:
- `POST /api/v1/applications/{id}/move-stage?stage=`
- `POST /api/v1/interviews` (schedule)
- `PUT  /api/v1/interviews/{id}/feedback`
- `GET  /api/v1/interviews?applicationId=`

### Frontend
- `features/recruitment/RecruitmentKanban.tsx` — Kanban drag-drop (@dnd-kit). Columns: Screen, Phone Interview, Technical, Onsite, Offer, Hired, Rejected
- `features/recruitment/InterviewScheduler.tsx` — modal: date/time picker, interviewer, location
- `features/recruitment/InterviewFeedback.tsx` — modal: rating 1-5, feedback text

---

## Section 11: Training & Development

### Backend (module mới: training)

```
training/
├── domain/
│   ├── Course.java
│   ├── Enrollment.java
│   └── Certification.java
├── application/
│   └── TrainingService.java
├── infrastructure/
│   ├── CourseRepository.java
│   ├── EnrollmentRepository.java
│   └── CertificationRepository.java
└── interfaces/api/
    └── TrainingController.java
```

Endpoints:
- `GET/POST/PUT/DELETE /api/v1/training/courses`
- `POST /api/v1/training/courses/{id}/enroll?employeeId=`
- `POST /api/v1/training/enrollments/{id}/progress`
- `POST /api/v1/training/enrollments/{id}/complete`
- `GET  /api/v1/training/my-courses` (ESS)
- `POST /api/v1/training/certifications`
- `GET  /api/v1/training/stats` (admin)

### Frontend
- **Admin:** `features/training/TrainingPage.tsx` — catalog + CRUD
- **Admin:** `features/training/CourseDetailPage.tsx` — info + enrolled list + progress
- **Admin:** `features/training/TrainingDashboard.tsx` — stats
- **ESS:** `features/ess/MyTrainingPage.tsx` — my courses + progress bar

---

## Section 12: Asset Management

### Backend (module mới: asset)

```
asset/
├── domain/
│   ├── Asset.java
│   └── AssetAssignment.java
├── application/
│   └── AssetService.java
├── infrastructure/
│   ├── AssetRepository.java
│   └── AssetAssignmentRepository.java
└── interfaces/api/
    └── AssetController.java
```

Endpoints:
- `GET/POST/PUT/DELETE /api/v1/assets`
- `POST /api/v1/assets/{id}/assign?employeeId=`
- `POST /api/v1/assets/{id}/return`
- `GET  /api/v1/assets/{id}/history`
- `GET  /api/v1/assets/mine` (ESS)

### Frontend
- **Admin:** `features/assets/AssetsPage.tsx` — table + filter + assign/return + history drawer
- **ESS:** My assets section trong MyProfilePage

---

## Section 13: Audit Trail UI

### Backend
Tạo AuditLog entity hoặc tận dụng OutboxEvent:
- `GET /api/v1/audit-logs?entityType=&entityId=&action=&from=&to=&page=&size=`

```
audit/
├── domain/
│   └── AuditLog.java
│       fields: id, tenantId, entityType, entityId, action, actorId, details (JSON), timestamp
└── interfaces/api/
    └── AuditLogController.java
```

### Frontend
`features/audit/AuditLogPage.tsx` — table: Thời gian, Người thực hiện, Hành động, Đối tượng, Chi tiết. Filter: entity type, date range, actor.

---

## Section 14: Mobile PWA Support

Dùng `vite-plugin-pwa`:

```typescript
import { VitePWA } from 'vite-plugin-pwa'

VitePWA({
  registerType: 'autoUpdate',
  manifest: {
    name: 'HRMS', short_name: 'HRMS',
    theme_color: '#1677ff',
    icons: [{ src: '/icon-192.png', sizes: '192x192', type: 'image/png' }]
  },
  workbox: { globPatterns: ['**/*.{js,css,html,ico,png,svg}'] }
})
```

Không yêu cầu backend thay đổi.

---

## Backend Module Summary

| # | Module | Type | Entities | Controller |
|---|--------|------|----------|------------|
| 1 | attendance (extend) | Mở rộng | TimeEntry, TimeEntryStatus | TimeTrackingController |
| 2 | document | MỚI | Document | DocumentController |
| 3 | integration (extend) | Mở rộng | Notification, Announcement | NotificationController, AnnouncementController |
| 4 | onboarding | MỚI | OnboardingTask, OnboardingTemplate, OnboardingTemplateTask | OnboardingController |
| 5 | recruitment (extend) | Mở rộng | Interview | (extend RecruitmentController) |
| 6 | training | MỚI | Course, Enrollment, Certification | TrainingController |
| 7 | asset | MỚI | Asset, AssetAssignment | AssetController |
| 8 | audit | MỚI | AuditLog | AuditLogController |
| 9 | reporting (extend) | Mở rộng | — | (extend DashboardController) |

## Frontend Route Map

| Path | Shell | Page | Role |
|------|-------|------|------|
| `/dashboard` | Admin | DashboardPage (enhanced) | ADMIN |
| `/departments` | Admin | DepartmentsPage | ADMIN |
| `/employees` | Admin | EmployeesPage | ADMIN |
| `/recruitment` | Admin | RecruitmentPage (enhanced) | ADMIN |
| `/leave` | Admin | LeavePage | ADMIN |
| `/payroll` | Admin | PayrollPage | ADMIN |
| `/performance` | Admin | PerformancePage | ADMIN |
| `/attendance` | Admin | AttendancePage | ADMIN |
| `/documents` | Admin | DocumentsPage | ADMIN |
| `/onboarding` | Admin | OnboardingPage | ADMIN |
| `/training` | Admin | TrainingPage | ADMIN |
| `/assets` | Admin | AssetsPage | ADMIN |
| `/announcements` | Admin | AnnouncementsPage | ADMIN |
| `/audit` | Admin | AuditLogPage | ADMIN |
| `/settings` | Admin | DevSettingsPage | ADMIN |
| `/ess/dashboard` | Employee | EssDashboardPage | EMPLOYEE |
| `/ess/profile` | Employee | MyProfilePage | EMPLOYEE |
| `/ess/payslips` | Employee | MyPayslipsPage | EMPLOYEE |
| `/ess/leave` | Employee | MyLeavePage | EMPLOYEE |
| `/ess/attendance` | Employee | MyAttendancePage | EMPLOYEE |
| `/ess/documents` | Employee | MyDocumentsPage | EMPLOYEE |
| `/ess/onboarding` | Employee | MyOnboardingPage | EMPLOYEE |
| `/ess/training` | Employee | MyTrainingPage | EMPLOYEE |

## Technical Decisions

- **Charts:** ECharts (echarts + echarts-for-react)
- **i18n:** react-i18next + i18next + i18next-browser-languagedetector
- **Drag-and-drop:** @dnd-kit/core + @dnd-kit/sortable
- **Rich text:** react-quill (for announcements)
- **File upload:** antd Upload component (built-in)
- **PWA:** vite-plugin-pwa (workbox)
- **Role check:** JWT claim `role`, custom hook `useRole()` từ decoded JWT
- **Storage path:** `{base-path}/tenants/{tenantId}/{entityType}/{year}/{month}/{uuid}-{sanitized-filename}`
