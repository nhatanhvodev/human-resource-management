package com.company.hrms.organization.application;

import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class DepartmentService {
    private final DepartmentRepository departmentRepository;
    private final EmployeeRepository employeeRepository;

    public DepartmentService(DepartmentRepository departmentRepository,
                             EmployeeRepository employeeRepository) {
        this.departmentRepository = departmentRepository;
        this.employeeRepository = employeeRepository;
    }

    @Transactional
    public Department create(String code, String name) {
        String tenantId = TenantContext.get();
        if (departmentRepository.existsByTenantIdAndCode(tenantId, code)) {
            throw new ConflictException("DEPARTMENT_CODE_EXISTS");
        }
        Department department = new Department(UUID.randomUUID(), tenantId, code, name);
        return departmentRepository.save(department);
    }

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
            .ifPresent(existing -> {
                throw new ConflictException("DEPARTMENT_CODE_EXISTS");
            });
        department.update(code, name);
        return department;
    }

    @Transactional
    public void delete(UUID id) {
        String tenantId = TenantContext.get();
        Department department = getById(id);
        if (employeeRepository.existsByTenantIdAndDepartment_Id(tenantId, id)) {
            throw new ConflictException("DEPARTMENT_IN_USE");
        }
        departmentRepository.delete(department);
    }
}
