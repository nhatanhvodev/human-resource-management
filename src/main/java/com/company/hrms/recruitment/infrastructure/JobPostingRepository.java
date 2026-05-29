package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.JobPosting;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface JobPostingRepository extends JpaRepository<JobPosting, UUID> {
}
