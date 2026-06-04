package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.Position;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PositionRepository extends JpaRepository<Position, UUID> {
    Page<Position> findAllByTenantId(String tenantId, Pageable pageable);
    Optional<Position> findByIdAndTenantId(UUID id, String tenantId);
    boolean existsByTenantIdAndCode(String tenantId, String code);
}
