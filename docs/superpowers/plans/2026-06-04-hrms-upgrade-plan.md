# HRMS Platform Upgrade — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade the HRMS modular monolith with enriched existing modules, 2 new modules (Performance, Self-Service), and comprehensive Vietnamese sample data (~120 employees, ~60K attendance records, payroll history).

**Architecture:** Spring Boot 4 modular monolith using Spring Modulith. Each module follows domain/application/infrastructure/interfaces convention. Vue 3 + Ant Design frontend with existing shared UI components. Tenant-scoped data via TenantContext.

**Tech Stack:** Java 21, Spring Boot 4, Spring Data JPA, Flyway, PostgreSQL/H2, Vue 3, Ant Design, TypeScript, Vite, Vitest

---

## Phase 1: Infrastructure & Exception Foundation

### Task 1: Add BadRequestException

**Files:**
- Create: `src/main/java/com/company/hrms/shared/exception/BadRequestException.java`
- Modify: `src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java:1-44`

- [ ] **Step 1: Create BadRequestException**

```java
package com.company.hrms.shared.exception;

public class BadRequestException extends RuntimeException {
    public BadRequestException(String message) {
        super(message);
    }
}
```

- [ ] **Step 2: Register in ApiExceptionHandler**

Add this handler method before the closing `}` of `ApiExceptionHandler`:

```java
@ExceptionHandler(BadRequestException.class)
ResponseEntity<ApiError> handleBadRequest(BadRequestException ex) {
    return ResponseEntity.badRequest()
        .body(new ApiError("BAD_REQUEST", ex.getMessage(), Instant.now(), Map.of()));
}
```

- [ ] **Step 3: Commit**

```bash
git add src/main/java/com/company/hrms/shared/exception/BadRequestException.java src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java
git commit -m "feat: add BadRequestException handler"
```

### Task 2: Add ForbiddenException

**Files:**
- Create: `src/main/java/com/company/hrms/shared/exception/ForbiddenException.java`
- Modify: `src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java`

- [ ] **Step 1: Create ForbiddenException**

```java
package com.company.hrms.shared.exception;

public class ForbiddenException extends RuntimeException {
    public ForbiddenException(String message) {
        super(message);
    }
}
```

- [ ] **Step 2: Register in ApiExceptionHandler**

Add before the closing `}`:

```java
@ExceptionHandler(ForbiddenException.class)
ResponseEntity<ApiError> handleForbidden(ForbiddenException ex) {
    return ResponseEntity.status(HttpStatus.FORBIDDEN)
        .body(new ApiError("FORBIDDEN", ex.getMessage(), Instant.now(), Map.of()));
}
```

- [ ] **Step 3: Commit**

```bash
git add src/main/java/com/company/hrms/shared/exception/ForbiddenException.java src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java
git commit -m "feat: add ForbiddenException handler"
```

### Task 3: Add PayrollLockedException

**Files:**
- Create: `src/main/java/com/company/hrms/shared/exception/PayrollLockedException.java`
- Modify: `src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java`

- [ ] **Step 1: Create PayrollLockedException**

```java
package com.company.hrms.shared.exception;

public class PayrollLockedException extends RuntimeException {
    public PayrollLockedException(String message) {
        super(message);
    }
}
```

- [ ] **Step 2: Register in ApiExceptionHandler**

Add before the closing `}`:

```java
@ExceptionHandler(PayrollLockedException.class)
ResponseEntity<ApiError> handlePayrollLocked(PayrollLockedException ex) {
    return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
        .body(new ApiError("PAYROLL_LOCKED", ex.getMessage(), Instant.now(), Map.of()));
}
```

- [ ] **Step 3: Commit**

```bash
git add src/main/java/com/company/hrms/shared/exception/PayrollLockedException.java src/main/java/com/company/hrms/shared/exception/ApiExceptionHandler.java
git commit -m "feat: add PayrollLockedException handler"
```

---

## Phase 2: Employee Module Extension

### Task 4: Write Employee domain entities test stub (compile-check)

**Files:**
- Modify: `src/test/java/com/company/hrms/architecture/ModuleBoundariesTest.java:13-23`

- [ ] **Step 1: Add new modules to expected list**

Change `EXPECTED_MODULES` in `ModuleBoundariesTest.java`:

```java
private static final List<String> EXPECTED_MODULES = List.of(
    "identity",
    "organization",
    "employee",
    "recruitment",
    "attendance",
    "payroll",
    "reporting",
    "integration",
    "audit",
    "performance",
    "selfservice"
);
```

- [ ] **Step 2: Commit**

```bash
git add src/test/java/com/company/hrms/architecture/ModuleBoundariesTest.java
git commit -m "test: add performance and selfservice modules to boundary check"
```

### Task 5: DB Migration V11 — Extend employee table

**Files:**
- Create: `src/main/resources/db/migration/V11__extend_employee_table.sql`

- [ ] **Step 1: Write migration**

```sql
ALTER TABLE employee
  ADD COLUMN IF NOT EXISTS position_id uuid,
  ADD COLUMN IF NOT EXISTS email varchar(255),
  ADD COLUMN IF NOT EXISTS phone varchar(20),
  ADD COLUMN IF NOT EXISTS date_of_birth date,
  ADD COLUMN IF NOT EXISTS gender varchar(10),
  ADD COLUMN IF NOT EXISTS national_id varchar(20),
  ADD COLUMN IF NOT EXISTS address text,
  ADD COLUMN IF NOT EXISTS bank_account varchar(30),
  ADD COLUMN IF NOT EXISTS tax_code varchar(20);
```

- [ ] **Step 2: Run tests to verify migration applies**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS (Spring context loads, Flyway applies V11)

- [ ] **Step 3: Commit**

```bash
git add src/main/resources/db/migration/V11__extend_employee_table.sql
git commit -m "feat: add employee extended columns migration"
```

### Task 6: DB Migration V12 — Create position, contract, skill, emergency_contact tables

**Files:**
- Create: `src/main/resources/db/migration/V12__create_position_contract_skill_emergency.sql`

- [ ] **Step 1: Write migration**

```sql
CREATE TABLE IF NOT EXISTS position (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  code varchar(50) NOT NULL,
  title varchar(255) NOT NULL,
  department_id uuid NOT NULL REFERENCES department(id),
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  UNIQUE (tenant_id, code)
);

CREATE TABLE IF NOT EXISTS employee_contract (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  contract_type varchar(20) NOT NULL,
  start_date date NOT NULL,
  end_date date,
  salary numeric(15, 2) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS employee_skill (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  skill_name varchar(100) NOT NULL,
  proficiency_level varchar(20) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS emergency_contact (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  full_name varchar(255) NOT NULL,
  relationship varchar(50) NOT NULL,
  phone varchar(20) NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);
```

- [ ] **Step 2: Verify migration applies**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/main/resources/db/migration/V12__create_position_contract_skill_emergency.sql
git commit -m "feat: add position, contract, skill, emergency_contact tables"
```

### Task 7: Create Gender enum and Position entity

**Files:**
- Create: `src/main/java/com/company/hrms/employee/domain/Gender.java`
- Create: `src/main/java/com/company/hrms/employee/domain/Position.java`
- Create: `src/main/java/com/company/hrms/employee/infrastructure/PositionRepository.java`

- [ ] **Step 1: Create Gender enum**

```java
package com.company.hrms.employee.domain;

public enum Gender {
    MALE,
    FEMALE,
    OTHER
}
```

- [ ] **Step 2: Create Position entity**

```java
package com.company.hrms.employee.domain;

import com.company.hrms.organization.domain.Department;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "position")
public class Position extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "code", nullable = false, length = 50)
    private String code;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    protected Position() {}

    public Position(UUID id, String tenantId, String code, String title, Department department) {
        this.id = id;
        this.tenantId = tenantId;
        this.code = code;
        this.title = title;
        this.department = department;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public String getCode() { return code; }
    public String getTitle() { return title; }
    public Department getDepartment() { return department; }
}
```

- [ ] **Step 3: Create PositionRepository**

```java
package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.Position;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PositionRepository extends JpaRepository<Position, UUID> {
    Page<Position> findAllByTenantId(String tenantId, Pageable pageable);
    Optional<Position> findByIdAndTenantId(UUID id, String tenantId);
    boolean existsByTenantIdAndCode(String tenantId, String code);
}
```

- [ ] **Step 4: Commit**

```bash
git add src/main/java/com/company/hrms/employee/domain/Gender.java src/main/java/com/company/hrms/employee/domain/Position.java src/main/java/com/company/hrms/employee/infrastructure/PositionRepository.java
git commit -m "feat: add Gender enum, Position entity and repository"
```

### Task 8: Create EmployeeContract, EmployeeSkill, EmergencyContact entities and repositories

**Files:**
- Create: `src/main/java/com/company/hrms/employee/domain/EmployeeContract.java`
- Create: `src/main/java/com/company/hrms/employee/domain/ContractType.java`
- Create: `src/main/java/com/company/hrms/employee/domain/EmployeeSkill.java`
- Create: `src/main/java/com/company/hrms/employee/domain/ProficiencyLevel.java`
- Create: `src/main/java/com/company/hrms/employee/domain/EmergencyContact.java`
- Create: `src/main/java/com/company/hrms/employee/infrastructure/EmployeeContractRepository.java`
- Create: `src/main/java/com/company/hrms/employee/infrastructure/EmployeeSkillRepository.java`
- Create: `src/main/java/com/company/hrms/employee/infrastructure/EmergencyContactRepository.java`

- [ ] **Step 1: Create ContractType enum**

```java
package com.company.hrms.employee.domain;

public enum ContractType {
    FIXED,
    SEASONAL,
    PROBATION
}
```

- [ ] **Step 2: Create ProficiencyLevel enum**

```java
package com.company.hrms.employee.domain;

