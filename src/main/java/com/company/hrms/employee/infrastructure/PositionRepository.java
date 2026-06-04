package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.Position;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PositionRepository extends JpaRepository<Position, UUID> {
    @EntityGraph(attributePaths = "department")
    Page<Position> findAllByTenantId(String tenantId, Pageable pageable);

    @EntityGraph(attributePaths = "department")
    Optional<Position> findByIdAndTenantId(UUID id, String tenantId);

    boolean existsByTenantIdAndCode(String tenantId, String code);
}
