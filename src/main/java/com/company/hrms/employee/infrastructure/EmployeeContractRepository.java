package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.EmployeeContract;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EmployeeContractRepository extends JpaRepository<EmployeeContract, UUID> {
    List<EmployeeContract> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
