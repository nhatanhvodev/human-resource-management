package com.company.hrms.onboarding.infrastructure;

import com.company.hrms.onboarding.domain.OnboardingTemplate;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface OnboardingTemplateRepository extends JpaRepository<OnboardingTemplate, UUID> {
    List<OnboardingTemplate> findByTenantId(String tenantId);
}
