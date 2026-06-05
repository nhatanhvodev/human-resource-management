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

    @Transactional
    public void delete(UUID id) {
        Employee employee = employeeRepository.findByIdAndTenantId(id, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("EMPLOYEE_NOT_FOUND"));
        employeeRepository.delete(employee);
    }

    private static EmploymentStatus parseStatus(String status) {
        try {
            return EmploymentStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_EMPLOYMENT_STATUS");
        }
    }
}
