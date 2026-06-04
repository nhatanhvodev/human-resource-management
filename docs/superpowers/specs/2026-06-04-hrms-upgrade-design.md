# HRMS Platform Upgrade — Design Spec

## Scope

Upgrade the HRMS modular monolith (Java 21 + Spring Boot 4 + Spring Modulith + Vue 3) with enriched existing modules, 2 new modules, and comprehensive Vietnamese sample data.

---

## Section 1: Module Scope

### Existing Modules — Enhancements

| Module | Adds |
|--------|------|
| **Employee** | Position, salary, email, phone, dateOfBirth, gender, nationalId, address, bankAccount, taxCode, EmployeeContract, EmployeeSkill, EmergencyContact |
| **Attendance** | LeaveType enum, approvedBy, LeaveBalance, Holiday calendar, OvertimeRecord |
| **Payroll** | SalaryStructure, Payslip with breakdown (basic, allowance, deduction, overtime, net) |
| **Department** | Department hierarchy (parent-child self-reference), manager assignment |
| **Recruitment** | No schema changes — richer seed data only |
| **Reporting** | Real analytics queries: headcount by dept, attendance stats, payroll summaries |

### New Modules

| Module | Entities |
|--------|----------|
| **Performance** | AppraisalCycle, PerformanceReview (self + manager), KPI |
| **Employee Self-Service** | No new entities — new `/api/self/**` endpoints reusing existing entities |

### Seed Data

- ~120 employees across 14 departments
- 3 years of attendance records (~60K rows)
- ~250 leave requests, leave balances, ~180 overtime records
- 24 monthly payroll runs with ~2,880 payslips
- 3 appraisal cycles with full reviews and KPIs
- Vietnamese holidays

---

## Section 2: Architecture & Data Model

### Pattern

Every module follows the existing convention:

```
module_name/
  domain/         # Entities, value objects, enums
  application/    # Services, DTOs
  infrastructure/ # Repositories
  interfaces/api/ # REST Controllers
  package-info.java
```

### Employee Module — Extended Entities

```
Employee (extended)
├── position: Position (@ManyToOne, new)
├── email: String
├── phone: String
├── dateOfBirth: LocalDate
├── gender: Gender enum (MALE/FEMALE/OTHER)
├── nationalId: String          # CMND/CCCD
├── address: String
├── bankAccount: String
├── taxCode: String             # MST cá nhân

Position (new)
├── id, tenantId, code, title
└── department: Department

EmployeeContract (new)
├── id, tenantId, employee, contractType (FIXED/SEASONAL/PROBATION)
├── startDate, endDate?, salary: BigDecimal

EmployeeSkill (new)
├── id, tenantId, employee, skillName, proficiencyLevel (BEGINNER/INTERMEDIATE/ADVANCED/EXPERT)

EmergencyContact (new)
├── id, tenantId, employee, fullName, relationship, phone
```

### Attendance Module — Extended Entities

```
LeaveRequest (extended)
├── leaveType: LeaveType enum (ANNUAL/SICK/UNPAID/MATERNITY/PATERNITY)
└── approvedBy: UUID?

LeaveBalance (new)
├── id, tenantId, employeeId, leaveType, year
├── totalDays, usedDays, pendingDays

Holiday (new)
├── id, tenantId, name, date, description?, isRecurringYearly

OvertimeRecord (new)
├── id, tenantId, employeeId, date, hours, status (PENDING/APPROVED/REJECTED)
```

### Payroll Module — Extended Entities

```
SalaryStructure (new)
├── id, tenantId, employee, basicSalary, allowance, deduction
├── effectiveFrom, effectiveTo?

Payslip (new)
├── id, tenantId, payrollRun, employee
├── basicSalary, allowance, deduction, overtimePay, netPay, issuedAt
```

### Performance Module — New Entities

```
AppraisalCycle
├── id, tenantId, name, cycleType (Q1/H1/YEARLY)
├── startDate, endDate, status (DRAFT/ACTIVE/COMPLETED)

PerformanceReview
├── id, tenantId, cycle, employee
├── reviewerType (SELF/MANAGER), reviewerId: UUID?
├── overallScore: BigDecimal, strengths?, improvements?
├── status (DRAFT/SUBMITTED/REVIEWED/FINALIZED), submittedAt?

KPI
├── id, tenantId, employee, cycle
├── title, description, targetScore, actualScore?, weight
```

### Employee Self-Service — API Endpoints

```
GET    /api/self/profile
PUT    /api/self/profile
GET    /api/self/attendance
POST   /api/self/leave-requests
GET    /api/self/leave-balances
GET    /api/self/payslips
GET    /api/self/performance
```

---

## Section 3: Error Handling, Testing & Security

### Error Handling

Extend existing `ApiExceptionHandler` with:

- `BadRequestException` (400)
- `ForbiddenException` (403)
- `PayrollLockedException` (422)

Existing `NotFoundException` and `ConflictException` are unchanged.

### Testing

