package com.company.hrms.performance.infrastructure;

import com.company.hrms.performance.domain.KPI;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface KPIRepository extends JpaRepository<KPI, UUID> {
    List<KPI> findByTenantIdAndCycle_Id(String tenantId, UUID cycleId);
    List<KPI> findByTenantIdAndEmployeeIdAndCycle_Id(String tenantId, UUID employeeId, UUID cycleId);
}
