package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.Payslip;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PayslipRepository extends JpaRepository<Payslip, UUID> {
    List<Payslip> findByTenantIdAndPayrollRun_Id(String tenantId, UUID payrollRunId);
    List<Payslip> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
