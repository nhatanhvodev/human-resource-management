package com.company.hrms.recruitment.application;

import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.domain.Candidate;
import com.company.hrms.recruitment.domain.JobPosting;
import com.company.hrms.recruitment.domain.RecruitmentApplication;
import com.company.hrms.recruitment.infrastructure.CandidateRepository;
import com.company.hrms.recruitment.infrastructure.JobPostingRepository;
import com.company.hrms.recruitment.infrastructure.RecruitmentApplicationRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.UUID;

@Service
public class RecruitmentService {
    private final CandidateRepository candidateRepository;
    private final JobPostingRepository jobPostingRepository;
    private final RecruitmentApplicationRepository recruitmentApplicationRepository;
    private final EmployeeService employeeService;

    public RecruitmentService(CandidateRepository candidateRepository,
                              JobPostingRepository jobPostingRepository,
                              RecruitmentApplicationRepository recruitmentApplicationRepository,
                              EmployeeService employeeService) {
        this.candidateRepository = candidateRepository;
        this.jobPostingRepository = jobPostingRepository;
        this.recruitmentApplicationRepository = recruitmentApplicationRepository;
        this.employeeService = employeeService;
    }

    @Transactional
    public Candidate createCandidate(String fullName) {
        return candidateRepository.save(new Candidate(UUID.randomUUID(), TenantContext.get(), fullName));
    }

    @Transactional
    public JobPosting createJobPosting(String title) {
        return jobPostingRepository.save(new JobPosting(UUID.randomUUID(), TenantContext.get(), title));
    }

    @Transactional
    public RecruitmentApplication createApplication(UUID candidateId, UUID jobPostingId, ApplicationStatus status) {
        Candidate candidate = candidateRepository.findById(candidateId)
            .orElseThrow(() -> new IllegalArgumentException("CANDIDATE_NOT_FOUND"));
        JobPosting jobPosting = jobPostingRepository.findById(jobPostingId)
            .orElseThrow(() -> new IllegalArgumentException("JOB_POSTING_NOT_FOUND"));
        return recruitmentApplicationRepository.save(
            new RecruitmentApplication(UUID.randomUUID(), TenantContext.get(), candidate, jobPosting, status)
        );
    }

    @Transactional
    public ConversionResult convertToEmployee(UUID applicationId, String employeeNo, UUID departmentId) {
        RecruitmentApplication application = recruitmentApplicationRepository.findByIdAndTenantId(applicationId, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("APPLICATION_NOT_FOUND"));
        if (application.getStatus() != ApplicationStatus.OFFER_ACCEPTED) {
            throw new ConflictException("APPLICATION_NOT_READY_FOR_CONVERSION");
        }
        Employee employee = employeeService.create(
            employeeNo,
            application.getCandidate().getFullName(),
            departmentId,
            LocalDate.now()
        );
        application.setStatus(ApplicationStatus.HIRED);
        return new ConversionResult(employee.getId(), application.getId(), application.getStatus().name());
    }

    public record ConversionResult(UUID employeeId, UUID applicationId, String applicationStatus) {
    }
}