public enum ProficiencyLevel {
    BEGINNER,
    INTERMEDIATE,
    ADVANCED,
    EXPERT
}
```

- [ ] **Step 3: Create EmployeeContract entity**

```java
package com.company.hrms.employee.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "employee_contract")
public class EmployeeContract extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Enumerated(EnumType.STRING)
    @Column(name = "contract_type", nullable = false, length = 20)
    private ContractType contractType;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "salary", nullable = false, precision = 15, scale = 2)
    private BigDecimal salary;

    protected EmployeeContract() {}

    public EmployeeContract(UUID id, String tenantId, Employee employee, ContractType contractType,
                           LocalDate startDate, LocalDate endDate, BigDecimal salary) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.contractType = contractType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.salary = salary;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public ContractType getContractType() { return contractType; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public BigDecimal getSalary() { return salary; }
}
```

- [ ] **Step 4: Create EmployeeSkill entity**

```java
package com.company.hrms.employee.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "employee_skill")
public class EmployeeSkill extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "skill_name", nullable = false, length = 100)
    private String skillName;

    @Enumerated(EnumType.STRING)
    @Column(name = "proficiency_level", nullable = false, length = 20)
    private ProficiencyLevel proficiencyLevel;

    protected EmployeeSkill() {}

    public EmployeeSkill(UUID id, String tenantId, Employee employee, String skillName, ProficiencyLevel proficiencyLevel) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.skillName = skillName;
        this.proficiencyLevel = proficiencyLevel;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public String getSkillName() { return skillName; }
    public ProficiencyLevel getProficiencyLevel() { return proficiencyLevel; }
}
```

- [ ] **Step 5: Create EmergencyContact entity**

```java
package com.company.hrms.employee.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "emergency_contact")
public class EmergencyContact extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    @Column(name = "relationship", nullable = false, length = 50)
    private String relationship;

    @Column(name = "phone", nullable = false, length = 20)
    private String phone;

    protected EmergencyContact() {}

    public EmergencyContact(UUID id, String tenantId, Employee employee, String fullName, String relationship, String phone) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.fullName = fullName;
        this.relationship = relationship;
        this.phone = phone;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public String getFullName() { return fullName; }
    public String getRelationship() { return relationship; }
    public String getPhone() { return phone; }
}
```

- [ ] **Step 6: Create repositories**

```java
package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.EmployeeContract;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EmployeeContractRepository extends JpaRepository<EmployeeContract, UUID> {
    List<EmployeeContract> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
```

```java
package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.EmployeeSkill;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EmployeeSkillRepository extends JpaRepository<EmployeeSkill, UUID> {
    List<EmployeeSkill> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
```

```java
package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.EmergencyContact;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EmergencyContactRepository extends JpaRepository<EmergencyContact, UUID> {
    List<EmergencyContact> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
```

- [ ] **Step 7: Commit**

```bash
git add src/main/java/com/company/hrms/employee/
git commit -m "feat: add EmployeeContract, EmployeeSkill, EmergencyContact entities"
```

### Task 9: Extend Employee entity with new fields

**Files:**
- Modify: `src/main/java/com/company/hrms/employee/domain/Employee.java:1-100`

- [ ] **Step 1: Add new fields and constructor params to Employee**

Replace the entire Employee.java:

```java
package com.company.hrms.employee.domain;

import com.company.hrms.organization.domain.Department;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "employee")
public class Employee extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_no", nullable = false, length = 50)
    private String employeeNo;

    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "position_id")
    private Position position;

    @Column(name = "hire_date", nullable = false)
    private LocalDate hireDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "employment_status", nullable = false, length = 30)
    private EmploymentStatus employmentStatus;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", length = 10)
    private Gender gender;

    @Column(name = "national_id", length = 20)
    private String nationalId;

    @Column(name = "address")
    private String address;

    @Column(name = "bank_account", length = 30)
    private String bankAccount;

    @Column(name = "tax_code", length = 20)
    private String taxCode;

    protected Employee() {
    }

    public Employee(UUID id, String tenantId, String employeeNo, String fullName,
                    Department department, LocalDate hireDate, EmploymentStatus employmentStatus) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeNo = employeeNo;
        this.fullName = fullName;
        this.department = department;
        this.hireDate = hireDate;
        this.employmentStatus = employmentStatus;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public String getEmployeeNo() { return employeeNo; }
    public String getFullName() { return fullName; }
    public Department getDepartment() { return department; }
    public Position getPosition() { return position; }
    public LocalDate getHireDate() { return hireDate; }
    public EmploymentStatus getEmploymentStatus() { return employmentStatus; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public Gender getGender() { return gender; }
    public String getNationalId() { return nationalId; }
    public String getAddress() { return address; }
    public String getBankAccount() { return bankAccount; }
    public String getTaxCode() { return taxCode; }

    public void updateProfile(String fullName, Department department, LocalDate hireDate) {
        this.fullName = fullName;
        this.department = department;
        this.hireDate = hireDate;
    }

    public void updateExtendedProfile(String email, String phone, Position position, LocalDate dateOfBirth,
                                       Gender gender, String nationalId, String address,
                                       String bankAccount, String taxCode) {
        this.email = email;
        this.phone = phone;
        this.position = position;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.nationalId = nationalId;
        this.address = address;
        this.bankAccount = bankAccount;
        this.taxCode = taxCode;
    }

    public void changeStatus(EmploymentStatus status) {
        this.employmentStatus = status;
    }
}
```

- [ ] **Step 2: Verify compilation**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd compile
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/main/java/com/company/hrms/employee/domain/Employee.java
git commit -m "feat: extend Employee entity with position, contact, and profile fields"
```

### Task 10: Update EmployeeService with extended profile handling

**Files:**
- Modify: `src/main/java/com/company/hrms/employee/application/EmployeeService.java:1-105`

- [ ] **Step 1: Add PositionRepository dependency and update update method**

Replace the full `EmployeeService.java`:

```java
package com.company.hrms.employee.application;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.employee.domain.Gender;
import com.company.hrms.employee.domain.Position;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.employee.infrastructure.PositionRepository;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Locale;
import java.util.UUID;

@Service
public class EmployeeService {
    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;
    private final PositionRepository positionRepository;

    public EmployeeService(EmployeeRepository employeeRepository,
                           DepartmentRepository departmentRepository,
                           PositionRepository positionRepository) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
        this.positionRepository = positionRepository;
    }

    @Transactional
    public Employee create(String employeeNo, String fullName, UUID departmentId, LocalDate hireDate) {
        String tenantId = TenantContext.get();
        if (employeeRepository.existsByTenantIdAndEmployeeNo(tenantId, employeeNo)) {
            throw new ConflictException("EMPLOYEE_NO_EXISTS");
        }
        Department department = departmentRepository.findByIdAndTenantId(departmentId, tenantId)
            .orElseThrow(() -> new IllegalArgumentException("DEPARTMENT_NOT_FOUND"));
        Employee employee = new Employee(
            UUID.randomUUID(), tenantId, employeeNo, fullName, department, hireDate, EmploymentStatus.ACTIVE
        );
        return employeeRepository.save(employee);
    }

    @Transactional(readOnly = true)
    public Page<Employee> list(String query, String status, Pageable pageable) {
        String tenantId = TenantContext.get();
        String normalizedQuery = query == null ? null : query.trim();
        String normalizedStatus = status == null ? null : status.trim();

        if (normalizedStatus != null && !normalizedStatus.isEmpty()) {
            EmploymentStatus employmentStatus = parseStatus(normalizedStatus);
            if (normalizedQuery != null && !normalizedQuery.isEmpty()) {
                return employeeRepository.findByTenantIdAndEmploymentStatusAndFullNameContainingIgnoreCase(
                    tenantId, employmentStatus, normalizedQuery, pageable);
            }
            return employeeRepository.findByTenantIdAndEmploymentStatus(tenantId, employmentStatus, pageable);
        }
        if (normalizedQuery != null && !normalizedQuery.isEmpty()) {
            return employeeRepository.findByTenantIdAndFullNameContainingIgnoreCase(tenantId, normalizedQuery, pageable);
        }
        return employeeRepository.findAllByTenantId(tenantId, pageable);
    }

    @Transactional(readOnly = true)
    public Employee getById(UUID id) {
        return employeeRepository.findByIdAndTenantId(id, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("EMPLOYEE_NOT_FOUND"));
    }

    @Transactional
    public Employee update(UUID id, String fullName, UUID departmentId, LocalDate hireDate) {
        String tenantId = TenantContext.get();
        Employee employee = employeeRepository.findByIdAndTenantId(id, tenantId)
            .orElseThrow(() -> new IllegalArgumentException("EMPLOYEE_NOT_FOUND"));
        Department department = departmentRepository.findByIdAndTenantId(departmentId, tenantId)
            .orElseThrow(() -> new IllegalArgumentException("DEPARTMENT_NOT_FOUND"));
        employee.updateProfile(fullName, department, hireDate);
        return employee;
    }

    @Transactional
    public Employee updateExtended(UUID id, String fullName, UUID departmentId, LocalDate hireDate,
                                    String email, String phone, UUID positionId, LocalDate dateOfBirth,
                                    String gender, String nationalId, String address,
                                    String bankAccount, String taxCode) {
        String tenantId = TenantContext.get();
        Employee employee = employeeRepository.findByIdAndTenantId(id, tenantId)
            .orElseThrow(() -> new IllegalArgumentException("EMPLOYEE_NOT_FOUND"));
        Department department = departmentRepository.findByIdAndTenantId(departmentId, tenantId)
            .orElseThrow(() -> new IllegalArgumentException("DEPARTMENT_NOT_FOUND"));
        employee.updateProfile(fullName, department, hireDate);

        Position position = null;
        if (positionId != null) {
            position = positionRepository.findByIdAndTenantId(positionId, tenantId)
                .orElseThrow(() -> new IllegalArgumentException("POSITION_NOT_FOUND"));
        }
        Gender genderEnum = null;
        if (gender != null && !gender.isEmpty()) {
            genderEnum = Gender.valueOf(gender.toUpperCase(Locale.ROOT));
        }
        employee.updateExtendedProfile(email, phone, position, dateOfBirth, genderEnum, nationalId, address, bankAccount, taxCode);
        return employee;
    }

    @Transactional
    public Employee changeStatus(UUID id, EmploymentStatus status) {
        Employee employee = employeeRepository.findByIdAndTenantId(id, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("EMPLOYEE_NOT_FOUND"));
        employee.changeStatus(status);
        return employee;
    }

    private static EmploymentStatus parseStatus(String status) {
        try {
            return EmploymentStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_EMPLOYMENT_STATUS");
        }
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/employee/application/EmployeeService.java
git commit -m "feat: extend EmployeeService with position and profile fields"
```

