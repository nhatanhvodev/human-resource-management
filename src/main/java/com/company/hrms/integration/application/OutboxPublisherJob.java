package com.company.hrms.integration.application;

import com.company.hrms.integration.domain.OutboxEvent;
import com.company.hrms.integration.domain.OutboxStatus;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Component
public class OutboxPublisherJob {
    private final OutboxEventRepository outboxEventRepository;

    public OutboxPublisherJob(OutboxEventRepository outboxEventRepository) {
        this.outboxEventRepository = outboxEventRepository;
    }

    @Transactional
    @Scheduled(fixedDelayString = "${integration.outbox.delay-ms:1000}")
    public void publishPending() {
        List<OutboxEvent> events = outboxEventRepository.findTop100ByStatus(OutboxStatus.PENDING);
        for (OutboxEvent event : events) {
            event.markSent();
        }
    }
}
