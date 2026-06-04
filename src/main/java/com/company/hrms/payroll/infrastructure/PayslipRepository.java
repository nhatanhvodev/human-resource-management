package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.Payslip;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PayslipRepository extends JpaRepository<Payslip, UUID> {
    @EntityGraph(attributePaths = {"payrollRun", "employee"})
    List<Payslip> findByTenantIdAndPayrollRun_Id(String tenantId, UUID payrollRunId);

    @EntityGraph(attributePaths = {"payrollRun", "employee"})
    List<Payslip> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