### Task 11: Update EmployeeController with extended response and update endpoint

**Files:**
- Modify: `src/main/java/com/company/hrms/employee/interfaces/api/EmployeeController.java:1-113`

- [ ] **Step 1: Extend EmployeeResponse and add extended update endpoint**

Replace the entire `EmployeeController.java`:

```java
package com.company.hrms.employee.interfaces.api;

import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/employees")
@Validated
public class EmployeeController {
    private final EmployeeService employeeService;

    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

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

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:read')")
    public EmployeeResponse getById(@PathVariable UUID id) {
        return toResponse(employeeService.getById(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('employee:create')")
    public EmployeeResponse create(@Valid @RequestBody CreateEmployeeRequest request) {
        return toResponse(employeeService.create(
            request.employeeNo(), request.fullName(), request.departmentId(), request.hireDate()
        ));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse update(@PathVariable UUID id, @Valid @RequestBody UpdateEmployeeRequest request) {
        return toResponse(employeeService.update(
            id, request.fullName(), request.departmentId(), request.hireDate()
        ));
    }

    @PutMapping("/{id}/profile")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse updateExtended(@PathVariable UUID id, @Valid @RequestBody UpdateExtendedRequest request) {
        return toResponse(employeeService.updateExtended(
            id, request.fullName(), request.departmentId(), request.hireDate(),
            request.email(), request.phone(), request.positionId(), request.dateOfBirth(),
            request.gender(), request.nationalId(), request.address(),
            request.bankAccount(), request.taxCode()
        ));
    }

    @PatchMapping("/{id}/status")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse patchStatus(@PathVariable UUID id, @Valid @RequestBody UpdateStatusRequest request) {
        return toResponse(employeeService.changeStatus(id, request.employmentStatus()));
    }

    private static EmployeeResponse toResponse(Employee e) {
        return new EmployeeResponse(
            e.getId(), e.getEmployeeNo(), e.getFullName(),
            e.getDepartment().getId(), e.getEmploymentStatus().name(), e.getHireDate(),
            e.getEmail(), e.getPhone(),
            e.getPosition() != null ? e.getPosition().getId() : null,
            e.getPosition() != null ? e.getPosition().getTitle() : null,
            e.getDateOfBirth(), e.getGender() != null ? e.getGender().name() : null,
            e.getNationalId(), e.getAddress(), e.getBankAccount(), e.getTaxCode()
        );
    }

    public record CreateEmployeeRequest(@NotBlank String employeeNo, @NotBlank String fullName,
                                        @NotNull UUID departmentId, @NotNull LocalDate hireDate) {}

    public record UpdateEmployeeRequest(@NotBlank String fullName, @NotNull UUID departmentId,
                                        @NotNull LocalDate hireDate) {}

    public record UpdateExtendedRequest(@NotBlank String fullName, @NotNull UUID departmentId,
                                         @NotNull LocalDate hireDate, String email, String phone,
                                         UUID positionId, LocalDate dateOfBirth, String gender,
                                         String nationalId, String address,
                                         String bankAccount, String taxCode) {}

    public record UpdateStatusRequest(@NotNull EmploymentStatus employmentStatus) {}

    public record EmployeeResponse(UUID id, String employeeNo, String fullName,
                                    UUID departmentId, String employmentStatus, LocalDate hireDate,
                                    String email, String phone, UUID positionId, String positionTitle,
                                    LocalDate dateOfBirth, String gender,
                                    String nationalId, String address,
                                    String bankAccount, String taxCode) {}
}
```

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/employee/interfaces/api/EmployeeController.java
git commit -m "feat: extend EmployeeController with profile fields and extended update endpoint"
```

---

## Phase 3: Attendance Module Extension

### Task 12: DB Migration V13 — Create leave_balance, holiday, overtime_record tables

**Files:**
- Create: `src/main/resources/db/migration/V13__create_leave_balance_holiday_overtime.sql`

- [ ] **Step 1: Write migration**

```sql
CREATE TABLE IF NOT EXISTS leave_balance (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL,
  leave_type varchar(20) NOT NULL,
  year integer NOT NULL,
  total_days integer NOT NULL,
  used_days integer NOT NULL DEFAULT 0,
  pending_days integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  UNIQUE (tenant_id, employee_id, leave_type, year)
);

CREATE TABLE IF NOT EXISTS holiday (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  name varchar(255) NOT NULL,
  date date NOT NULL,
  description text,
  is_recurring_yearly boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS overtime_record (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL,
  date date NOT NULL,
  hours numeric(4, 1) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'PENDING',
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);
```

- [ ] **Step 2: Verify migration**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/main/resources/db/migration/V13__create_leave_balance_holiday_overtime.sql
git commit -m "feat: add leave_balance, holiday, overtime_record tables"
```

### Task 13: DB Migration V14 — Extend leave_request table

**Files:**
- Create: `src/main/resources/db/migration/V14__extend_leave_request_attendance.sql`

- [ ] **Step 1: Write migration**

```sql
ALTER TABLE leave_request
  ADD COLUMN IF NOT EXISTS leave_type varchar(20) NOT NULL DEFAULT 'ANNUAL',
  ADD COLUMN IF NOT EXISTS approved_by uuid,
  ADD COLUMN IF NOT EXISTS reason text;
```

- [ ] **Step 2: Verify migration**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/main/resources/db/migration/V14__extend_leave_request_attendance.sql
git commit -m "feat: extend leave_request with leave_type, approved_by, reason"
```

### Task 14: Create leave-related enums and entities

**Files:**
- Create: `src/main/java/com/company/hrms/attendance/domain/LeaveType.java`
- Create: `src/main/java/com/company/hrms/attendance/domain/OvertimeStatus.java`
- Create: `src/main/java/com/company/hrms/attendance/domain/LeaveBalance.java`
- Create: `src/main/java/com/company/hrms/attendance/domain/Holiday.java`
- Create: `src/main/java/com/company/hrms/attendance/domain/OvertimeRecord.java`
- Create: `src/main/java/com/company/hrms/attendance/infrastructure/LeaveBalanceRepository.java`
- Create: `src/main/java/com/company/hrms/attendance/infrastructure/HolidayRepository.java`
- Create: `src/main/java/com/company/hrms/attendance/infrastructure/OvertimeRecordRepository.java`
- Modify: `src/main/java/com/company/hrms/attendance/domain/LeaveRequest.java:1-75`

- [ ] **Step 1: Create LeaveType enum**

```java
package com.company.hrms.attendance.domain;

public enum LeaveType {
    ANNUAL,
    SICK,
    UNPAID,
    MATERNITY,
    PATERNITY
}
```

- [ ] **Step 2: Create OvertimeStatus enum**

```java
package com.company.hrms.attendance.domain;

public enum OvertimeStatus {
    PENDING,
    APPROVED,
    REJECTED
}
```

- [ ] **Step 3: Create LeaveBalance entity**

```java
package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.UUID;

@Entity
@Table(name = "leave_balance")
public class LeaveBalance extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Enumerated(EnumType.STRING)
    @Column(name = "leave_type", nullable = false, length = 20)
    private LeaveType leaveType;

    @Column(name = "year", nullable = false)
    private int year;

    @Column(name = "total_days", nullable = false)
    private int totalDays;

    @Column(name = "used_days", nullable = false)
    private int usedDays;

    @Column(name = "pending_days", nullable = false)
    private int pendingDays;

    protected LeaveBalance() {}

    public LeaveBalance(UUID id, String tenantId, UUID employeeId, LeaveType leaveType,
                        int year, int totalDays, int usedDays, int pendingDays) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.leaveType = leaveType;
        this.year = year;
        this.totalDays = totalDays;
        this.usedDays = usedDays;
        this.pendingDays = pendingDays;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LeaveType getLeaveType() { return leaveType; }
    public int getYear() { return year; }
    public int getTotalDays() { return totalDays; }
    public int getUsedDays() { return usedDays; }
    public int getPendingDays() { return pendingDays; }
}
```

- [ ] **Step 4: Create Holiday entity**

```java
package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "holiday")
public class Holiday extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "description")
    private String description;

    @Column(name = "is_recurring_yearly", nullable = false)
    private boolean recurringYearly;

    protected Holiday() {}

    public Holiday(UUID id, String tenantId, String name, LocalDate date, String description, boolean recurringYearly) {
        this.id = id;
        this.tenantId = tenantId;
        this.name = name;
        this.date = date;
        this.description = description;
        this.recurringYearly = recurringYearly;
    }

    public UUID getId() { return id; }
    public String getName() { return name; }
    public LocalDate getDate() { return date; }
    public String getDescription() { return description; }
    public boolean isRecurringYearly() { return recurringYearly; }
}
```

- [ ] **Step 5: Create OvertimeRecord entity**

```java
package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "overtime_record")
public class OvertimeRecord extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "hours", nullable = false, precision = 4, scale = 1)
    private BigDecimal hours;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private OvertimeStatus status;

    protected OvertimeRecord() {}

    public OvertimeRecord(UUID id, String tenantId, UUID employeeId, LocalDate date, BigDecimal hours, OvertimeStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.date = date;
        this.hours = hours;
        this.status = status;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LocalDate getDate() { return date; }
    public BigDecimal getHours() { return hours; }
    public OvertimeStatus getStatus() { return status; }

    public void approve() { this.status = OvertimeStatus.APPROVED; }
    public void reject() { this.status = OvertimeStatus.REJECTED; }
}
```

- [ ] **Step 6: Create repositories**

```java
package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.LeaveBalance;
import com.company.hrms.attendance.domain.LeaveType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface LeaveBalanceRepository extends JpaRepository<LeaveBalance, UUID> {
    List<LeaveBalance> findByTenantIdAndEmployeeIdAndYear(String tenantId, UUID employeeId, int year);
    Optional<LeaveBalance> findByTenantIdAndEmployeeIdAndLeaveTypeAndYear(String tenantId, UUID employeeId, LeaveType leaveType, int year);
}
```

```java
package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.Holiday;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface HolidayRepository extends JpaRepository<Holiday, UUID> {
    List<Holiday> findByTenantIdOrderByDateAsc(String tenantId);
}
```

```java
package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.OvertimeRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface OvertimeRecordRepository extends JpaRepository<OvertimeRecord, UUID> {
    Page<OvertimeRecord> findByTenantId(String tenantId, Pageable pageable);
    List<OvertimeRecord> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId);
}
```

- [ ] **Step 7: Update LeaveRequest with new fields**

Replace LeaveRequest.java:

```java
package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "leave_request")
public class LeaveRequest extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "from_date", nullable = false)
    private LocalDate fromDate;

    @Column(name = "to_date", nullable = false)
    private LocalDate toDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "leave_type", nullable = false, length = 20)
    private LeaveType leaveType;

    @Column(name = "reason")
    private String reason;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private LeaveStatus status;

    @Column(name = "approved_by")
    private UUID approvedBy;

    protected LeaveRequest() {
    }

    public LeaveRequest(UUID id, String tenantId, UUID employeeId, LocalDate fromDate, LocalDate toDate,
                        LeaveType leaveType, String reason, LeaveStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.leaveType = leaveType;
        this.reason = reason;
        this.status = status;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LocalDate getFromDate() { return fromDate; }
    public LocalDate getToDate() { return toDate; }
    public LeaveType getLeaveType() { return leaveType; }
    public String getReason() { return reason; }
    public LeaveStatus getStatus() { return status; }
    public UUID getApprovedBy() { return approvedBy; }

    public void approve() { this.status = LeaveStatus.APPROVED; }
    public void reject() { this.status = LeaveStatus.REJECTED; }
    public void setApprovedBy(UUID approvedBy) { this.approvedBy = approvedBy; }
}
```

- [ ] **Step 8: Verify compilation**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd compile
```
Expected: PASS

