package com.company.hrms.payroll.infrastructure;

import com.company.hrms.payroll.domain.PayrollPeriod;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PayrollPeriodRepository extends JpaRepository<PayrollPeriod, UUID> {
    Optional<PayrollPeriod> findByIdAndTenantId(UUID id, String tenantId);

    Page<PayrollPeriod> findAllByTenantId(String tenantId, Pageable pageable);
}
