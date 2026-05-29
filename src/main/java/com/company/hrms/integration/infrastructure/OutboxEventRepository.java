package com.company.hrms.integration.infrastructure;

import com.company.hrms.integration.domain.OutboxEvent;
import com.company.hrms.integration.domain.OutboxStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface OutboxEventRepository extends JpaRepository<OutboxEvent, UUID> {
    List<OutboxEvent> findTop100ByStatus(OutboxStatus status);
}
