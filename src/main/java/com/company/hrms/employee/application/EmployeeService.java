package com.company.hrms.employee.application;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class EmployeeService {
    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;

    public EmployeeService(EmployeeRepository employeeRepository,
                           DepartmentRepository departmentRepository) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
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
            UUID.randomUUID(),
            tenantId,
            employeeNo,
            fullName,
            department,
            hireDate,
            EmploymentStatus.ACTIVE
        );
        return employeeRepository.save(employee);
    }

    @Transactional(readOnly = true)
    public List<Employee> list() {
        return employeeRepository.findAllByTenantId(TenantContext.get());
    }

    @Transactional(readOnly = true)
    public Employee getById(UUID id) {
        return employeeRepository.findByIdAndTenantId(id, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("EMPLOYEE_NOT_FOUND"));
    }
}
