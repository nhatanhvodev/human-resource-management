package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.Interview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface InterviewRepository extends JpaRepository<Interview, UUID> {
    List<Interview> findByTenantIdAndApplicationId(String tenantId, UUID applicationId);
}
