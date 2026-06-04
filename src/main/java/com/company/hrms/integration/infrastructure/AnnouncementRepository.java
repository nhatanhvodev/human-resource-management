package com.company.hrms.integration.infrastructure;

import com.company.hrms.integration.domain.Announcement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface AnnouncementRepository extends JpaRepository<Announcement, UUID> {
    Page<Announcement> findByTenantIdOrderByCreatedAtDesc(String tenantId, Pageable pageable);

    @Query("SELECT a FROM Announcement a WHERE a.tenantId = :tenantId AND a.publishAt <= :now AND (a.expireAt IS NULL OR a.expireAt > :now) ORDER BY a.priority DESC, a.createdAt DESC")
    List<Announcement> findActive(String tenantId, Instant now);
}
