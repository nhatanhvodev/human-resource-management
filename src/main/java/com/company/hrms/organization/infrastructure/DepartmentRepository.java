package com.company.hrms.organization.infrastructure;

import com.company.hrms.organization.domain.Department;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface DepartmentRepository extends JpaRepository<Department, UUID> {
    long countByTenantId(String tenantId);

    boolean existsByTenantIdAndCode(String tenantId, String code);

    Optional<Department> findByIdAndTenantId(UUID id, String tenantId);

    Page<Department> findByTenantIdAndNameContainingIgnoreCaseOrTenantIdAndCodeContainingIgnoreCase(
        String tenantIdForName, String nameKeyword, String tenantIdForCode, String codeKeyword, Pageable pageable);

    Page<Department> findAllByTenantId(String tenantId, Pageable pageable);

    Optional<Department> findByTenantIdAndCode(String tenantId, String code);
}
