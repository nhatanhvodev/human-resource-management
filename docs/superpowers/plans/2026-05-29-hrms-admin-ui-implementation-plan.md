# HRMS Admin UI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a working HRMS admin application (`web-admin`) with React + Ant Design and extend the Spring Boot backend APIs so HR operations can be managed from UI end-to-end.

**Architecture:** Keep the current modular monolith backend and add missing admin endpoints per module. Add a separate Vite frontend app (`web-admin`) in the same repository, using a shared API client that injects `Authorization` and `X-Tenant-Id`. Implement module-by-module with TDD, starting backend contracts before UI integration.

**Tech Stack:** Java 21, Spring Boot 4, Spring Security, Spring Data JPA, Maven Surefire, React 18, Vite, TypeScript, Ant Design, Axios, Vitest, React Testing Library, Playwright.

---

## File Structure Map

### Backend (modify/create)

- Modify: `src/main/java/com/company/hrms/shared/exception/ApiError.java`
- Modify: `src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java`
- Create: `src/main/java/com/company/hrms/shared/exception/NotFoundException.java`
- Create: `src/main/java/com/company/hrms/shared/interfaces/api/PageResponse.java`
- Modify: `src/main/java/com/company/hrms/organization/domain/Department.java`
- Modify: `src/main/java/com/company/hrms/organization/infrastructure/DepartmentRepository.java`
- Modify: `src/main/java/com/company/hrms/organization/application/DepartmentService.java`
- Modify: `src/main/java/com/company/hrms/organization/interfaces/api/DepartmentController.java`
- Modify: `src/main/java/com/company/hrms/employee/domain/Employee.java`
- Modify: `src/main/java/com/company/hrms/employee/infrastructure/EmployeeRepository.java`
- Modify: `src/main/java/com/company/hrms/employee/application/EmployeeService.java`
- Modify: `src/main/java/com/company/hrms/employee/interfaces/api/EmployeeController.java`
- Modify: `src/main/java/com/company/hrms/recruitment/domain/Candidate.java`
- Modify: `src/main/java/com/company/hrms/recruitment/domain/JobPosting.java`
- Modify: `src/main/java/com/company/hrms/recruitment/infrastructure/CandidateRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/infrastructure/JobPostingRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/infrastructure/RecruitmentApplicationRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/application/RecruitmentService.java`
- Modify: `src/main/java/com/company/hrms/recruitment/interfaces/api/RecruitmentController.java`
- Modify: `src/main/java/com/company/hrms/attendance/domain/LeaveRequest.java`
- Modify: `src/main/java/com/company/hrms/attendance/infrastructure/LeaveRequestRepository.java`
- Modify: `src/main/java/com/company/hrms/attendance/application/AttendanceService.java`
- Modify: `src/main/java/com/company/hrms/attendance/interfaces/api/AttendanceController.java`
- Modify: `src/main/java/com/company/hrms/payroll/infrastructure/PayrollPeriodRepository.java`
- Modify: `src/main/java/com/company/hrms/payroll/infrastructure/PayrollRunRepository.java`
- Modify: `src/main/java/com/company/hrms/payroll/application/PayrollService.java`
- Modify: `src/main/java/com/company/hrms/payroll/interfaces/api/PayrollController.java`
- Create: `src/main/java/com/company/hrms/reporting/interfaces/api/DashboardController.java`
- Create: `src/main/java/com/company/hrms/reporting/application/DashboardQueryService.java`

### Backend tests (create/modify)

- Create: `src/test/java/com/company/hrms/organization/DepartmentAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/employee/EmployeeAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/recruitment/RecruitmentAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/attendance/LeaveAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/payroll/PayrollAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/reporting/DashboardApiIT.java`

### Frontend (create)

- Create: `web-admin/package.json`
- Create: `web-admin/tsconfig.json`
- Create: `web-admin/tsconfig.node.json`
- Create: `web-admin/vite.config.ts`
- Create: `web-admin/index.html`
- Create: `web-admin/src/main.tsx`
- Create: `web-admin/src/app/router.tsx`
- Create: `web-admin/src/app/layout/AppShell.tsx`
- Create: `web-admin/src/app/styles.css`
- Create: `web-admin/src/shared/api/client.ts`
- Create: `web-admin/src/shared/api/types.ts`
- Create: `web-admin/src/shared/config/devSettingsStore.ts`
- Create: `web-admin/src/features/settings/DevSettingsPage.tsx`
- Create: `web-admin/src/features/dashboard/DashboardPage.tsx`
- Create: `web-admin/src/features/departments/DepartmentsPage.tsx`
- Create: `web-admin/src/features/employees/EmployeesPage.tsx`
- Create: `web-admin/src/features/recruitment/RecruitmentPage.tsx`
- Create: `web-admin/src/features/leave/LeavePage.tsx`
- Create: `web-admin/src/features/payroll/PayrollPage.tsx`
- Create: `web-admin/src/shared/api/client.test.ts`
- Create: `web-admin/src/features/settings/DevSettingsPage.test.tsx`
- Create: `web-admin/src/features/departments/DepartmentsPage.test.tsx`
- Create: `web-admin/src/features/employees/EmployeesPage.test.tsx`
- Create: `web-admin/vitest.config.ts`
- Create: `web-admin/src/test/setup.ts`
- Create: `web-admin/playwright.config.ts`
- Create: `web-admin/e2e/admin-smoke.spec.ts`

