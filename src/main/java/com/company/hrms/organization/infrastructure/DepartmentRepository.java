package com.company.hrms.organization.infrastructure;

import com.company.hrms.organization.domain.Department;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DepartmentRepository extends JpaRepository<Department, UUID> {
    long countByTenantId(String tenantId);

    List<Department> findAllByTenantId(String tenantId);

    Optional<Department> findByIdAndTenantId(UUID id, String tenantId);

    Page<Department> findAllByTenantId(String tenantId, Pageable pageable);
}
