package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.domain.EmploymentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface EmployeeRepository extends JpaRepository<Employee, UUID> {
    long countByTenantId(String tenantId);

    boolean existsByTenantIdAndEmployeeNo(String tenantId, String employeeNo);

    Optional<Employee> findByIdAndTenantId(UUID id, String tenantId);

    Page<Employee> findAllByTenantId(String tenantId, Pageable pageable);

    Page<Employee> findByTenantIdAndEmploymentStatus(String tenantId, EmploymentStatus status, Pageable pageable);

    Page<Employee> findByTenantIdAndFullNameContainingIgnoreCase(String tenantId, String name, Pageable pageable);

    Page<Employee> findByTenantIdAndEmploymentStatusAndFullNameContainingIgnoreCase(
        String tenantId, EmploymentStatus status, String name, Pageable pageable);

    boolean existsByTenantIdAndDepartment_Id(String tenantId, UUID departmentId);
}