| Backend (IT) | Frontend (Vitest) |
|---|---|
| `PerformanceAdminApiIT`, `PerformanceCycleLifecycleIT` | `PerformancePage.test.tsx` |
| `EmployeeProfileIT` | `EmployeesPage.test.tsx` (extended) |
| `LeaveBalanceIT`, `OvertimeApprovalIT` | `LeavePage.test.tsx` (extended) |
| `PayrollPayslipIT`, `SalaryStructureIT` | `PayrollPage.test.tsx` (extended) |
| `EmployeeSelfServiceIT` | N/A (API-only routes) |
| `ModuleBoundariesTest` (extended) | |
| `DemoSeedDataIT` (extended) | |

### Security — Role Matrix

Roles: `ADMIN`, `HR_MANAGER`, `MANAGER`, `EMPLOYEE`

| Endpoint | ADMIN | HR_MANAGER | MANAGER | EMPLOYEE |
|----------|-------|-----------|---------|----------|
| `/api/admin/**` | CRUD | CRUD | — | — |
| `/api/employees/{id}` | Full | Full | Read (own dept) | — |
| `/api/self/**` | — | — | — | Read/Write (own) |
| `/api/performance/**` | CRUD | CRUD | Review (own dept) | Read (own) |

### Database Migrations

```
V11__extend_employee_table.sql
V12__create_position_contract_skill_emergency.sql
V13__create_leave_balance_holiday_overtime.sql
V14__extend_leave_request_attendance.sql
V15__create_salary_structure_payslip.sql
V16__create_performance_tables.sql
V17__seed_comprehensive_sample_data.sql
```

---

## Section 4: Frontend

Stack: React + Ant Design + TypeScript + Vite (unchanged).

### Navigation

```
Dashboard
─────────────
Nhân viên       (extended form + detail drawer with tabs)
Phòng ban
Tuyển dụng
Nghỉ phép       (extended: balances, holidays, overtime tabs)
Lương           (extended: payslip detail drawer)
Đánh giá        (NEW — PerformancePage)
─────────────
Cài đặt
```

### Page Changes

**EmployeesPage** — table adds email, phone, position, salary columns. Detail drawer adds tabs: Profile / Contracts / Skills / Emergency Contacts. Form adds all new fields.

**LeavePage** — adds leaveType + approvedBy columns. New tabs: Leave Balances, Holidays, Overtime.

**PayrollPage** — adds "View Payslip" action opening a detail drawer with salary breakdown.

**DashboardPage** — adds real stat widgets: headcount by department (bar chart), status distribution (pie chart), pending leave requests, monthly payroll summary.

**PerformancePage** (new) — 3 tabs: Appraisal Cycles, My Reviews, KPIs. Uses existing `AppTable` + `FormDrawer` pattern.

### Shared UI

`AppTable`, `FormDrawer`, `PageToolbar`, `StatusTag` — reused as-is, no changes.

---

## Section 5: Seed Data

### Departments — 14

Existing 14 departments kept as-is with Vietnamese names.

### Positions — 20 roles

DIR, MGR, DEPUTY, LEAD, SENIOR, STAFF, JUNIOR, INTERN, DEV, QA_ENG, BA, ACC, SALES_REP, CS_REP, HR_SPEC, DESIGNER, CONTENT, DATA_ENG, SEC_ENG, DRIVER

### Employees — ~120

Distributed across 14 departments, full profile with email, phone, DoB, gender, nationalId, address (Vietnamese provinces), bankAccount, taxCode, 1 contract, 2-5 skills each. Vietnamese names from all 3 regions.

### Attendance — ~60K records

2024-01-01 to 2026-06-04, one check-in per workday per employee. ~5% absence rate. Check-in times Gaussian around 07:30 ± 30 min.

### Leave Requests — ~250

- ANNUAL: 150 | SICK: 60 | UNPAID: 20 | MATERNITY: 8 | PATERNITY: 12
- Status: 60% APPROVED, 20% PENDING, 15% REJECTED, 5% CANCELLED

### Leave Balances — 2026 per employee

- ANNUAL: 12 days, used 4-8 days | SICK: 30 days, used 2-5 days

### Overtime — ~180 records

IT, FIN, OPS heavy. 2-4 hours each. 70% APPROVED.

### Salary Structures

Basic salary ranges: DIR 40-60M, MGR 25-40M, LEAD/SENIOR 18-28M, STAFF 10-20M, JUNIOR 7-10M, INTERN 3-5M. Allowance 5-15%. Deductions: BHXH 8%, BHYT 1.5%, BHTN 1%.

### Payroll Runs — 24 months (2024-2025)

Each month one COMPLETED run with 120 payslips each. Total ~2,880 payslips.

### Appraisal Cycles — 3

Q1-2026 (COMPLETED), H1-2026 (ACTIVE), 2025 Yearly (COMPLETED). Self + manager reviews per employee per cycle.

### KPIs — ~10 templates

Shared across cycles: project delivery (30%), work quality (25%), teamwork (15%), innovation (15%), compliance (15%). 3-5 KPIs per employee per cycle.

### Holidays — Vietnamese

Tết Dương lịch, Tết Nguyên đán, Giỗ Tổ Hùng Vương, 30/4, 1/5, 2/9. Recurring yearly where applicable.