### Ops/docs (modify)

- Modify: `.gitignore`
- Modify: `README.md`

---

### Task 1: Add Shared API Contracts and Error Mapping (Backend Foundation)

**Files:**
- Create: `src/main/java/com/company/hrms/shared/exception/NotFoundException.java`
- Modify: `src/main/java/com/company/hrms/shared/exception/ApiError.java`
- Modify: `src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java`
- Create: `src/main/java/com/company/hrms/shared/interfaces/api/PageResponse.java`
- Test: `src/test/java/com/company/hrms/organization/DepartmentAdminApiIT.java`

- [ ] **Step 1: Write the failing test**

```java
@Test
void returnsNotFoundWhenDepartmentMissing() throws Exception {
    mvc.perform(get("/api/v1/departments/{id}", UUID.randomUUID())
            .header("X-Tenant-Id", "tenant-a")
            .with(jwt().authorities(new SimpleGrantedAuthority("department:read"))))
        .andExpect(status().isNotFound())
        .andExpect(jsonPath("$.code").value("NOT_FOUND"));
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=DepartmentAdminApiIT test`  
Expected: FAIL with `404` assertion mismatch or missing endpoint.

- [ ] **Step 3: Write minimal implementation**

```java
// src/main/java/com/company/hrms/shared/exception/NotFoundException.java
package com.company.hrms.shared.exception;

public class NotFoundException extends RuntimeException {
    public NotFoundException(String message) {
        super(message);
    }
}
```

```java
// src/main/java/com/company/hrms/shared/exception/ApiError.java
package com.company.hrms.shared.exception;

import java.time.Instant;
import java.util.Map;

public record ApiError(String code, String message, Instant timestamp, Map<String, String> fieldErrors) {
}
```

```java
// src/main/java/com/company/hrms/shared/interfaces/api/PageResponse.java
package com.company.hrms.shared.interfaces.api;

import org.springframework.data.domain.Page;

import java.util.List;

public record PageResponse<T>(List<T> items, int page, int size, long totalItems, int totalPages) {
    public static <T> PageResponse<T> from(Page<T> page) {
        return new PageResponse<>(page.getContent(), page.getNumber(), page.getSize(), page.getTotalElements(), page.getTotalPages());
    }
}
```

