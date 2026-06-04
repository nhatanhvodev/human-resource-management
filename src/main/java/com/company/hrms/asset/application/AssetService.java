package com.company.hrms.asset.application;

import com.company.hrms.asset.domain.Asset;
import com.company.hrms.asset.domain.AssetStatus;
import com.company.hrms.asset.infrastructure.AssetRepository;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class AssetService {
    private final AssetRepository repository;

    public AssetService(AssetRepository repository) { this.repository = repository; }

    @Transactional
    public Asset create(String name, String category, String serialNumber, LocalDate purchaseDate, Double purchasePrice) {
        return repository.save(new Asset(UUID.randomUUID(), TenantContext.get(), name, category,
            serialNumber, purchaseDate, purchasePrice));
    }

    @Transactional(readOnly = true)
    public Page<Asset> list(Pageable pageable) {
        return repository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public Page<Asset> listByStatus(String status, Pageable pageable) {
        return repository.findByTenantIdAndStatus(TenantContext.get(), AssetStatus.valueOf(status), pageable);
    }

    @Transactional(readOnly = true)
    public List<Asset> listByEmployee(UUID employeeId) {
        return repository.findByTenantIdAndAssignedTo(TenantContext.get(), employeeId);
    }

    @Transactional
    public Asset assign(UUID id, UUID employeeId) {
        Asset asset = repository.findById(id).orElseThrow(() -> new NotFoundException("Asset not found: " + id));
        asset.assignTo(employeeId);
        return repository.save(asset);
    }

    @Transactional
    public Asset unassign(UUID id) {
        Asset asset = repository.findById(id).orElseThrow(() -> new NotFoundException("Asset not found: " + id));
        asset.unassign();
        return repository.save(asset);
    }

    @Transactional
    public void delete(UUID id) { repository.deleteById(id); }
}
