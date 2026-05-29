package com.company.hrms.reporting.application;

import com.company.hrms.integration.domain.OutboxEvent;
import com.company.hrms.integration.domain.OutboxStatus;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class ReportExportService {
    private final OutboxEventRepository outboxEventRepository;

    public ReportExportService(OutboxEventRepository outboxEventRepository) {
        this.outboxEventRepository = outboxEventRepository;
    }

    @Transactional
    public UUID requestExport(String exportType) {
        OutboxEvent event = new OutboxEvent(
            UUID.randomUUID(),
            TenantContext.get(),
            "REPORT_EXPORT_REQUESTED",
            "{\"type\":\"" + exportType + "\"}",
            OutboxStatus.PENDING
        );
        return outboxEventRepository.save(event).getId();
    }
}
