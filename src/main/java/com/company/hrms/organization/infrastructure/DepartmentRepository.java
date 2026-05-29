package com.company.hrms.organization.infrastructure;

import com.company.hrms.organization.domain.Department;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface DepartmentRepository extends JpaRepository<Department, UUID> {
    boolean existsByTenantIdAndCode(String tenantId, String code);

    Optional<Department> findByIdAndTenantId(UUID id, String tenantId);
}