```java
// add handlers in ApiExceptionHandler
@ExceptionHandler(NotFoundException.class)
ResponseEntity<ApiError> handleNotFound(NotFoundException ex) {
    return ResponseEntity.status(HttpStatus.NOT_FOUND)
        .body(new ApiError("NOT_FOUND", ex.getMessage(), Instant.now(), Map.of()));
}

@ExceptionHandler(IllegalArgumentException.class)
ResponseEntity<ApiError> handleBadRequest(IllegalArgumentException ex) {
    return ResponseEntity.badRequest()
        .body(new ApiError("BAD_REQUEST", ex.getMessage(), Instant.now(), Map.of()));
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=DepartmentAdminApiIT test`  
Expected: PASS for the added not-found assertion.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/shared/exception src/main/java/com/company/hrms/shared/interfaces/api src/test/java/com/company/hrms/organization/DepartmentAdminApiIT.java
git commit -m "feat: add shared api error and pagination response contracts"
```

### Task 2: Implement Department Admin APIs (List/Get/Update/Delete)

**Files:**
- Modify: `src/main/java/com/company/hrms/organization/domain/Department.java`
- Modify: `src/main/java/com/company/hrms/organization/infrastructure/DepartmentRepository.java`
- Modify: `src/main/java/com/company/hrms/organization/application/DepartmentService.java`
- Modify: `src/main/java/com/company/hrms/organization/interfaces/api/DepartmentController.java`
- Create: `src/test/java/com/company/hrms/organization/DepartmentAdminApiIT.java`

- [ ] **Step 1: Write the failing test**

```java
@Test
void listsDepartmentsWithPaginationAndKeyword() throws Exception {
    mvc.perform(get("/api/v1/departments")
            .param("page", "0")
            .param("size", "10")
            .param("q", "Eng")
            .header("X-Tenant-Id", "tenant-a")
            .with(jwt().authorities(new SimpleGrantedAuthority("department:read"))))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.items").isArray())
        .andExpect(jsonPath("$.page").value(0));
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=DepartmentAdminApiIT test`  
Expected: FAIL because `GET /api/v1/departments` is not implemented.

- [ ] **Step 3: Write minimal implementation**

```java
// Department.java
public void update(String code, String name) {
    this.code = code;
    this.name = name;
}
```

```java
// DepartmentRepository.java
Page<Department> findByTenantIdAndNameContainingIgnoreCaseOrTenantIdAndCodeContainingIgnoreCase(
    String tenantIdForName, String nameKeyword, String tenantIdForCode, String codeKeyword, Pageable pageable);

Page<Department> findAllByTenantId(String tenantId, Pageable pageable);
Optional<Department> findByTenantIdAndCode(String tenantId, String code);
```

```java
// DepartmentService.java
@Transactional(readOnly = true)
public Page<Department> list(String keyword, Pageable pageable) {
    String tenantId = TenantContext.get();
    if (keyword == null || keyword.isBlank()) {
        return departmentRepository.findAllByTenantId(tenantId, pageable);
    }
    String q = keyword.trim();
    return departmentRepository.findByTenantIdAndNameContainingIgnoreCaseOrTenantIdAndCodeContainingIgnoreCase(
        tenantId, q, tenantId, q, pageable
    );
}

@Transactional(readOnly = true)
public Department getById(UUID id) {
    return departmentRepository.findByIdAndTenantId(id, TenantContext.get())
        .orElseThrow(() -> new NotFoundException("DEPARTMENT_NOT_FOUND"));
}

@Transactional
public Department update(UUID id, String code, String name) {
    Department department = getById(id);
    departmentRepository.findByTenantIdAndCode(TenantContext.get(), code)
        .filter(existing -> !existing.getId().equals(id))
        .ifPresent(existing -> { throw new ConflictException("DEPARTMENT_CODE_EXISTS"); });
    department.update(code, name);
    return department;
}

@Transactional
public void delete(UUID id) {
    Department department = getById(id);
    if (employeeRepository.existsByTenantIdAndDepartmentId(TenantContext.get(), id)) {
        throw new ConflictException("DEPARTMENT_IN_USE");
    }
    departmentRepository.delete(department);
}
```

```java
// DepartmentController.java
@GetMapping
@PreAuthorize("hasAuthority('department:read')")
public PageResponse<DepartmentResponse> list(@RequestParam(required = false) String q, Pageable pageable) {
    return PageResponse.from(
        departmentService.list(q, pageable)
            .map(d -> new DepartmentResponse(d.getId(), d.getCode(), d.getName()))
    );
}

@GetMapping("/{id}")
@PreAuthorize("hasAuthority('department:read')")
public DepartmentResponse getById(@PathVariable UUID id) {
    Department d = departmentService.getById(id);
    return new DepartmentResponse(d.getId(), d.getCode(), d.getName());
}

@PutMapping("/{id}")
@PreAuthorize("hasAuthority('department:update')")
public DepartmentResponse update(@PathVariable UUID id, @RequestBody CreateDepartmentRequest request) {
    Department d = departmentService.update(id, request.code(), request.name());
    return new DepartmentResponse(d.getId(), d.getCode(), d.getName());
}

@DeleteMapping("/{id}")
@PreAuthorize("hasAuthority('department:delete')")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void delete(@PathVariable UUID id) {
    departmentService.delete(id);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=DepartmentAdminApiIT test`  
Expected: PASS for create/list/get/update/delete cases.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/organization src/test/java/com/company/hrms/organization/DepartmentAdminApiIT.java
git commit -m "feat: add department admin list and mutation endpoints"
```

### Task 3: Implement Employee Admin APIs (Pagination/Filter/Update/Status)

**Files:**
- Modify: `src/main/java/com/company/hrms/employee/domain/Employee.java`
- Modify: `src/main/java/com/company/hrms/employee/infrastructure/EmployeeRepository.java`
- Modify: `src/main/java/com/company/hrms/employee/application/EmployeeService.java`
- Modify: `src/main/java/com/company/hrms/employee/interfaces/api/EmployeeController.java`
- Create: `src/test/java/com/company/hrms/employee/EmployeeAdminApiIT.java`

- [ ] **Step 1: Write the failing test**

```java
@Test
void updatesEmployeeStatus() throws Exception {
    mvc.perform(patch("/api/v1/employees/{id}/status", employeeId)
            .header("X-Tenant-Id", "tenant-a")
            .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
            .contentType("application/json")
            .content("{\"employmentStatus\":\"INACTIVE\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.employmentStatus").value("INACTIVE"));
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=EmployeeAdminApiIT test`  
Expected: FAIL because status patch endpoint is missing.

- [ ] **Step 3: Write minimal implementation**

```java
// Employee.java
public void updateProfile(String fullName, Department department, LocalDate hireDate) {
    this.fullName = fullName;
    this.department = department;
    this.hireDate = hireDate;
}

public void changeStatus(EmploymentStatus status) {
    this.employmentStatus = status;
}
```

```java
// EmployeeRepository.java
Page<Employee> findAllByTenantId(String tenantId, Pageable pageable);
Page<Employee> findByTenantIdAndEmploymentStatus(String tenantId, EmploymentStatus status, Pageable pageable);
Page<Employee> findByTenantIdAndFullNameContainingIgnoreCase(String tenantId, String name, Pageable pageable);
```

```java
// EmployeeController.java
@GetMapping
@PreAuthorize("hasAuthority('employee:read')")
public PageResponse<EmployeeResponse> list(@RequestParam(required = false) String q,
                                           @RequestParam(required = false) String status,
                                           Pageable pageable) {
    return PageResponse.from(
        employeeService.list(q, status, pageable)
            .map(EmployeeController::toResponse)
    );
}

@PutMapping("/{id}")
@PreAuthorize("hasAuthority('employee:update')")
public EmployeeResponse update(@PathVariable UUID id, @RequestBody UpdateEmployeeRequest request) {
    return toResponse(employeeService.update(
        id,
        request.fullName(),
        request.departmentId(),
        request.hireDate()
    ));
}

@PatchMapping("/{id}/status")
@PreAuthorize("hasAuthority('employee:update')")
public EmployeeResponse patchStatus(@PathVariable UUID id, @RequestBody UpdateStatusRequest request) {
    return toResponse(employeeService.changeStatus(id, request.employmentStatus()));
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=EmployeeAdminApiIT test`  
Expected: PASS for list/filter/update/status scenarios.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/employee src/test/java/com/company/hrms/employee/EmployeeAdminApiIT.java
git commit -m "feat: add employee admin query and update endpoints"
```

### Task 4: Implement Recruitment Admin APIs (List + Update + Convert Flow Safety)

**Files:**
- Modify: `src/main/java/com/company/hrms/recruitment/domain/Candidate.java`
- Modify: `src/main/java/com/company/hrms/recruitment/domain/JobPosting.java`
- Modify: `src/main/java/com/company/hrms/recruitment/infrastructure/CandidateRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/infrastructure/JobPostingRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/infrastructure/RecruitmentApplicationRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/application/RecruitmentService.java`
- Modify: `src/main/java/com/company/hrms/recruitment/interfaces/api/RecruitmentController.java`
- Create: `src/test/java/com/company/hrms/recruitment/RecruitmentAdminApiIT.java`

- [ ] **Step 1: Write the failing test**

```java
@Test
void listsApplicationsByStatus() throws Exception {
    mvc.perform(get("/api/v1/applications")
            .param("status", "OFFER_ACCEPTED")
            .header("X-Tenant-Id", "tenant-r")
            .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:read"))))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.items").isArray());
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=RecruitmentAdminApiIT test`  
Expected: FAIL because list endpoints are missing.

- [ ] **Step 3: Write minimal implementation**

```java
// CandidateRepository.java
Page<Candidate> findAllByTenantId(String tenantId, Pageable pageable);

// JobPostingRepository.java
Page<JobPosting> findAllByTenantId(String tenantId, Pageable pageable);

// RecruitmentApplicationRepository.java
Page<RecruitmentApplication> findAllByTenantId(String tenantId, Pageable pageable);
Page<RecruitmentApplication> findByTenantIdAndStatus(String tenantId, ApplicationStatus status, Pageable pageable);
```

```java
// RecruitmentController.java additions
@GetMapping("/candidates")
@PreAuthorize("hasAuthority('recruitment:read')")
public PageResponse<CandidateResponse> listCandidates(Pageable pageable) {
    return PageResponse.from(recruitmentService.listCandidates(pageable)
        .map(c -> new CandidateResponse(c.getId(), c.getFullName())));
}

@PutMapping("/candidates/{id}")
@PreAuthorize("hasAuthority('recruitment:update')")
public CandidateResponse updateCandidate(@PathVariable UUID id, @RequestBody CreateCandidateRequest request) {
    Candidate candidate = recruitmentService.updateCandidate(id, request.fullName());
    return new CandidateResponse(candidate.getId(), candidate.getFullName());
}

@GetMapping("/job-postings")
@PreAuthorize("hasAuthority('recruitment:read')")
public PageResponse<JobPostingResponse> listJobPostings(Pageable pageable) {
    return PageResponse.from(recruitmentService.listJobPostings(pageable)
        .map(p -> new JobPostingResponse(p.getId(), p.getTitle())));
}

@PutMapping("/job-postings/{id}")
@PreAuthorize("hasAuthority('recruitment:update')")
public JobPostingResponse updateJobPosting(@PathVariable UUID id, @RequestBody CreateJobPostingRequest request) {
    JobPosting posting = recruitmentService.updateJobPosting(id, request.title());
    return new JobPostingResponse(posting.getId(), posting.getTitle());
}

@GetMapping("/applications")
@PreAuthorize("hasAuthority('recruitment:read')")
public PageResponse<ApplicationResponse> listApplications(@RequestParam(required = false) String status, Pageable pageable) {
    return PageResponse.from(recruitmentService.listApplications(status, pageable)
        .map(a -> new ApplicationResponse(a.getId(), a.getStatus().name())));
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=RecruitmentAdminApiIT test`  
Expected: PASS for list/filter/update and existing convert flow remains green.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/recruitment src/test/java/com/company/hrms/recruitment/RecruitmentAdminApiIT.java
git commit -m "feat: add recruitment admin listing and update endpoints"
```

### Task 5: Implement Leave and Payroll Admin Query APIs

**Files:**
- Modify: `src/main/java/com/company/hrms/attendance/domain/LeaveRequest.java`
- Modify: `src/main/java/com/company/hrms/attendance/infrastructure/LeaveRequestRepository.java`
- Modify: `src/main/java/com/company/hrms/attendance/application/AttendanceService.java`
- Modify: `src/main/java/com/company/hrms/attendance/interfaces/api/AttendanceController.java`
- Modify: `src/main/java/com/company/hrms/payroll/infrastructure/PayrollPeriodRepository.java`
- Modify: `src/main/java/com/company/hrms/payroll/infrastructure/PayrollRunRepository.java`
- Modify: `src/main/java/com/company/hrms/payroll/application/PayrollService.java`
- Modify: `src/main/java/com/company/hrms/payroll/interfaces/api/PayrollController.java`
- Create: `src/test/java/com/company/hrms/attendance/LeaveAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/payroll/PayrollAdminApiIT.java`

- [ ] **Step 1: Write the failing tests**

```java
@Test
void rejectsLeaveRequest() throws Exception {
    mvc.perform(post("/api/v1/leave-requests/{id}/reject", leaveId)
            .header("X-Tenant-Id", "tenant-att")
            .with(jwt().authorities(new SimpleGrantedAuthority("leave:approve"))))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.status").value("REJECTED"));
}
```

```java
@Test
void listsPayrollRunsByPeriod() throws Exception {
    mvc.perform(get("/api/v1/payroll-runs")
            .param("periodId", periodId.toString())
            .header("X-Tenant-Id", "tenant-pay")
            .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.items").isArray());
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=LeaveAdminApiIT,PayrollAdminApiIT test`  
Expected: FAIL because reject/list endpoints do not exist.

- [ ] **Step 3: Write minimal implementation**

```java
// AttendanceService.java
@Transactional
public LeaveRequest reject(UUID leaveId) {
    LeaveRequest leaveRequest = findByIdScoped(leaveId);
    leaveRequest.reject();
    return leaveRequest;
}

private LeaveRequest findByIdScoped(UUID leaveId) {
    return leaveRequestRepository.findByIdAndTenantId(leaveId, TenantContext.get())
        .orElseThrow(() -> new NotFoundException("LEAVE_NOT_FOUND"));
}

@Transactional(readOnly = true)
public Page<LeaveRequest> list(String status, Pageable pageable) {
    String tenantId = TenantContext.get();
    if (status == null || status.isBlank()) {
        return leaveRequestRepository.findAllByTenantId(tenantId, pageable);
    }
    return leaveRequestRepository.findByTenantIdAndStatus(tenantId, LeaveStatus.valueOf(status), pageable);
}
```

```java
// PayrollController.java additions
@GetMapping("/payroll-periods")
@PreAuthorize("hasAuthority('payroll:read')")
public PageResponse<PayrollPeriodResponse> listPeriods(Pageable pageable) {
    return PageResponse.from(payrollService.listPeriods(pageable)
        .map(period -> new PayrollPeriodResponse(period.getId(), period.getStatus().name())));
}

@GetMapping("/payroll-runs")
@PreAuthorize("hasAuthority('payroll:read')")
public PageResponse<PayrollRunResponse> listRuns(@RequestParam UUID periodId, Pageable pageable) {
    return PageResponse.from(payrollService.listRuns(periodId, pageable)
        .map(run -> new PayrollRunResponse(run.getId())));
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=LeaveAdminApiIT,PayrollAdminApiIT test`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/attendance src/main/java/com/company/hrms/payroll src/test/java/com/company/hrms/attendance/LeaveAdminApiIT.java src/test/java/com/company/hrms/payroll/PayrollAdminApiIT.java
git commit -m "feat: add leave rejection and payroll query endpoints"
```

### Task 6: Implement Dashboard Summary/Activities API

**Files:**
- Create: `src/main/java/com/company/hrms/reporting/application/DashboardQueryService.java`
- Create: `src/main/java/com/company/hrms/reporting/interfaces/api/DashboardController.java`
- Modify: `src/main/java/com/company/hrms/employee/infrastructure/EmployeeRepository.java`
- Modify: `src/main/java/com/company/hrms/organization/infrastructure/DepartmentRepository.java`
- Modify: `src/main/java/com/company/hrms/payroll/infrastructure/PayrollPeriodRepository.java`
- Modify: `src/main/java/com/company/hrms/attendance/infrastructure/LeaveRequestRepository.java`
- Modify: `src/main/java/com/company/hrms/integration/infrastructure/OutboxEventRepository.java`
- Modify: `src/main/java/com/company/hrms/integration/domain/OutboxEvent.java`
- Create: `src/test/java/com/company/hrms/reporting/DashboardApiIT.java`

- [ ] **Step 1: Write the failing test**

```java
@Test
void returnsDashboardSummary() throws Exception {
    mvc.perform(get("/api/v1/dashboard/summary")
            .header("X-Tenant-Id", "tenant-a")
            .with(jwt().authorities(new SimpleGrantedAuthority("dashboard:read"))))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.employees").isNumber())
        .andExpect(jsonPath("$.departments").isNumber());
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=DashboardApiIT test`  
Expected: FAIL because dashboard endpoint is missing.

- [ ] **Step 3: Write minimal implementation**

```java
// DashboardQueryService.java
public record Summary(long employees, long departments, long openPayrollPeriods, long pendingLeaves) {}
public record Activity(String type, String message, Instant timestamp) {}

@Transactional(readOnly = true)
public Summary summary() {
    String tenantId = TenantContext.get();
    long employeeCount = employeeRepository.countByTenantId(tenantId);
    long departmentCount = departmentRepository.countByTenantId(tenantId);
    long openPeriodCount = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.OPEN);
    long pendingLeaveCount = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
    return new Summary(employeeCount, departmentCount, openPeriodCount, pendingLeaveCount);
}

@Transactional(readOnly = true)
public List<Activity> activities() {
    String tenantId = TenantContext.get();
    return outboxEventRepository.findTop20ByTenantIdOrderByCreatedAtDesc(tenantId).stream()
        .map(e -> new Activity(e.getEventType(), e.getPayload(), e.getCreatedAt()))
        .toList();
}
```

```java
// OutboxEventRepository.java
List<OutboxEvent> findTop20ByTenantIdOrderByCreatedAtDesc(String tenantId);
```

```java
// OutboxEvent.java
public String getEventType() { return eventType; }
public String getPayload() { return payload; }
public Instant getCreatedAt() { return super.getCreatedAt(); }
```

```java
// DashboardController.java
@GetMapping("/api/v1/dashboard/summary")
@PreAuthorize("hasAuthority('dashboard:read')")
public Summary summary() { return dashboardQueryService.summary(); }

@GetMapping("/api/v1/dashboard/activities")
@PreAuthorize("hasAuthority('dashboard:read')")
public List<Activity> activities() { return dashboardQueryService.activities(); }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `.tools/apache-maven-3.9.11/bin/mvn.cmd -Dtest=DashboardApiIT test`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/reporting src/test/java/com/company/hrms/reporting/DashboardApiIT.java
git commit -m "feat: add dashboard summary and activity endpoints"
```

### Task 7: Scaffold `web-admin` App and Shared Frontend Infrastructure

**Files:**
- Create: `web-admin/package.json`
- Create: `web-admin/tsconfig.json`
- Create: `web-admin/tsconfig.node.json`
- Create: `web-admin/vite.config.ts`
- Create: `web-admin/index.html`
- Create: `web-admin/src/main.tsx`
- Create: `web-admin/src/app/layout/AppShell.tsx`
- Create: `web-admin/src/app/router.tsx`
- Create: `web-admin/src/shared/api/client.ts`
- Create: `web-admin/src/shared/config/devSettingsStore.ts`
- Create: `web-admin/src/shared/api/client.test.ts`
- Create: `web-admin/vitest.config.ts`
- Create: `web-admin/src/test/setup.ts`
- Modify: `.gitignore`

- [ ] **Step 1: Write the failing test**

```ts
// web-admin/src/shared/api/client.test.ts
it("injects Authorization and X-Tenant-Id headers from dev settings", async () => {
  const headers = buildHeaders({ token: "abc", tenantId: "tenant-a" });
  expect(headers.Authorization).toBe("Bearer abc");
  expect(headers["X-Tenant-Id"]).toBe("tenant-a");
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --prefix web-admin run test -- --run`  
Expected: FAIL because project and helper are not created yet.

- [ ] **Step 3: Write minimal implementation**

```json
// web-admin/package.json
{
  "name": "hrms-admin-ui",
  "private": true,
  "version": "0.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "test": "vitest",
    "test:e2e": "playwright test"
  },
  "dependencies": {
    "antd": "^5.27.0",
    "axios": "^1.9.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.30.1"
  },
  "devDependencies": {
    "@testing-library/jest-dom": "^6.6.3",
    "@testing-library/react": "^16.3.0",
    "@types/react": "^18.3.11",
    "@types/react-dom": "^18.3.1",
    "@vitejs/plugin-react": "^4.4.1",
    "playwright": "^1.53.0",
    "typescript": "^5.8.3",
    "vite": "^5.4.12",
    "vitest": "^2.1.9"
  }
}
```

```ts
// web-admin/src/shared/api/client.ts
export type DevSettings = { token: string; tenantId: string };
export function buildHeaders(settings: DevSettings) {
  return {
    Authorization: `Bearer ${settings.token}`,
    "X-Tenant-Id": settings.tenantId
  };
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npm --prefix web-admin run test -- --run`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add .gitignore web-admin
git commit -m "feat: scaffold web-admin app with shared api client and tests"
```

### Task 8: Build App Shell, Dev Settings, and Dashboard UI Wiring

**Files:**
- Create: `web-admin/src/features/settings/DevSettingsPage.tsx`
- Create: `web-admin/src/features/dashboard/DashboardPage.tsx`
- Modify: `web-admin/src/app/layout/AppShell.tsx`
- Modify: `web-admin/src/app/router.tsx`
- Create: `web-admin/src/features/settings/DevSettingsPage.test.tsx`

- [ ] **Step 1: Write the failing test**

```tsx
it("persists token and tenant when saving dev settings", async () => {
  render(<DevSettingsPage />);
  await user.type(screen.getByLabelText(/Token/i), "test-token");
  await user.type(screen.getByLabelText(/Tenant/i), "tenant-a");
  await user.click(screen.getByRole("button", { name: /Lưu/i }));
  expect(localStorage.getItem("hrms.dev.token")).toBe("test-token");
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --prefix web-admin run test -- --run DevSettingsPage.test.tsx`  
Expected: FAIL because page is not implemented.

- [ ] **Step 3: Write minimal implementation**

```tsx
// DevSettingsPage.tsx
export default function DevSettingsPage() {
  const [token, setToken] = useState(loadToken());
  const [tenantId, setTenantId] = useState(loadTenantId());
  const onSave = () => {
    localStorage.setItem("hrms.dev.token", token.trim());
    localStorage.setItem("hrms.dev.tenant", tenantId.trim());
    message.success("Lưu cấu hình thành công");
  };
  return (
    <Form layout="vertical" onFinish={onSave}>
      <Form.Item label="Token"><Input value={token} onChange={e => setToken(e.target.value)} /></Form.Item>
      <Form.Item label="Tenant"><Input value={tenantId} onChange={e => setTenantId(e.target.value)} /></Form.Item>
      <Button htmlType="submit" type="primary">Lưu</Button>
    </Form>
  );
}
```

```tsx
// AppShell.tsx
const items = [
  { key: "/dashboard", icon: <LayoutDashboard size={16} />, label: "Dashboard" },
  { key: "/departments", icon: <Building2 size={16} />, label: "Departments" },
  { key: "/employees", icon: <Users size={16} />, label: "Employees" },
  { key: "/recruitment", icon: <BriefcaseBusiness size={16} />, label: "Recruitment" },
  { key: "/leave", icon: <CalendarClock size={16} />, label: "Leave" },
  { key: "/payroll", icon: <Wallet size={16} />, label: "Payroll" },
  { key: "/settings", icon: <Settings size={16} />, label: "Settings" }
];
return (
  <Layout>
    <Layout.Sider><Menu selectedKeys={[pathname]} items={items} onClick={({ key }) => navigate(key)} /></Layout.Sider>
    <Layout.Content><Outlet /></Layout.Content>
  </Layout>
);
```

```tsx
// DashboardPage.tsx
const summaryQuery = useQuery({ queryKey: ["dashboard-summary"], queryFn: api.getDashboardSummary });
const activityQuery = useQuery({ queryKey: ["dashboard-activities"], queryFn: api.getDashboardActivities });
return (
  <>
    <Row gutter={16}>
      <Col span={6}><Statistic title="Employees" value={summaryQuery.data?.employees ?? 0} /></Col>
      <Col span={6}><Statistic title="Departments" value={summaryQuery.data?.departments ?? 0} /></Col>
      <Col span={6}><Statistic title="Open Payroll" value={summaryQuery.data?.openPayrollPeriods ?? 0} /></Col>
      <Col span={6}><Statistic title="Pending Leaves" value={summaryQuery.data?.pendingLeaves ?? 0} /></Col>
    </Row>
    <Table rowKey="timestamp" dataSource={activityQuery.data ?? []} columns={activityColumns} pagination={false} />
  </>
);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npm --prefix web-admin run test -- --run DevSettingsPage.test.tsx`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add web-admin/src/app web-admin/src/features/settings web-admin/src/features/dashboard
git commit -m "feat: add admin shell, dev settings, and dashboard pages"
```

### Task 9: Build Department and Employee UI Modules

**Files:**
- Create: `web-admin/src/features/departments/DepartmentsPage.tsx`
- Create: `web-admin/src/features/departments/DepartmentsPage.test.tsx`
- Create: `web-admin/src/features/employees/EmployeesPage.tsx`
- Create: `web-admin/src/features/employees/EmployeesPage.test.tsx`
- Create: `web-admin/src/shared/ui/AppTable.tsx`
- Create: `web-admin/src/shared/ui/PageToolbar.tsx`
- Create: `web-admin/src/shared/ui/StatusTag.tsx`
- Create: `web-admin/src/shared/ui/FormDrawer.tsx`

- [ ] **Step 1: Write the failing tests**

```tsx
it("shows departments from API and opens create modal", async () => {
  render(<DepartmentsPage />);
  expect(await screen.findByText("Engineering")).toBeInTheDocument();
  await user.click(screen.getByRole("button", { name: /Thêm phòng ban/i }));
  expect(screen.getByText(/Mã phòng ban/i)).toBeInTheDocument();
});
```

```tsx
it("filters employees by status", async () => {
  render(<EmployeesPage />);
  await user.click(screen.getByText("ACTIVE"));
  expect(await screen.findByText("Nguyen Van A")).toBeInTheDocument();
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `npm --prefix web-admin run test -- --run DepartmentsPage.test.tsx EmployeesPage.test.tsx`  
Expected: FAIL because pages are not implemented.

- [ ] **Step 3: Write minimal implementation**

```tsx
// DepartmentsPage.tsx
const [keyword, setKeyword] = useState("");
const query = useQuery({ queryKey: ["departments", keyword, page, size], queryFn: () => api.listDepartments({ q: keyword, page, size }) });
return (
  <>
    <Space>
      <Input value={keyword} onChange={(e) => setKeyword(e.target.value)} placeholder="Tìm theo mã hoặc tên" />
      <Button type="primary" onClick={() => setOpenCreate(true)}>Thêm phòng ban</Button>
    </Space>
    <Table rowKey="id" dataSource={query.data?.items ?? []} columns={columns} pagination={{ current: page + 1, total: query.data?.totalItems }} />
  </>
);
```

```tsx
// EmployeesPage.tsx
const query = useQuery({
  queryKey: ["employees", filters, page, size],
  queryFn: () => api.listEmployees({ ...filters, page, size })
});
return (
  <>
    <EmployeeFilterBar filters={filters} onChange={setFilters} />
    <Table rowKey="id" dataSource={query.data?.items ?? []} columns={employeeColumns(onEdit, onChangeStatus)} />
    <EmployeeFormModal open={openForm} onSubmit={submitEmployee} />
  </>
);
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `npm --prefix web-admin run test -- --run DepartmentsPage.test.tsx EmployeesPage.test.tsx`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add web-admin/src/features/departments web-admin/src/features/employees web-admin/src/shared/ui
git commit -m "feat: add department and employee management pages"
```

### Task 10: Build Recruitment, Leave, Payroll UI Modules

**Files:**
- Create: `web-admin/src/features/recruitment/RecruitmentPage.tsx`
- Create: `web-admin/src/features/leave/LeavePage.tsx`
- Create: `web-admin/src/features/payroll/PayrollPage.tsx`
- Modify: `web-admin/src/app/router.tsx`

- [ ] **Step 1: Write the failing smoke test**

```ts
test("recruitment to payroll admin paths render", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("menuitem", { name: "Recruitment" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Payroll" })).toBeVisible();
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npm --prefix web-admin run test:e2e -- --grep "recruitment to payroll"`  
Expected: FAIL because pages are not wired.

- [ ] **Step 3: Write minimal implementation**

```tsx
// RecruitmentPage.tsx
return (
  <Tabs items={[
    { key: "candidates", label: "Candidates", children: <CandidatesTab /> },
    { key: "postings", label: "Job Postings", children: <PostingsTab /> },
    { key: "applications", label: "Applications", children: <ApplicationsTab onConvert={convertToEmployee} /> }
  ]} />
);
```

```tsx
// LeavePage.tsx
return (
  <>
    <LeaveFilterBar value={filters} onChange={setFilters} />
    <Table rowKey="id" dataSource={query.data?.items ?? []} columns={leaveColumns(approveLeave, rejectLeave)} />
    <LeaveRequestModal open={openCreate} onSubmit={createLeaveRequest} />
  </>
);
```

```tsx
// PayrollPage.tsx
return (
  <>
    <Button type="primary" onClick={() => setOpenPeriodModal(true)}>Tạo kỳ lương</Button>
    <Table rowKey="id" dataSource={periodQuery.data?.items ?? []} columns={periodColumns(executeRun, closePeriod, openRuns)} />
    <Drawer open={openRunsDrawer}><Table rowKey="id" dataSource={runsQuery.data?.items ?? []} columns={runColumns} /></Drawer>
  </>
);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npm --prefix web-admin run test:e2e -- --grep "recruitment to payroll"`  
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add web-admin/src/features/recruitment web-admin/src/features/leave web-admin/src/features/payroll web-admin/src/app/router.tsx
git commit -m "feat: add recruitment leave payroll admin pages"
```

### Task 11: Full Verification, Docs, and Developer Runbook

**Files:**
- Modify: `README.md`
- Create: `web-admin/playwright.config.ts`
- Create: `web-admin/e2e/admin-smoke.spec.ts`

- [ ] **Step 1: Write the full smoke e2e test**

```ts
test("admin happy path", async ({ page }) => {
  await page.goto("/settings");
  await page.getByLabel("Token").fill("e2e-token");
  await page.getByLabel("Tenant").fill("tenant-e2e");
  await page.getByRole("button", { name: "Lưu" }).click();

  await page.goto("/departments");
  await page.getByRole("button", { name: "Thêm phòng ban" }).click();
  await page.getByLabel("Mã phòng ban").fill("ENG-E2E");
  await page.getByLabel("Tên phòng ban").fill("Engineering E2E");
  await page.getByRole("button", { name: "Tạo mới" }).click();

  await page.goto("/employees");
  await page.getByRole("button", { name: "Thêm nhân viên" }).click();
  await page.getByLabel("Mã nhân viên").fill("E2E-001");
  await page.getByLabel("Họ và tên").fill("Test Employee");
  await page.getByRole("button", { name: "Lưu nhân viên" }).click();

  await page.goto("/payroll");
  await page.getByRole("button", { name: "Tạo kỳ lương" }).click();
  await page.getByLabel("Từ ngày").fill("2026-06-01");
  await page.getByLabel("Đến ngày").fill("2026-06-30");
  await page.getByRole("button", { name: "Tạo kỳ" }).click();
});
```

- [ ] **Step 2: Run backend + frontend checks before implementation finalization**

Run:

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test
npm --prefix web-admin run test -- --run
npm --prefix web-admin run build
npm --prefix web-admin run test:e2e
```

Expected: all commands PASS.

- [ ] **Step 3: Update README with exact run commands**

```md
## Run backend
docker compose -f docker/compose.yml up -d
.tools/apache-maven-3.9.11/bin/mvn.cmd spring-boot:run

## Run frontend
cd web-admin
npm install
npm run dev
```

- [ ] **Step 4: Re-run final verification**

Run:

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test
npm --prefix web-admin run test -- --run
```

Expected: PASS, no regression.

- [ ] **Step 5: Commit**

```bash
git add README.md web-admin/playwright.config.ts web-admin/e2e/admin-smoke.spec.ts
git commit -m "test: add admin smoke e2e and update developer runbook"
```

---

## Plan Self-Review

### 1. Spec coverage check

- ✅ Frontend app scaffolding and architecture covered (Tasks 7-10).
- ✅ Backend API expansion per module covered (Tasks 2-6).
- ✅ Error model and pagination contract covered (Task 1).
- ✅ Dashboard endpoints and UI covered (Tasks 6 and 8).
- ✅ Dev token/tenant mode covered (Tasks 7-8).
- ✅ Testing strategy across backend/frontend/e2e covered (Tasks 1-11).

### 2. Placeholder scan

- No `TODO`/`TBD` placeholders left in task instructions.
- Every task includes explicit files, commands, and expected outcomes.

### 3. Type/signature consistency

- Shared pagination contract uses `PageResponse<T>` across controllers.
- Tenant/token handling centralized in frontend API client.
- Endpoint names and paths match approved spec.
