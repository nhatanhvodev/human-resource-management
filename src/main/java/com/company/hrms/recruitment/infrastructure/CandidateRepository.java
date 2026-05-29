package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.Candidate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface CandidateRepository extends JpaRepository<Candidate, UUID> {
    Page<Candidate> findAllByTenantId(String tenantId, Pageable pageable);
}
