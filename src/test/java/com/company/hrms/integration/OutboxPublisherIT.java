package com.company.hrms.integration;

import com.company.hrms.integration.application.OutboxPublisherJob;
import com.company.hrms.integration.domain.OutboxEvent;
import com.company.hrms.integration.domain.OutboxStatus;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class OutboxPublisherIT {
    @Autowired
    private OutboxEventRepository outboxEventRepository;

    @Autowired
    private OutboxPublisherJob outboxPublisherJob;

    @Test
    void publishesPendingOutboxEventOnce() {
        OutboxEvent event = outboxEventRepository.save(
            new OutboxEvent(UUID.randomUUID(), "tenant-outbox", "TEST_EVENT", "{\"ok\":true}", OutboxStatus.PENDING)
        );

        outboxPublisherJob.publishPending();

        OutboxEvent updated = outboxEventRepository.findById(event.getId()).orElseThrow();
        assertThat(updated.getStatus()).isEqualTo(OutboxStatus.SENT);
    }
}
