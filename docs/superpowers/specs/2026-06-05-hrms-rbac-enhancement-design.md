# HRMS RBAC Enhancement Design

**Date:** 2026-06-05
**Status:** Approved
**Scope:** RBAC authorization system enhancement across short-term, mid-term, and long-term horizons

---

## Context

The project has a working RBAC system (multi-tenant, 44 permissions, 3 roles: ADMIN/HR_MANAGER/EMPLOYEE) with `@PreAuthorize` on backend controllers and `RequireAuthority` on frontend routes. This design covers 9 items across 3 timeframes to bring it from functional to enterprise-ready.

---

## Short-Term: Complete What Exists

### 1. Expand `useRole.ts` to support all roles

**File:** `web-admin/src/shared/auth/useRole.ts`

- Change type from `Role = "ADMIN" | "EMPLOYEE"` to `Role = "ADMIN" | "HR_MANAGER" | "LINE_MANAGER" | "EMPLOYEE"`
- Resolution priority: ADMIN → HR_MANAGER → LINE_MANAGER → EMPLOYEE (fallback)
- Walk `payload.roles[]` array; return first match

### 2. Role-based routing with `RoleShell`

**New file:** `web-admin/src/app/layout/RoleShell.tsx`
**New file:** `web-admin/src/app/layout/ManagerShell.tsx`

- `<RoleShell>` reads `useRole()` and renders:
  - `ADMIN | HR_MANAGER` → `<AdminShell />`
  - `LINE_MANAGER` → `<ManagerShell />`
  - `EMPLOYEE` → `<EmployeeShell />`
- Router root element changes from `<AdminShell />` to `<RoleShell />`

**ManagerShell:** A lightweight admin shell with nav items limited to:
dashboard, my-team (employee:read), leave, attendance, documents, training, announcements

### 3. Add `employee:delete` permission

**Migration V28:**
- Insert `('employee:delete', 'employee', 'delete', 'Delete employees')` into `security_permission`
- Grant to ADMIN role
- Grant to HR_MANAGER role
- Add `@PreAuthorize("hasAuthority('employee:delete')")` on new DELETE endpoint in `EmployeeController`

### 4. Add LINE_MANAGER role

**Migration V28 (same as above):**
- Insert LINE_MANAGER role: `('c1000000-0000-4000-8000-000000000004', 'default', 'LINE_MANAGER', 'Line Manager', 'Team manager with limited access', true, now(), now())`
- Grant permissions: `dashboard:read`, `employee:read`, `department:read`, `leave:read`, `leave:approve`, `attendance:read`, `attendance:approve`, `self:access`, `document:read`, `announcement:read`, `training:read`

### 5. AuthorizationPage enhancements

**File:** `web-admin/src/features/authorization/AuthorizationPage.tsx`

- Tab "Roles": Add "New Role" button → modal with code, name, description, optional copy-from-template dropdown
- Tab "Roles": Add delete button for non-system roles (confirm modal)
- Tab "Users": Add enable/disable toggle per user
- Tab "Roles": Disable editing system_role code; show system_role badge
- Tab "Users": Show "Add User" modal (username, displayName, employeeId lookup, initial roles)

**Backend additions to `AuthorizationController`:**
- `POST /authz/roles` — create custom role
- `DELETE /authz/roles/{roleId}` — delete custom role (reject if system_role)
- `POST /authz/users` — create user
- `PUT /authz/users/{userId}/enabled` — toggle user enabled

---

## Mid-Term: Data-Level Security

### 6. Department-scoped access

**Migration V29:**

```sql
create table if not exists security_role_scope (
  id uuid primary key,
  user_id uuid not null references app_user(id) on delete cascade,
  department_id uuid not null references department(id) on delete cascade,
  unique (user_id, department_id)
);
```

- `RbacAuthorityService.currentAccess()` returns additional field `scopedDepartmentIds: List<UUID>`
- Service methods check department scope before returning data
- `AuthorizationController` gets new endpoint: `PUT /authz/users/{userId}/scopes` to manage department scopes

### 7. Manager-subordinate relationship

**Migration V29 (same as above):**
```sql
alter table employee add column if not exists manager_id uuid references employee(id);
```

- `EmployeeService` gets `assignManager(employeeId, managerId)` method
- `LeaveService.approve()` and `TimeTrackingService.approve()` verify: approver is manager of employee OR employee is in approver's department scope
- `EmployeeController` gets `PUT /employees/{id}/manager` endpoint

