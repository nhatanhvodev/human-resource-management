package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.PayrollRun;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PayrollRunRepository extends JpaRepository<PayrollRun, UUID> {
}
