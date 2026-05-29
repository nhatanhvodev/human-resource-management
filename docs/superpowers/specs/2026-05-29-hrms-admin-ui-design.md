# HRMS Admin UI Design Spec

**Date:** 2026-05-29  
**Status:** Draft for implementation planning  
**Owner:** Codex + User

## 1. Goal

Build an internal HRMS admin web interface for daily operations, using:

- Frontend: React + Ant Design
- Backend: existing Spring Boot modular monolith, extended with missing admin APIs
- Auth mode for this phase: development mode (manual token + tenant input in UI), no login page

The first screen must be the working admin app (not a landing page).

## 2. Scope

### 2.1 In scope

1. New frontend app `web-admin/` in the current repository.
2. Admin layout with navigation, header, content area, and responsive behavior.
3. Dev settings screen to set:
   - `Authorization` bearer token
   - `X-Tenant-Id` header
4. Dashboard with summary cards and recent activity table.
5. Department management UI and APIs:
   - list/search/pagination
   - create
   - update
   - delete (with business rule validation)
6. Employee management UI and APIs:
   - list/search/filter/pagination
   - detail
   - create
   - update
   - status change (active/inactive)
7. Recruitment UI and APIs:
   - candidate list/create/update
   - job posting list/create/update
   - application list/create
   - convert application to employee
8. Leave UI and APIs:
   - leave request list/filter
   - create
   - approve
   - reject
9. Payroll UI and APIs:
   - payroll period list/detail/create
   - payroll run list by period
   - execute payroll run
   - close payroll period
10. Error/loading/empty states in UI for all primary screens.
11. Test coverage for backend integration/security and frontend smoke flows.

### 2.2 Out of scope

1. Production SSO/OIDC login screen and full auth flow.
2. Advanced analytics and BI-grade dashboards.
3. Multi-company onboarding wizard.
4. Mobile app.
5. Microservices decomposition.

## 3. Constraints and assumptions

1. Existing backend remains a modular monolith and keeps current module boundaries.
2. Existing security model remains active; this phase only changes how token/tenant are provided from UI.
3. Backend endpoints follow `/api/v1`.
4. Docker runtime dependencies remain PostgreSQL, Redis, RabbitMQ.
5. UI must be practical for operations (dense, scan-friendly, form/table first).

## 4. Architecture

## 4.1 Repository structure

```
/
  src/main/java/...            # existing Spring Boot backend
  src/test/java/...            # backend tests
  web-admin/                   # new React + Ant Design app
    src/
      app/
      features/
      shared/
```

## 4.2 Runtime architecture

- Backend API: `http://localhost:8080`
- Frontend dev server: `http://localhost:5173`
- Vite proxy forwards `/api` to `http://localhost:8080` in development.
- Frontend API client attaches:
  - `Authorization: Bearer <token>`
  - `X-Tenant-Id: <tenant>`

## 4.3 Frontend module design

1. `app/layout`
   - App shell, side nav, top bar, route frame.
2. `app/router`
   - Route definitions for dashboard and each module.
3. `features/dashboard`
   - Summary cards + activity table.
4. `features/departments`
   - Table, filters, create/edit/delete flows.
5. `features/employees`
   - Table + detail drawer/page, create/edit/status change.
6. `features/recruitment`
   - Candidate/job posting/application management, conversion action.
7. `features/leave`
   - Leave list/create/approve/reject flows.
8. `features/payroll`
   - Period list/create/close and run execution/history.
9. `features/settings`
   - Dev token + tenant settings.
10. `shared/api`
    - Axios instance, request/response interceptors, error mapping.
11. `shared/ui`
    - Reusable table wrapper, form helpers, status tags, confirm modal.

## 4.4 Backend extension design

Each module keeps controller/service/repository boundaries and adds only missing admin endpoints.

- Organization module: department list/update/delete support.
- Employee module: list pagination/filter, update, status patch.
- Recruitment module: list/update endpoints for candidate/job posting/application.
- Attendance module: leave list + reject endpoint.
- Payroll module: period list/detail and run list endpoints.
- Reporting/integration: optional source for dashboard activities (minimal first pass allowed).

## 5. API contract design

## 5.1 Standard list response

All list endpoints return:

```json
{
  "items": [],
  "page": 0,
  "size": 20,
  "totalItems": 0,
  "totalPages": 0
}
```

## 5.2 Standard list query

- `page` (0-based)
- `size`
- `sort=field,asc|desc`
- `q` (keyword)

Module-specific filters can be added (for example `status`, `departmentId`, `periodId`).

## 5.3 Endpoint additions

### Department

