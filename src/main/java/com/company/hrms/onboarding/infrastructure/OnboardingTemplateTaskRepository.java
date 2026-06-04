package com.company.hrms.onboarding.infrastructure;

import com.company.hrms.onboarding.domain.OnboardingTemplateTask;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface OnboardingTemplateTaskRepository extends JpaRepository<OnboardingTemplateTask, UUID> {
    List<OnboardingTemplateTask> findByTenantIdAndTemplateIdOrderByOrderIndexAsc(String tenantId, UUID templateId);
}
