package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.domain.RecruitmentApplication;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface RecruitmentApplicationRepository extends JpaRepository<RecruitmentApplication, UUID> {
    long countByTenantId(String tenantId);

    Optional<RecruitmentApplication> findByIdAndTenantId(UUID id, String tenantId);

    Page<RecruitmentApplication> findAllByTenantId(String tenantId, Pageable pageable);

    Page<RecruitmentApplication> findByTenantIdAndStatus(String tenantId, ApplicationStatus status, Pageable pageable);
}