- `GET /api/v1/departments`
- `PUT /api/v1/departments/{id}`
- `DELETE /api/v1/departments/{id}`
- Keep: `POST /api/v1/departments`

### Employee

- Extend: `GET /api/v1/employees` (pagination/filter)
- `PUT /api/v1/employees/{id}`
- `PATCH /api/v1/employees/{id}/status`
- Keep: `GET /api/v1/employees/{id}`, `POST /api/v1/employees`

### Recruitment

- `GET /api/v1/candidates`, `PUT /api/v1/candidates/{id}`
- `GET /api/v1/job-postings`, `PUT /api/v1/job-postings/{id}`
- `GET /api/v1/applications` (filter by candidate/job/status)
- Keep existing create + convert endpoints

### Leave

- `GET /api/v1/leave-requests`
- `POST /api/v1/leave-requests/{id}/reject`
- Keep existing create + approve endpoints

### Payroll

- `GET /api/v1/payroll-periods`
- `GET /api/v1/payroll-periods/{id}`
- `GET /api/v1/payroll-runs?periodId=...`
- Keep existing create/execute/close endpoints

### Dashboard

- `GET /api/v1/dashboard/summary`
- `GET /api/v1/dashboard/activities`

## 5.4 Error model

Reuse current `ApiError` structure and ensure:

1. Validation errors are field-mapped for form display.
2. Business rule errors are explicit (example: cannot delete department with active employees).
3. Unauthorized/forbidden states are distinct for UI handling (`401` vs `403`).

## 6. UX and interaction design

1. Admin-first layout, no marketing screen.
2. Ant Design data-heavy patterns:
   - tables with fixed columns where needed
   - compact forms
   - modal or drawer for create/edit flows
3. Stable dimensions for toolbars, filter bars, and tables to avoid layout jumps.
4. Explicit loading and empty states.
5. Confirm dialogs for destructive actions.
6. Consistent status badges for:
   - employee status
   - leave status
   - payroll period/run status
7. Keyboard-friendly forms and clear validation messages.

## 7. Security and tenant behavior

1. No login page in this phase.
2. Dev settings store token and tenant locally on the browser.
3. All protected API calls use token + tenant headers.
4. If token missing or invalid:
   - show actionable error in UI
   - do not crash route
5. Actuator remains backend-controlled; UI only uses allowed endpoints for connectivity checks.

## 8. Testing strategy

## 8.1 Backend tests

1. Integration tests for every new endpoint group.
2. Security tests:
   - no token -> `401`
   - missing authority -> `403`
3. Business rule tests:
   - block department delete when linked employees exist
   - payroll/leave state transition guards
4. Pagination/filter contract tests.

## 8.2 Frontend tests

1. API client tests for header injection and error mapping.
2. Component tests for key forms and tables.
3. Smoke E2E flow:
   - set dev token/tenant
   - create department
   - create employee
   - create leave request and approve
   - create payroll period, execute run, close period

## 8.3 Regression checks

1. Keep existing backend tests green.
2. Add minimum route smoke checks for all new UI sections.

## 9. Delivery phases

1. **Phase A:** `web-admin` skeleton, layout, routing, dev settings, static dashboard shell.
2. **Phase B:** Department + Employee end to end (API + UI + tests).
3. **Phase C:** Recruitment + Leave end to end.
4. **Phase D:** Payroll + Dashboard aggregates.
5. **Phase E:** Hardening (error UX, empty/loading states, security checks, smoke E2E).

## 10. Risks and mitigations

1. **Risk:** inconsistent list APIs across modules.  
   **Mitigation:** enforce one shared pagination response contract.
2. **Risk:** authority mismatch on new endpoints.  
   **Mitigation:** endpoint-level security tests and permission matrix review.
3. **Risk:** incomplete state machine for leave/payroll actions.  
   **Mitigation:** explicit transition rules and test coverage before UI wiring.
4. **Risk:** dev token mode accidentally treated as production auth.  
   **Mitigation:** isolate in settings module and keep behind development profile behavior in docs.

## 11. Acceptance criteria

1. Admin UI runs locally at `http://localhost:5173` and operates against backend API.
2. Core modules (department, employee, recruitment, leave, payroll) are manageable from UI.
3. Backend provides required list/filter/update/delete endpoints with consistent contracts.
4. Errors are understandable in UI and mapped from backend responses.
5. Backend tests and frontend smoke tests pass for defined scope.

## 12. Open decisions for later phases

1. Move from dev token mode to full OIDC login UX.
2. Add advanced dashboards and export-heavy reporting screens.
3. Define production hardening details for token storage and session behavior.
