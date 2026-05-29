package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.RecruitmentApplication;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface RecruitmentApplicationRepository extends JpaRepository<RecruitmentApplication, UUID> {
    Optional<RecruitmentApplication> findByIdAndTenantId(UUID id, String tenantId);
}
