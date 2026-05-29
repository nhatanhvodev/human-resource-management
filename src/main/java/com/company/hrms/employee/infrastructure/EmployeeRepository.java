package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.Employee;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface EmployeeRepository extends JpaRepository<Employee, UUID> {
    boolean existsByTenantIdAndEmployeeNo(String tenantId, String employeeNo);

    Optional<Employee> findByIdAndTenantId(UUID id, String tenantId);

    List<Employee> findAllByTenantId(String tenantId);
}
