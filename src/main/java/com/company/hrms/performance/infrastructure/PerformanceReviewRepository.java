package com.company.hrms.performance.infrastructure;

import com.company.hrms.performance.domain.PerformanceReview;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PerformanceReviewRepository extends JpaRepository<PerformanceReview, UUID> {
    List<PerformanceReview> findByTenantIdAndCycle_Id(String tenantId, UUID cycleId);
    List<PerformanceReview> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId);
}