- [ ] **Step 9: Commit**

```bash
git add src/main/java/com/company/hrms/attendance/
git commit -m "feat: add leave balance, holiday, overtime entities and extend leave request"
```

### Task 15: Update AttendanceService and Controller

**Files:**
- Modify: `src/main/java/com/company/hrms/attendance/application/AttendanceService.java:1-75`
- Modify: `src/main/java/com/company/hrms/attendance/interfaces/api/AttendanceController.java:1-77`
- Modify: `src/main/java/com/company/hrms/attendance/infrastructure/LeaveRequestRepository.java`

- [ ] **Step 1: Update LeaveRequestRepository**

Add to `LeaveRequestRepository`:

```java
long countByTenantIdAndEmployeeIdAndLeaveTypeAndStatus(String tenantId, UUID employeeId, LeaveType leaveType, LeaveStatus status);

long countByTenantIdAndEmployeeIdAndLeaveTypeAndStatusAndFromDateBetween(String tenantId, UUID employeeId, LeaveType leaveType, LeaveStatus status, LocalDate start, LocalDate end);
```

- [ ] **Step 2: Update AttendanceService**

Replace `AttendanceService.java`:

```java
package com.company.hrms.attendance.application;

import com.company.hrms.attendance.domain.*;
import com.company.hrms.attendance.infrastructure.*;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
public class AttendanceService {
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveBalanceRepository leaveBalanceRepository;
    private final HolidayRepository holidayRepository;
    private final OvertimeRecordRepository overtimeRecordRepository;

    public AttendanceService(LeaveRequestRepository leaveRequestRepository,
                             LeaveBalanceRepository leaveBalanceRepository,
                             HolidayRepository holidayRepository,
                             OvertimeRecordRepository overtimeRecordRepository) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveBalanceRepository = leaveBalanceRepository;
        this.holidayRepository = holidayRepository;
        this.overtimeRecordRepository = overtimeRecordRepository;
    }

    @Transactional
    public LeaveRequest createLeaveRequest(UUID employeeId, LocalDate fromDate, LocalDate toDate,
                                            LeaveType leaveType, String reason) {
        LeaveRequest leaveRequest = new LeaveRequest(
            UUID.randomUUID(), TenantContext.get(), employeeId, fromDate, toDate,
            leaveType, reason, LeaveStatus.PENDING
        );
        return leaveRequestRepository.save(leaveRequest);
    }

    @Transactional
    public LeaveRequest approve(UUID leaveId) {
        LeaveRequest leaveRequest = findLeaveByIdScoped(leaveId);
        leaveRequest.approve();
        return leaveRequest;
    }

    @Transactional
    public LeaveRequest reject(UUID leaveId) {
        LeaveRequest leaveRequest = findLeaveByIdScoped(leaveId);
        leaveRequest.reject();
        return leaveRequest;
    }

    @Transactional(readOnly = true)
    public Page<LeaveRequest> list(String status, Pageable pageable) {
        String tenantId = TenantContext.get();
        String normalizedStatus = status == null ? null : status.trim();
        if (normalizedStatus == null || normalizedStatus.isEmpty()) {
            return leaveRequestRepository.findAllByTenantId(tenantId, pageable);
        }
        return leaveRequestRepository.findByTenantIdAndStatus(tenantId, parseLeaveStatus(normalizedStatus), pageable);
    }

    @Transactional(readOnly = true)
    public List<LeaveBalance> getLeaveBalances(UUID employeeId) {
        return leaveBalanceRepository.findByTenantIdAndEmployeeIdAndYear(TenantContext.get(), employeeId, LocalDate.now().getYear());
    }

    @Transactional(readOnly = true)
    public List<Holiday> getHolidays() {
        return holidayRepository.findByTenantIdOrderByDateAsc(TenantContext.get());
    }

    @Transactional(readOnly = true)
    public Page<OvertimeRecord> listOvertime(Pageable pageable) {
        return overtimeRecordRepository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional
    public OvertimeRecord approveOvertime(UUID overtimeId) {
        OvertimeRecord record = overtimeRecordRepository.findById(overtimeId)
            .orElseThrow(() -> new NotFoundException("OVERTIME_NOT_FOUND"));
        record.approve();
        return record;
    }

    @Transactional
    public OvertimeRecord rejectOvertime(UUID overtimeId) {
        OvertimeRecord record = overtimeRecordRepository.findById(overtimeId)
            .orElseThrow(() -> new NotFoundException("OVERTIME_NOT_FOUND"));
        record.reject();
        return record;
    }

    private LeaveRequest findLeaveByIdScoped(UUID leaveId) {
        return leaveRequestRepository.findByIdAndTenantId(leaveId, TenantContext.get())
            .orElseThrow(() -> new NotFoundException("LEAVE_NOT_FOUND"));
    }

    private static LeaveStatus parseLeaveStatus(String status) {
        try {
            return LeaveStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_LEAVE_STATUS");
        }
    }
}
```

- [ ] **Step 3: Update AttendanceController**

Replace `AttendanceController.java`:

```java
package com.company.hrms.attendance.interfaces.api;

import com.company.hrms.attendance.application.AttendanceService;
import com.company.hrms.attendance.domain.*;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
@Validated
public class AttendanceController {
    private final AttendanceService attendanceService;

    public AttendanceController(AttendanceService attendanceService) {
        this.attendanceService = attendanceService;
    }

    @GetMapping("/leave-requests")
    @PreAuthorize("hasAuthority('leave:read')")
    public PageResponse<LeaveResponse> list(@RequestParam(required = false) String status, Pageable pageable) {
        return PageResponse.from(
            attendanceService.list(status, pageable).map(AttendanceController::toResponse));
    }

    @PostMapping("/leave-requests")
    @PreAuthorize("hasAuthority('leave:create')")
    public LeaveResponse create(@RequestBody CreateLeaveRequest request) {
        LeaveRequest lr = attendanceService.createLeaveRequest(
            request.employeeId(), request.fromDate(), request.toDate(),
            request.leaveType() != null ? request.leaveType() : LeaveType.ANNUAL,
            request.reason());
        return toResponse(lr);
    }

    @PostMapping("/leave-requests/{id}/approve")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse approve(@PathVariable UUID id) {
        return toResponse(attendanceService.approve(id));
    }

    @PostMapping("/leave-requests/{id}/reject")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse reject(@PathVariable UUID id) {
        return toResponse(attendanceService.reject(id));
    }

    @GetMapping("/leave-balances")
    @PreAuthorize("hasAuthority('leave:read')")
    public List<LeaveBalanceResponse> balances(@RequestParam UUID employeeId) {
        return attendanceService.getLeaveBalances(employeeId).stream()
            .map(lb -> new LeaveBalanceResponse(lb.getId(), lb.getEmployeeId(), lb.getLeaveType().name(),
                lb.getYear(), lb.getTotalDays(), lb.getUsedDays(), lb.getPendingDays()))
            .toList();
    }

    @GetMapping("/holidays")
    @PreAuthorize("hasAuthority('leave:read')")
    public List<HolidayResponse> holidays() {
        return attendanceService.getHolidays().stream()
            .map(h -> new HolidayResponse(h.getId(), h.getName(), h.getDate(), h.getDescription(), h.isRecurringYearly()))
            .toList();
    }

    @GetMapping("/overtime")
    @PreAuthorize("hasAuthority('leave:read')")
    public PageResponse<OvertimeResponse> listOvertime(Pageable pageable) {
        return PageResponse.from(
            attendanceService.listOvertime(pageable)
                .map(r -> new OvertimeResponse(r.getId(), r.getEmployeeId(), r.getDate(), r.getHours(), r.getStatus().name())));
    }

    @PostMapping("/overtime/{id}/approve")
    @PreAuthorize("hasAuthority('leave:approve')")
    public OvertimeResponse approveOvertime(@PathVariable UUID id) {
        OvertimeRecord r = attendanceService.approveOvertime(id);
        return new OvertimeResponse(r.getId(), r.getEmployeeId(), r.getDate(), r.getHours(), r.getStatus().name());
    }

    @PostMapping("/overtime/{id}/reject")
    @PreAuthorize("hasAuthority('leave:approve')")
    public OvertimeResponse rejectOvertime(@PathVariable UUID id) {
        OvertimeRecord r = attendanceService.rejectOvertime(id);
        return new OvertimeResponse(r.getId(), r.getEmployeeId(), r.getDate(), r.getHours(), r.getStatus().name());
    }

    private static LeaveResponse toResponse(LeaveRequest lr) {
        return new LeaveResponse(lr.getId(), lr.getEmployeeId(), lr.getFromDate(), lr.getToDate(),
            lr.getLeaveType().name(), lr.getReason(), lr.getStatus().name(), lr.getApprovedBy());
    }

    public record CreateLeaveRequest(@NotNull UUID employeeId, @NotNull LocalDate fromDate,
                                     @NotNull LocalDate toDate, LeaveType leaveType, String reason) {}

    public record LeaveResponse(UUID id, UUID employeeId, LocalDate fromDate, LocalDate toDate,
                                String leaveType, String reason, String status, UUID approvedBy) {}

    public record LeaveBalanceResponse(UUID id, UUID employeeId, String leaveType, int year,
                                       int totalDays, int usedDays, int pendingDays) {}

    public record HolidayResponse(UUID id, String name, LocalDate date, String description, boolean recurringYearly) {}

    public record OvertimeResponse(UUID id, UUID employeeId, LocalDate date, BigDecimal hours, String status) {}
}
```

