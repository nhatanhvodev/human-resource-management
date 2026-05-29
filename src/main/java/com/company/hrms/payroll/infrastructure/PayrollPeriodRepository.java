package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.PayrollPeriod;
import com.company.hrms.payroll.domain.PayrollPeriodStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PayrollPeriodRepository extends JpaRepository<PayrollPeriod, UUID> {
    long countByTenantIdAndStatus(String tenantId, PayrollPeriodStatus status);

    Optional<PayrollPeriod> findByIdAndTenantId(UUID id, String tenantId);

    Page<PayrollPeriod> findAllByTenantId(String tenantId, Pageable pageable);
}