**UI additions:**
- Employee detail shows manager field with employee picker
- AuthorizationPage "Scopes" tab to manage department scopes per user

---

## Long-Term: Enterprise-Ready

### 8. RBAC audit trail

**Migration V30:**

```sql
create table if not exists security_audit_log (
  id uuid primary key,
  tenant_id varchar(64) not null,
  actor_id uuid not null,
  action varchar(50) not null,
  target_type varchar(50) not null,
  target_id uuid,
  detail jsonb,
  created_at timestamp with time zone not null default now()
);
```

- `RbacAuthorityService` writes audit events on every mutation (role permission change, user role change, role create/delete, user enable/disable)
- `AuthorizationController` gets `GET /authz/audit?page&size` endpoint
- AuthorizationPage "Audit" tab shows paginated audit log table

### 9. IdP group-to-role mapping

**Migration V31:**

```sql
create table if not exists security_idp_mapping (
  id uuid primary key,
  tenant_id varchar(64) not null,
  idp_group varchar(255) not null,
  role_id uuid not null references security_role(id) on delete cascade,
  unique (tenant_id, idp_group, role_id)
);
```

- `RbacAuthorityService` loads IdP mappings for tenant
- `jwtAuthenticationConverter` merges SSO-group-mapped roles with manual role assignments (union)
- `AuthorizationController` gets CRUD endpoints for IdP mappings

### 10. Custom role builder (tenant self-service)

- Role creation with copy-from-template (already in short-term #5)
- Tenant can create/edit/delete roles with `system_role = false`
- Permission set is platform-defined (global), roles are tenant-organized
- Validation: unique code per tenant, cannot delete system roles, cannot remove system_role flag

---

## Migration Sequence

| # | Migration | Content |
|---|-----------|---------|
| V28 | Short-term | `employee:delete` permission, LINE_MANAGER role + permissions |
| V29 | Mid-term | `security_role_scope` table, `employee.manager_id` column |
| V30 | Long-term | `security_audit_log` table |
| V31 | Long-term | `security_idp_mapping` table |

---

## Files Changed Summary

### Backend (Java)
- `src/main/resources/db/migration/V28__short_term_rbac.sql` — NEW
- `src/main/resources/db/migration/V29__mid_term_rbac.sql` — NEW
- `src/main/resources/db/migration/V30__audit_trail.sql` — NEW
- `src/main/resources/db/migration/V31__idp_mapping.sql` — NEW
- `src/main/java/com/company/hrms/shared/security/RbacAuthorityService.java` — modify
- `src/main/java/com/company/hrms/shared/security/SecurityConfig.java` — modify
- `src/main/java/com/company/hrms/shared/security/AuthorizationController.java` — modify
- `src/main/java/com/company/hrms/employee/interfaces/api/EmployeeController.java` — modify
- `src/main/java/com/company/hrms/employee/application/EmployeeService.java` — modify
- `src/main/java/com/company/hrms/leave/application/LeaveService.java` — modify (if exists)
- `src/main/java/com/company/hrms/attendance/application/TimeTrackingService.java` — modify

### Frontend (TypeScript/React)
- `web-admin/src/shared/auth/useRole.ts` — modify
- `web-admin/src/shared/auth/jwt.ts` — modify (if needed)
- `web-admin/src/app/layout/RoleShell.tsx` — NEW
- `web-admin/src/app/layout/ManagerShell.tsx` — NEW
- `web-admin/src/app/router.tsx` — modify
- `web-admin/src/features/authorization/AuthorizationPage.tsx` — modify
- `web-admin/src/features/employees/EmployeesPage.tsx` — modify (manager column)

---

## Edge Cases & Constraints

- **System role immutability:** system_role=true roles cannot be deleted, their code cannot be changed
- **Admin always full-access:** ADMIN role always gets all permissions, enforced at both DB seed and role editing
- **Cross-tenant isolation:** All queries include `tenant_id`; role/permission data is tenant-scoped
- **LINE_MANAGER vs HR_MANAGER:** LINE_MANAGER cannot access payroll, recruitment, audit, authz, or modify employees
- **Department scope with no scope = all access:** null/empty scopedDepartmentIds means no restriction (for ADMIN, HR_MANAGER)
- **Manager check fallback:** approve permission falls through: direct manager → department scope → deny