- [ ] **Step 4: Commit**

```bash
git add src/main/java/com/company/hrms/attendance/
git commit -m "feat: extend attendance service and controller with leave balances, holidays, overtime"
```

---

## Phase 4: Payroll Module Extension

### Task 16: DB Migration V15 — Create salary_structure and payslip tables

**Files:**
- Create: `src/main/resources/db/migration/V15__create_salary_structure_payslip.sql`

- [ ] **Step 1: Write migration**

```sql
CREATE TABLE IF NOT EXISTS salary_structure (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  basic_salary numeric(15, 2) NOT NULL,
  allowance numeric(15, 2) NOT NULL DEFAULT 0,
  deduction numeric(15, 2) NOT NULL DEFAULT 0,
  effective_from date NOT NULL,
  effective_to date,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS payslip (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  payroll_run_id uuid NOT NULL REFERENCES payroll_run(id),
  employee_id uuid NOT NULL REFERENCES employee(id),
  basic_salary numeric(15, 2) NOT NULL,
  allowance numeric(15, 2) NOT NULL DEFAULT 0,
  deduction numeric(15, 2) NOT NULL DEFAULT 0,
  overtime_pay numeric(15, 2) NOT NULL DEFAULT 0,
  net_pay numeric(15, 2) NOT NULL,
  issued_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  UNIQUE (payroll_run_id, employee_id)
);
```

- [ ] **Step 2: Verify migration**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/main/resources/db/migration/V15__create_salary_structure_payslip.sql
git commit -m "feat: add salary_structure and payslip tables"
```

### Task 17: Create SalaryStructure and Payslip entities and repositories

**Files:**
- Create: `src/main/java/com/company/hrms/payroll/domain/SalaryStructure.java`
- Create: `src/main/java/com/company/hrms/payroll/domain/Payslip.java`
- Create: `src/main/java/com/company/hrms/payroll/infrastructure/SalaryStructureRepository.java`
- Create: `src/main/java/com/company/hrms/payroll/infrastructure/PayslipRepository.java`

- [ ] **Step 1: Create SalaryStructure entity**

```java
package com.company.hrms.payroll.domain;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "salary_structure")
public class SalaryStructure extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "basic_salary", nullable = false, precision = 15, scale = 2)
    private BigDecimal basicSalary;

    @Column(name = "allowance", nullable = false, precision = 15, scale = 2)
    private BigDecimal allowance;

    @Column(name = "deduction", nullable = false, precision = 15, scale = 2)
    private BigDecimal deduction;

    @Column(name = "effective_from", nullable = false)
    private LocalDate effectiveFrom;

    @Column(name = "effective_to")
    private LocalDate effectiveTo;

    protected SalaryStructure() {}

    public SalaryStructure(UUID id, String tenantId, Employee employee, BigDecimal basicSalary,
                           BigDecimal allowance, BigDecimal deduction, LocalDate effectiveFrom, LocalDate effectiveTo) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.basicSalary = basicSalary;
        this.allowance = allowance;
        this.deduction = deduction;
        this.effectiveFrom = effectiveFrom;
        this.effectiveTo = effectiveTo;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public BigDecimal getBasicSalary() { return basicSalary; }
    public BigDecimal getAllowance() { return allowance; }
    public BigDecimal getDeduction() { return deduction; }
    public LocalDate getEffectiveFrom() { return effectiveFrom; }
    public LocalDate getEffectiveTo() { return effectiveTo; }
}
```

- [ ] **Step 2: Create Payslip entity**

```java
package com.company.hrms.payroll.domain;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "payslip")
public class Payslip extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "payroll_run_id", nullable = false)
    private PayrollRun payrollRun;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "basic_salary", nullable = false, precision = 15, scale = 2)
    private BigDecimal basicSalary;

    @Column(name = "allowance", nullable = false, precision = 15, scale = 2)
    private BigDecimal allowance;

    @Column(name = "deduction", nullable = false, precision = 15, scale = 2)
    private BigDecimal deduction;

    @Column(name = "overtime_pay", nullable = false, precision = 15, scale = 2)
    private BigDecimal overtimePay;

    @Column(name = "net_pay", nullable = false, precision = 15, scale = 2)
    private BigDecimal netPay;

    @Column(name = "issued_at")
    private Instant issuedAt;

    protected Payslip() {}

    public Payslip(UUID id, String tenantId, PayrollRun payrollRun, Employee employee,
                   BigDecimal basicSalary, BigDecimal allowance, BigDecimal deduction,
                   BigDecimal overtimePay, BigDecimal netPay) {
        this.id = id;
        this.tenantId = tenantId;
        this.payrollRun = payrollRun;
        this.employee = employee;
        this.basicSalary = basicSalary;
        this.allowance = allowance;
        this.deduction = deduction;
        this.overtimePay = overtimePay;
        this.netPay = netPay;
        this.issuedAt = Instant.now();
    }

    public UUID getId() { return id; }
    public PayrollRun getPayrollRun() { return payrollRun; }
    public Employee getEmployee() { return employee; }
    public BigDecimal getBasicSalary() { return basicSalary; }
    public BigDecimal getAllowance() { return allowance; }
    public BigDecimal getDeduction() { return deduction; }
    public BigDecimal getOvertimePay() { return overtimePay; }
    public BigDecimal getNetPay() { return netPay; }
    public Instant getIssuedAt() { return issuedAt; }
}
```

- [ ] **Step 3: Create repositories**

```java
package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.SalaryStructure;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SalaryStructureRepository extends JpaRepository<SalaryStructure, UUID> {
    List<SalaryStructure> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
    Optional<SalaryStructure> findTopByTenantIdAndEmployee_IdOrderByEffectiveFromDesc(String tenantId, UUID employeeId);
}
```

```java
package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.Payslip;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PayslipRepository extends JpaRepository<Payslip, UUID> {
    Page<Payslip> findByTenantIdAndPayrollRun_Id(String tenantId, UUID payrollRunId, Pageable pageable);
    List<Payslip> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
```

- [ ] **Step 4: Commit**

```bash
git add src/main/java/com/company/hrms/payroll/
git commit -m "feat: add SalaryStructure and Payslip entities with repositories"
```

### Task 18: Extend PayrollController with payslip endpoints

**Files:**
- Modify: `src/main/java/com/company/hrms/payroll/application/PayrollService.java:1-69`
- Modify: `src/main/java/com/company/hrms/payroll/interfaces/api/PayrollController.java:1-79`

- [ ] **Step 1: Extend PayrollService with payslip query**

Add to `PayrollService.java`:

Add fields:
```java
private final PayslipRepository payslipRepository;
```

Update constructor to include `PayslipRepository payslipRepository`.

Add methods before the closing `}`:
```java
@Transactional(readOnly = true)
public Page<Payslip> listPayslips(UUID runId, Pageable pageable) {
    return payslipRepository.findByTenantIdAndPayrollRun_Id(TenantContext.get(), runId, pageable);
}

@Transactional(readOnly = true)
public List<Payslip> getEmployeePayslips(UUID employeeId) {
    return payslipRepository.findByTenantIdAndEmployee_Id(TenantContext.get(), employeeId);
}
```

- [ ] **Step 2: Add payslip endpoints to PayrollController**

Add before the closing `}`:

```java
@GetMapping("/payroll-runs/{runId}/payslips")
@PreAuthorize("hasAuthority('payroll:read')")
public PageResponse<PayslipResponse> listPayslips(@PathVariable UUID runId, Pageable pageable) {
    return PageResponse.from(
        payrollService.listPayslips(runId, pageable)
            .map(p -> new PayslipResponse(p.getId(), p.getBasicSalary(), p.getAllowance(),
                p.getDeduction(), p.getOvertimePay(), p.getNetPay(), p.getIssuedAt()))
    );
}

public record PayslipResponse(UUID id, BigDecimal basicSalary, BigDecimal allowance,
                               BigDecimal deduction, BigDecimal overtimePay, BigDecimal netPay,
                               Instant issuedAt) {}
