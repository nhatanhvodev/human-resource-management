package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.domain.EmploymentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface EmployeeRepository extends JpaRepository<Employee, UUID> {
    long countByTenantId(String tenantId);
    long countByTenantIdAndEmploymentStatus(String tenantId, EmploymentStatus status);
    long countByTenantIdAndDepartment_Id(String tenantId, UUID departmentId);

    @EntityGraph(attributePaths = {"department", "position"})
    Optional<Employee> findByIdAndTenantId(UUID id, String tenantId);

    @EntityGraph(attributePaths = {"department", "position"})
    Page<Employee> findAllByTenantId(String tenantId, Pageable pageable);

    boolean existsByTenantIdAndEmployeeNo(String tenantId, String employeeNo);

    boolean existsByTenantIdAndDepartment_Id(String tenantId, UUID departmentId);

    @EntityGraph(attributePaths = {"department", "position"})
    Page<Employee> findByTenantIdAndEmploymentStatus(String tenantId, EmploymentStatus status, Pageable pageable);

    @EntityGraph(attributePaths = {"department", "position"})
    Page<Employee> findByTenantIdAndFullNameContainingIgnoreCase(String tenantId, String name, Pageable pageable);

    @EntityGraph(attributePaths = {"department", "position"})
    Page<Employee> findByTenantIdAndEmploymentStatusAndFullNameContainingIgnoreCase(String tenantId, EmploymentStatus status, String name, Pageable pageable);
}
