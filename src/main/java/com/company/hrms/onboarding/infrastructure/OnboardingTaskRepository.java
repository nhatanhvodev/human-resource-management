package com.company.hrms.onboarding.infrastructure;

import com.company.hrms.onboarding.domain.OnboardingTask;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface OnboardingTaskRepository extends JpaRepository<OnboardingTask, UUID> {
    List<OnboardingTask> findByTenantIdAndEmployeeIdOrderByCreatedAtAsc(String tenantId, UUID employeeId);
}
