package com.company.hrms.performance.infrastructure;

import com.company.hrms.performance.domain.AppraisalCycle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AppraisalCycleRepository extends JpaRepository<AppraisalCycle, UUID> {
    Page<AppraisalCycle> findByTenantId(String tenantId, Pageable pageable);
}
