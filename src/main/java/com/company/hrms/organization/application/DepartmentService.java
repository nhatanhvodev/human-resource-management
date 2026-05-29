package com.company.hrms.organization.application;

import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class DepartmentService {
    private final DepartmentRepository departmentRepository;

    public DepartmentService(DepartmentRepository departmentRepository) {
        this.departmentRepository = departmentRepository;
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
}