```

- [ ] **Step 3: Commit**

```bash
git add src/main/java/com/company/hrms/payroll/
git commit -m "feat: add payslip query endpoints to payroll module"
```

---

## Phase 5: Performance Module (New)

### Task 19: DB Migration V16 — Create performance tables

**Files:**
- Create: `src/main/resources/db/migration/V16__create_performance_tables.sql`

- [ ] **Step 1: Write migration**

```sql
CREATE TABLE IF NOT EXISTS appraisal_cycle (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  name varchar(255) NOT NULL,
  cycle_type varchar(20) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'DRAFT',
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS performance_review (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  cycle_id uuid NOT NULL REFERENCES appraisal_cycle(id),
  employee_id uuid NOT NULL REFERENCES employee(id),
  reviewer_type varchar(20) NOT NULL,
  reviewer_id uuid,
  overall_score numeric(4, 1),
  strengths text,
  improvements text,
  status varchar(20) NOT NULL DEFAULT 'DRAFT',
  submitted_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE IF NOT EXISTS kpi (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  employee_id uuid NOT NULL REFERENCES employee(id),
  cycle_id uuid NOT NULL REFERENCES appraisal_cycle(id),
  title varchar(255) NOT NULL,
  description text,
  target_score numeric(4, 1) NOT NULL DEFAULT 100,
  actual_score numeric(4, 1),
  weight numeric(4, 1) NOT NULL DEFAULT 20,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);
```

- [ ] **Step 2: Verify migration**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/main/resources/db/migration/V16__create_performance_tables.sql
git commit -m "feat: add appraisal_cycle, performance_review, kpi tables"
```

### Task 20: Create Performance module entities and enums

**Files:**
- Create: `src/main/java/com/company/hrms/performance/package-info.java`
- Create: `src/main/java/com/company/hrms/performance/domain/CycleType.java`
- Create: `src/main/java/com/company/hrms/performance/domain/CycleStatus.java`
- Create: `src/main/java/com/company/hrms/performance/domain/ReviewerType.java`
- Create: `src/main/java/com/company/hrms/performance/domain/ReviewStatus.java`
- Create: `src/main/java/com/company/hrms/performance/domain/AppraisalCycle.java`
- Create: `src/main/java/com/company/hrms/performance/domain/PerformanceReview.java`
- Create: `src/main/java/com/company/hrms/performance/domain/KPI.java`

- [ ] **Step 1: Create package-info.java**

```java
@org.springframework.modulith.ApplicationModule(displayName = "Performance")
package com.company.hrms.performance;
```

- [ ] **Step 2: Create enums**

```java
package com.company.hrms.performance.domain;

public enum CycleType { Q1, H1, YEARLY }
```

```java
package com.company.hrms.performance.domain;

public enum CycleStatus { DRAFT, ACTIVE, COMPLETED }
```

```java
package com.company.hrms.performance.domain;

public enum ReviewerType { SELF, MANAGER }
```

```java
package com.company.hrms.performance.domain;

public enum ReviewStatus { DRAFT, SUBMITTED, REVIEWED, FINALIZED }
```

- [ ] **Step 3: Create AppraisalCycle entity**

```java
package com.company.hrms.performance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "appraisal_cycle")
public class AppraisalCycle extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "cycle_type", nullable = false, length = 20)
    private CycleType cycleType;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private CycleStatus status;

    protected AppraisalCycle() {}

    public AppraisalCycle(UUID id, String tenantId, String name, CycleType cycleType,
                          LocalDate startDate, LocalDate endDate, CycleStatus status) {
        this.id = id;
        this.tenantId = tenantId;
        this.name = name;
        this.cycleType = cycleType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public UUID getId() { return id; }
    public String getName() { return name; }
    public CycleType getCycleType() { return cycleType; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public CycleStatus getStatus() { return status; }
}
```

- [ ] **Step 4: Create PerformanceReview entity**

```java
package com.company.hrms.performance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "performance_review")
public class PerformanceReview extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "cycle_id", nullable = false)
    private AppraisalCycle cycle;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Enumerated(EnumType.STRING)
    @Column(name = "reviewer_type", nullable = false, length = 20)
    private ReviewerType reviewerType;

    @Column(name = "reviewer_id")
    private UUID reviewerId;

    @Column(name = "overall_score", precision = 4, scale = 1)
    private BigDecimal overallScore;

    @Column(name = "strengths")
    private String strengths;

    @Column(name = "improvements")
    private String improvements;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private ReviewStatus status;

    @Column(name = "submitted_at")
    private Instant submittedAt;

    protected PerformanceReview() {}

    public PerformanceReview(UUID id, String tenantId, AppraisalCycle cycle, UUID employeeId,
                             ReviewerType reviewerType, UUID reviewerId) {
        this.id = id;
        this.tenantId = tenantId;
        this.cycle = cycle;
        this.employeeId = employeeId;
        this.reviewerType = reviewerType;
        this.reviewerId = reviewerId;
        this.status = ReviewStatus.DRAFT;
    }

    public UUID getId() { return id; }
    public AppraisalCycle getCycle() { return cycle; }
    public UUID getEmployeeId() { return employeeId; }
    public ReviewerType getReviewerType() { return reviewerType; }
    public UUID getReviewerId() { return reviewerId; }
    public BigDecimal getOverallScore() { return overallScore; }
    public String getStrengths() { return strengths; }
    public String getImprovements() { return improvements; }
    public ReviewStatus getStatus() { return status; }
    public Instant getSubmittedAt() { return submittedAt; }
}
```

- [ ] **Step 5: Create KPI entity**

```java
package com.company.hrms.performance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "kpi")
public class KPI extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "cycle_id", nullable = false)
    private AppraisalCycle cycle;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "target_score", nullable = false, precision = 4, scale = 1)
    private BigDecimal targetScore;

    @Column(name = "actual_score", precision = 4, scale = 1)
    private BigDecimal actualScore;

    @Column(name = "weight", nullable = false, precision = 4, scale = 1)
    private BigDecimal weight;

    protected KPI() {}

    public KPI(UUID id, String tenantId, UUID employeeId, AppraisalCycle cycle,
               String title, String description, BigDecimal targetScore, BigDecimal weight) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeId = employeeId;
        this.cycle = cycle;
        this.title = title;
        this.description = description;
        this.targetScore = targetScore;
        this.weight = weight;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public AppraisalCycle getCycle() { return cycle; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public BigDecimal getTargetScore() { return targetScore; }
    public BigDecimal getActualScore() { return actualScore; }
    public BigDecimal getWeight() { return weight; }
}
```

- [ ] **Step 6: Create repositories**

```java
package com.company.hrms.performance.infrastructure;

import com.company.hrms.performance.domain.AppraisalCycle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface AppraisalCycleRepository extends JpaRepository<AppraisalCycle, UUID> {
    Page<AppraisalCycle> findByTenantIdOrderByStartDateDesc(String tenantId, Pageable pageable);
}
```

```java
package com.company.hrms.performance.infrastructure;

import com.company.hrms.performance.domain.PerformanceReview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface PerformanceReviewRepository extends JpaRepository<PerformanceReview, UUID> {
    List<PerformanceReview> findByTenantIdAndCycle_Id(String tenantId, UUID cycleId);
    List<PerformanceReview> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId);
}
```

```java
package com.company.hrms.performance.infrastructure;

import com.company.hrms.performance.domain.KPI;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface KPIRepository extends JpaRepository<KPI, UUID> {
    List<KPI> findByTenantIdAndCycle_Id(String tenantId, UUID cycleId);
    List<KPI> findByTenantIdAndEmployeeIdAndCycle_Id(String tenantId, UUID employeeId, UUID cycleId);
}
```

- [ ] **Step 7: Commit**

```bash
git add src/main/java/com/company/hrms/performance/
git commit -m "feat: add performance module entities and repositories"
```

### Task 21: Create PerformanceService and PerformanceController

**Files:**
- Create: `src/main/java/com/company/hrms/performance/application/PerformanceService.java`
- Create: `src/main/java/com/company/hrms/performance/interfaces/api/PerformanceController.java`

- [ ] **Step 1: Create PerformanceService**

```java
package com.company.hrms.performance.application;

import com.company.hrms.performance.domain.*;
import com.company.hrms.performance.infrastructure.*;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class PerformanceService {
    private final AppraisalCycleRepository cycleRepository;
    private final PerformanceReviewRepository reviewRepository;
    private final KPIRepository kpiRepository;

    public PerformanceService(AppraisalCycleRepository cycleRepository,
                              PerformanceReviewRepository reviewRepository,
                              KPIRepository kpiRepository) {
        this.cycleRepository = cycleRepository;
        this.reviewRepository = reviewRepository;
        this.kpiRepository = kpiRepository;
    }

    @Transactional(readOnly = true)
    public Page<AppraisalCycle> listCycles(Pageable pageable) {
        return cycleRepository.findByTenantIdOrderByStartDateDesc(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public List<PerformanceReview> listReviewsByCycle(UUID cycleId) {
        return reviewRepository.findByTenantIdAndCycle_Id(TenantContext.get(), cycleId);
    }

    @Transactional(readOnly = true)
    public List<PerformanceReview> listReviewsByEmployee(UUID employeeId) {
        return reviewRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId);
    }

    @Transactional(readOnly = true)
    public List<KPI> listKPIs(UUID cycleId) {
        return kpiRepository.findByTenantIdAndCycle_Id(TenantContext.get(), cycleId);
    }

    @Transactional(readOnly = true)
    public List<KPI> listKPIsByEmployee(UUID employeeId, UUID cycleId) {
        return kpiRepository.findByTenantIdAndEmployeeIdAndCycle_Id(TenantContext.get(), employeeId, cycleId);
    }

    @Transactional(readOnly = true)
    public AppraisalCycle getCycleById(UUID id) {
        return cycleRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("CYCLE_NOT_FOUND"));
    }
}
```

- [ ] **Step 2: Create PerformanceController**

```java
package com.company.hrms.performance.interfaces.api;

import com.company.hrms.performance.application.PerformanceService;
import com.company.hrms.performance.domain.*;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/performance")
public class PerformanceController {
    private final PerformanceService performanceService;

    public PerformanceController(PerformanceService performanceService) {
        this.performanceService = performanceService;
    }

    @GetMapping("/cycles")
    @PreAuthorize("hasAuthority('performance:read')")
    public PageResponse<CycleResponse> listCycles(Pageable pageable) {
        return PageResponse.from(performanceService.listCycles(pageable)
            .map(c -> new CycleResponse(c.getId(), c.getName(), c.getCycleType().name(),
                c.getStartDate(), c.getEndDate(), c.getStatus().name())));
    }

    @GetMapping("/cycles/{cycleId}/reviews")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<ReviewResponse> listReviews(@PathVariable UUID cycleId) {
        return performanceService.listReviewsByCycle(cycleId).stream()
            .map(r -> new ReviewResponse(r.getId(), r.getCycle().getId(), r.getEmployeeId(),
                r.getReviewerType().name(), r.getReviewerId(), r.getOverallScore(),
                r.getStrengths(), r.getImprovements(), r.getStatus().name(), r.getSubmittedAt()))
            .toList();
    }

    @GetMapping("/cycles/{cycleId}/kpis")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<KPIResponse> listKPIs(@PathVariable UUID cycleId) {
        return performanceService.listKPIs(cycleId).stream()
            .map(k -> new KPIResponse(k.getId(), k.getEmployeeId(), k.getCycle().getId(),
                k.getTitle(), k.getDescription(), k.getTargetScore(), k.getActualScore(), k.getWeight()))
            .toList();
    }

    @GetMapping("/employees/{employeeId}/reviews")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<ReviewResponse> listEmployeeReviews(@PathVariable UUID employeeId) {
        return performanceService.listReviewsByEmployee(employeeId).stream()
            .map(r -> new ReviewResponse(r.getId(), r.getCycle().getId(), r.getEmployeeId(),
                r.getReviewerType().name(), r.getReviewerId(), r.getOverallScore(),
                r.getStrengths(), r.getImprovements(), r.getStatus().name(), r.getSubmittedAt()))
            .toList();
    }

    public record CycleResponse(UUID id, String name, String cycleType,
                                LocalDate startDate, LocalDate endDate, String status) {}

    public record ReviewResponse(UUID id, UUID cycleId, UUID employeeId, String reviewerType,
                                  UUID reviewerId, BigDecimal overallScore,
                                  String strengths, String improvements,
                                  String status, Instant submittedAt) {}

    public record KPIResponse(UUID id, UUID employeeId, UUID cycleId, String title,
                               String description, BigDecimal targetScore,
                               BigDecimal actualScore, BigDecimal weight) {}
}
```

- [ ] **Step 3: Commit**

```bash
git add src/main/java/com/company/hrms/performance/application/ src/main/java/com/company/hrms/performance/interfaces/
git commit -m "feat: add performance service and controller"
```

---

## Phase 6: Employee Self-Service Module

### Task 22: Create Self-Service module with controller

**Files:**
- Create: `src/main/java/com/company/hrms/selfservice/package-info.java`
- Create: `src/main/java/com/company/hrms/selfservice/interfaces/api/SelfServiceController.java`

- [ ] **Step 1: Create package-info.java**

```java
@org.springframework.modulith.ApplicationModule(displayName = "Self-Service")
package com.company.hrms.selfservice;
```

- [ ] **Step 2: Create SelfServiceController**

```java
package com.company.hrms.selfservice.interfaces.api;

import com.company.hrms.attendance.application.AttendanceService;
import com.company.hrms.attendance.domain.*;
import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.payroll.application.PayrollService;
import com.company.hrms.payroll.domain.Payslip;
import com.company.hrms.performance.application.PerformanceService;
import com.company.hrms.performance.domain.KPI;
import com.company.hrms.performance.domain.PerformanceReview;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/self")
@PreAuthorize("hasAuthority('self:access')")
public class SelfServiceController {
    private final EmployeeService employeeService;
    private final AttendanceService attendanceService;
    private final PayrollService payrollService;
    private final PerformanceService performanceService;

    public SelfServiceController(EmployeeService employeeService, AttendanceService attendanceService,
                                  PayrollService payrollService, PerformanceService performanceService) {
        this.employeeService = employeeService;
        this.attendanceService = attendanceService;
        this.payrollService = payrollService;
        this.performanceService = performanceService;
    }

    @GetMapping("/profile")
    public ProfileResponse profile() {
        // In real auth flow, employeeId comes from JWT subject. For dev, use header.
        // This controller delegates to existing services; actual employee resolution is deferred.
        return null; // Will be populated when auth integration is done
    }

    @GetMapping("/leave-balances")
    public List<?> leaveBalances(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return attendanceService.getLeaveBalances(employeeId).stream()
            .map(lb -> new LeaveBalanceDto(lb.getLeaveType().name(), lb.getTotalDays(), lb.getUsedDays(), lb.getPendingDays()))
            .toList();
    }

    @PostMapping("/leave-requests")
    public Object createLeave(@RequestHeader("X-Employee-Id") UUID employeeId,
                               @RequestBody CreateSelfLeaveRequest request) {
        LeaveRequest lr = attendanceService.createLeaveRequest(employeeId, request.fromDate(), request.toDate(),
            request.leaveType() != null ? request.leaveType() : LeaveType.ANNUAL, request.reason());
        return new LeaveDto(lr.getId(), lr.getLeaveType().name(), lr.getFromDate(), lr.getToDate(), lr.getStatus().name());
    }

    @GetMapping("/payslips")
    public List<?> payslips(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return payrollService.getEmployeePayslips(employeeId).stream()
            .map(p -> new PayslipDto(p.getId(), p.getBasicSalary(), p.getAllowance(), p.getDeduction(),
                p.getOvertimePay(), p.getNetPay(), p.getIssuedAt()))
            .toList();
    }

    @GetMapping("/reviews")
    public List<?> reviews(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return performanceService.listReviewsByEmployee(employeeId).stream()
            .map(r -> new ReviewDto(r.getId(), r.getCycle().getName(), r.getReviewerType().name(),
                r.getOverallScore(), r.getStatus().name()))
            .toList();
    }

    public record CreateSelfLeaveRequest(LocalDate fromDate, LocalDate toDate, LeaveType leaveType, String reason) {}
    public record LeaveBalanceDto(String leaveType, int totalDays, int usedDays, int pendingDays) {}
    public record LeaveDto(UUID id, String leaveType, LocalDate fromDate, LocalDate toDate, String status) {}
    public record PayslipDto(UUID id, BigDecimal basicSalary, BigDecimal allowance, BigDecimal deduction,
                              BigDecimal overtimePay, BigDecimal netPay, Instant issuedAt) {}
    public record ReviewDto(UUID id, String cycleName, String reviewerType, BigDecimal overallScore, String status) {}
}
```

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/selfservice/
git commit -m "feat: add employee self-service module"
```

---

## Phase 7: Security Config Update

### Task 23: Update SecurityConfig with new authorities

**Files:**
- Modify: `src/main/java/com/company/hrms/shared/security/SecurityConfig.java:35-63`

- [ ] **Step 1: Add new authorities to JwtDecoder**

Replace the authorities list in the `jwtDecoder()` method:

```java
@Bean
JwtDecoder jwtDecoder() {
    return token -> Jwt.withTokenValue(token)
        .header("alg", "none")
        .claim("authorities", List.of(
            "dashboard:read",
            "department:read", "department:create", "department:update", "department:delete",
            "employee:read", "employee:create", "employee:update",
            "leave:read", "leave:create", "leave:approve",
            "payroll:read", "payroll:create", "payroll:execute", "payroll:approve",
            "recruitment:read", "recruitment:create", "recruitment:update", "recruitment:convert",
            "performance:read", "performance:create", "performance:update",
            "self:access"))
        .subject("local-user")
        .issuedAt(Instant.now())
        .expiresAt(Instant.now().plusSeconds(3600))
        .build();
}
```

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/shared/security/SecurityConfig.java
git commit -m "feat: add performance and self-service authorities"
```

---

## Phase 8: Reporting Enhancement

### Task 24: Enhance DashboardQueryService with real analytics

**Files:**
- Modify: `src/main/java/com/company/hrms/reporting/application/DashboardQueryService.java:1-60`

- [ ] **Step 1: Add department headcount and payroll summary methods**

Replace the entire `DashboardQueryService.java`:

```java
package com.company.hrms.reporting.application;

import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.infrastructure.LeaveRequestRepository;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.payroll.domain.PayrollPeriodStatus;
import com.company.hrms.payroll.infrastructure.PayrollPeriodRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Service
public class DashboardQueryService {
    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;
    private final PayrollPeriodRepository payrollPeriodRepository;
    private final LeaveRequestRepository leaveRequestRepository;
    private final OutboxEventRepository outboxEventRepository;

    public DashboardQueryService(EmployeeRepository employeeRepository,
                                 DepartmentRepository departmentRepository,
                                 PayrollPeriodRepository payrollPeriodRepository,
                                 LeaveRequestRepository leaveRequestRepository,
                                 OutboxEventRepository outboxEventRepository) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
        this.payrollPeriodRepository = payrollPeriodRepository;
        this.leaveRequestRepository = leaveRequestRepository;
        this.outboxEventRepository = outboxEventRepository;
    }

    @Transactional(readOnly = true)
    public Summary summary() {
        String tenantId = TenantContext.get();
        long employeeCount = employeeRepository.countByTenantId(tenantId);
        long activeEmployeeCount = employeeRepository.countByTenantIdAndEmploymentStatus(tenantId, EmploymentStatus.ACTIVE);
        long departmentCount = departmentRepository.countByTenantId(tenantId);
        long openPeriodCount = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.OPEN);
        long pendingLeaveCount = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
        return new Summary(employeeCount, activeEmployeeCount, departmentCount, openPeriodCount, pendingLeaveCount);
    }

    @Transactional(readOnly = true)
    public List<DepartmentHeadcount> headcountByDepartment() {
        String tenantId = TenantContext.get();
        return departmentRepository.findAllByTenantId(tenantId).stream()
            .map(dept -> {
                long count = employeeRepository.countByTenantIdAndDepartment_Id(tenantId, dept.getId());
                return new DepartmentHeadcount(dept.getId(), dept.getName(), count);
            })
            .toList();
    }

    @Transactional(readOnly = true)
    public List<Activity> activities() {
        String tenantId = TenantContext.get();
        return outboxEventRepository.findTop20ByTenantIdOrderByCreatedAtDesc(tenantId).stream()
            .map(event -> new Activity(event.getEventType(), event.getPayload(), event.getCreatedAt()))
            .toList();
    }

    public record Summary(long totalEmployees, long activeEmployees, long departments,
                          long openPayrollPeriods, long pendingLeaves) {}

    public record DepartmentHeadcount(UUID departmentId, String departmentName, long count) {}

    public record Activity(String type, String message, Instant timestamp) {}
}
```

- [ ] **Step 2: Update EmployeeRepository with new query methods**

Add to `EmployeeRepository`:
```java
long countByTenantIdAndEmploymentStatus(String tenantId, EmploymentStatus status);
```

- [ ] **Step 3: Update DepartmentRepository with findAllByTenantId**

Add to `DepartmentRepository`:
```java
List<Department> findAllByTenantId(String tenantId);
```

- [ ] **Step 4: Update DashboardController**

Replace `DashboardController.java` to add the new endpoint:

Add to the controller before the closing `}`:
```java
@GetMapping("/headcount-by-department")
@PreAuthorize("hasAuthority('dashboard:read')")
public List<DashboardQueryService.DepartmentHeadcount> headcountByDepartment() {
    return dashboardQueryService.headcountByDepartment();
}
```

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/reporting/ src/main/java/com/company/hrms/employee/infrastructure/EmployeeRepository.java src/main/java/com/company/hrms/organization/infrastructure/DepartmentRepository.java
git commit -m "feat: enhance dashboard with department headcount and extended summary"
```

---

## Phase 9: Comprehensive Seed Data

### Task 25: DB Migration V17 — Comprehensive seed data script

**Files:**
- Create: `src/main/resources/db/migration/V17__seed_comprehensive_sample_data.sql`

This is the largest single file. It will seed:
- 20 positions
- ~90 new employees (EMP037-EMP130) with full profiles
- 120 salary structures
- 120 leave balances
- ~250 leave requests
- ~180 overtime records
- 24 payroll periods + runs + 2,880 payslips
- 3 appraisal cycles + reviews + KPIs
- 9 holidays
- ~60K attendance records (generated via SQL function)

Due to file size, this will be a large SQL script. The plan contains the structure; the actual data generation will use SQL loops and deterministic seed formulas.

- [ ] **Step 1: Write V17 seed migration header and positions**

```sql
-- V17: Comprehensive HRMS seed data
-- Seeds positions, employees, contracts, skills, attendance, leave, payroll, performance, holidays

-- Insert 20 positions (one per department)
INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at) VALUES
  ('p0100000-0000-4000-8000-000000000001','default','DIR','Giám đốc','a1000000-0000-4000-8000-000000000001',now(),now()),
  ('p0100000-0000-4000-8000-000000000002','default','MGR','Trưởng phòng','a1000000-0000-4000-8000-000000000001',now(),now()),
  ('p0100000-0000-4000-8000-000000000003','default','STAFF','Chuyên viên','a1000000-0000-4000-8000-000000000001',now(),now()),
  ('p0100000-0000-4000-8000-000000000004','default','JUNIOR','Nhân viên tập sự','a1000000-0000-4000-8000-000000000001',now(),now()),
  ... (continue for all 20 position codes across departments)
ON CONFLICT (tenant_id, code) DO NOTHING;
```

(Full 500+ line SQL will be in the actual file)

- [ ] **Step 2: Run context load test to verify migration applies cleanly**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=HrmsApplicationContextIT
```
Expected: PASS

- [ ] **Step 3: Run DemoSeedDataIT to verify data loads**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=DemoSeedDataIT
```
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add src/main/resources/db/migration/V17__seed_comprehensive_sample_data.sql
git commit -m "feat: add comprehensive Vietnamese HRMS seed data"
```

---

## Phase 10: Frontend Changes

### Task 26: Extend EmployeesPage with new fields

**Files:**
- Modify: `web-admin/src/features/employees/EmployeesPage.tsx`

The page will be extended to:
1. Add `email`, `phone`, `positionTitle` columns to the main table
2. Add tabs (Profile / Contracts / Skills / Emergency Contacts) to the detail drawer
3. Add new form fields to the Create/Edit form (extended profile fields)
4. Call the new `/api/v1/employees/{id}/profile` endpoint for extended updates

This is a large frontend change. The implementation will use Ant Design's `Tabs` component in the detail drawer and extend the form with the new fields grouped logically.

- [ ] **Step 1: Implement the extended EmployeesPage**

Full file change (not shown in full due to plan size — see actual file for complete implementation).

- [ ] **Step 2: Run frontend tests**

```bash
npm --prefix web-admin run test -- --run
```
Expected: PASS

- [ ] **Step 3: Verify frontend builds**

```bash
npm --prefix web-admin run build
```
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add web-admin/src/features/employees/EmployeesPage.tsx web-admin/src/features/employees/EmployeesPage.test.tsx
git commit -m "feat: extend employees page with profile, contract, skill tabs"
```

### Task 27: Extend LeavePage with tabs for balances, holidays, overtime

**Files:**
- Modify: `web-admin/src/features/leave/LeavePage.tsx`

Add Tabs component with: Leave Requests (existing), Leave Balances, Holidays, Overtime Records.

- [ ] **Step 1: Implement the extended LeavePage**

- [ ] **Step 2: Run tests and build**

```bash
npm --prefix web-admin run test -- --run && npm --prefix web-admin run build
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/features/leave/LeavePage.tsx
git commit -m "feat: extend leave page with balances, holidays, overtime tabs"
```

### Task 28: Extend PayrollPage with payslip details

**Files:**
- Modify: `web-admin/src/features/payroll/PayrollPage.tsx`

Add a "Payslips" button in the runs drawer that loads payslips for that run and shows a detail drawer with salary breakdown.

- [ ] **Step 1: Implement the extended PayrollPage**

- [ ] **Step 2: Run tests and build**

```bash
npm --prefix web-admin run test -- --run && npm --prefix web-admin run build
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/features/payroll/PayrollPage.tsx
git commit -m "feat: add payslip detail view to payroll page"
```

### Task 29: Create PerformancePage

**Files:**
- Create: `web-admin/src/features/performance/PerformancePage.tsx`
- Create: `web-admin/src/features/performance/PerformancePage.test.tsx`
- Modify: `web-admin/src/app/router.tsx`

Create a new page with 3 tabs: Appraisal Cycles, My Reviews (by employee), KPIs. Follows the same AppTable + FormDrawer pattern.

- [ ] **Step 1: Create PerformancePage.tsx**

```tsx
// 3-tab page: Cycles list, Reviews by employee, KPIs by cycle
// Uses apiClient to call /api/v1/performance/cycles, /cycles/{id}/reviews, /cycles/{id}/kpis
```

- [ ] **Step 2: Add route to router.tsx**

Add import and route:
```tsx
import PerformancePage from "../features/performance/PerformancePage";

// In children array:
{ path: "performance", element: <PerformancePage /> }
```

- [ ] **Step 3: Run tests and build**

```bash
npm --prefix web-admin run test -- --run && npm --prefix web-admin run build
```
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add web-admin/src/features/performance/ web-admin/src/app/router.tsx
git commit -m "feat: add performance management page"
```

### Task 30: Enhance DashboardPage with real widgets

**Files:**
- Modify: `web-admin/src/features/dashboard/DashboardPage.tsx`

Add stat cards showing:
- Total employees / Active employees / Departments / Pending leaves
- Department headcount bar chart (simple div-based, no extra chart library)
- Recent pending leave requests

- [ ] **Step 1: Implement the enhanced dashboard**

- [ ] **Step 2: Run tests and build**

```bash
npm --prefix web-admin run test -- --run && npm --prefix web-admin run build
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/features/dashboard/DashboardPage.tsx
git commit -m "feat: enhance dashboard with real stat cards and department chart"
```

---

## Phase 11: Test Updates & Verification

### Task 31: Update ModuleBoundariesTest

**Files:**
- Modify: `src/test/java/com/company/hrms/architecture/ModuleBoundariesTest.java:13-23`

- [ ] **Step 1: Already done in Task 4. Verify it passes**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=ModuleBoundariesTest
```
Expected: PASS (9 modules including performance + selfservice)

### Task 32: Update DemoSeedDataIT

**Files:**
- Modify: `src/test/java/com/company/hrms/DemoSeedDataIT.java`

- [ ] **Step 1: Extend test to verify new seed data exists**

Add assertions:
```java
@Test
void seedDataIncludesExtendedEntities() {
    // Verify positions, contracts, skills, leave balances, holidays,
    // overtime, payslips, appraisal cycles exist after migration
}
```

- [ ] **Step 2: Run the test**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test -Dtest=DemoSeedDataIT
```
Expected: PASS

- [ ] **Step 3: Commit**

```bash
git add src/test/java/com/company/hrms/DemoSeedDataIT.java
git commit -m "test: extend seed data test for new entities"
```

### Task 33: Write integration tests for new modules

**Files:**
- Create: `src/test/java/com/company/hrms/performance/PerformanceAdminApiIT.java`
- Create: `src/test/java/com/company/hrms/employee/EmployeeProfileIT.java`
- Create: `src/test/java/com/company/hrms/attendance/LeaveBalanceIT.java`
- Create: `src/test/java/com/company/hrms/attendance/OvertimeApprovalIT.java`
- Create: `src/test/java/com/company/hrms/payroll/PayrollPayslipIT.java`
- Create: `src/test/java/com/company/hrms/payroll/SalaryStructureIT.java`
- Create: `src/test/java/com/company/hrms/selfservice/EmployeeSelfServiceIT.java`

- [ ] **Step 1: Write PerformanceAdminApiIT**

Following the pattern from `EmployeeAdminApiIT`:
```java
@SpringBootTest
@ActiveProfiles("test")
class PerformanceAdminApiIT {
    // Test: list cycles, list reviews by cycle, list kpis by cycle
}
```

- [ ] **Step 2: Write EmployeeProfileIT**

```java
// Test: update extended profile via PUT /api/v1/employees/{id}/profile
// Verify new fields (email, phone, position) are returned
```

- [ ] **Step 3: Write LeaveBalanceIT, OvertimeApprovalIT, PayrollPayslipIT, SalaryStructureIT, EmployeeSelfServiceIT**

Each follows the same MockMvc integration test pattern.

- [ ] **Step 4: Run all integration tests**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test
```
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add src/test/java/com/company/hrms/
git commit -m "test: add integration tests for all new modules"
```

### Task 34: Final verification — full build + tests

- [ ] **Step 1: Run all backend tests**

```bash
.tools/apache-maven-3.9.11/bin/mvn.cmd test
```
Expected: All tests PASS

- [ ] **Step 2: Run all frontend tests**

```bash
npm --prefix web-admin run test -- --run
```
Expected: All tests PASS

- [ ] **Step 3: Build frontend**

```bash
npm --prefix web-admin run build
```
Expected: No errors

- [ ] **Step 4: Start backend and verify health**

```bash
docker compose -f docker/compose.yml up -d
.tools/apache-maven-3.9.11/bin/mvn.cmd spring-boot:run -Dspring-boot.run.profiles=dev
```
Expected: App starts, migrations apply, seed data loads, health endpoint responds

- [ ] **Step 5: Final commit if any fixes**

```bash
git add -A
git commit -m "chore: final verification fixes and polish"
```
