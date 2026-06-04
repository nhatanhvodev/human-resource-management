package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.SalaryStructure;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface SalaryStructureRepository extends JpaRepository<SalaryStructure, UUID> {
    Optional<SalaryStructure> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
