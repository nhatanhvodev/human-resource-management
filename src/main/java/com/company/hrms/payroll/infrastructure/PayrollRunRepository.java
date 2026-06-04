package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.PayrollRun;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PayrollRunRepository extends JpaRepository<PayrollRun, UUID> {
    @EntityGraph(attributePaths = "payrollPeriod")
    Page<PayrollRun> findByTenantIdAndPayrollPeriodId(String tenantId, UUID periodId, Pageable pageable);
}
