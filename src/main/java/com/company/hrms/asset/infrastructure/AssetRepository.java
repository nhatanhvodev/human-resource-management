package com.company.hrms.asset.infrastructure;

import com.company.hrms.asset.domain.Asset;
import com.company.hrms.asset.domain.AssetStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface AssetRepository extends JpaRepository<Asset, UUID> {
    Page<Asset> findByTenantId(String tenantId, Pageable pageable);
    List<Asset> findByTenantIdAndAssignedTo(String tenantId, UUID assignedTo);
    Page<Asset> findByTenantIdAndStatus(String tenantId, AssetStatus status, Pageable pageable);
}
