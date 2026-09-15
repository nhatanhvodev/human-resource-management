package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.Interview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface InterviewRepository extends JpaRepository<Interview, UUID> {
    List<Interview> findByTenantIdAndApplicationId(String tenantId, UUID applicationId);
    Page<Interview> findByTenantIdAndApplicationId(String tenantId, UUID applicationId, Pageable pageable);
    Page<Interview> findAllByTenantId(String tenantId, Pageable pageable);
}
