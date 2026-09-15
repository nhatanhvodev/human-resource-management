package com.company.hrms.recruitment.application;

import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.domain.Candidate;
import com.company.hrms.recruitment.domain.Interview;
import com.company.hrms.recruitment.domain.InterviewStatus;
import com.company.hrms.recruitment.domain.JobPosting;
import com.company.hrms.recruitment.domain.JobPostingStatus;
import com.company.hrms.recruitment.domain.RecruitmentApplication;
import com.company.hrms.recruitment.infrastructure.CandidateRepository;
import com.company.hrms.recruitment.infrastructure.InterviewRepository;
import com.company.hrms.recruitment.infrastructure.JobPostingRepository;
import com.company.hrms.recruitment.infrastructure.RecruitmentApplicationRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
public class RecruitmentService {
    private final CandidateRepository candidateRepository;
    private final JobPostingRepository jobPostingRepository;
    private final RecruitmentApplicationRepository recruitmentApplicationRepository;
    private final InterviewRepository interviewRepository;
    private final EmployeeService employeeService;

    public RecruitmentService(CandidateRepository candidateRepository,
                              JobPostingRepository jobPostingRepository,
                              RecruitmentApplicationRepository recruitmentApplicationRepository,
                              InterviewRepository interviewRepository,
                              EmployeeService employeeService) {
        this.candidateRepository = candidateRepository;
        this.jobPostingRepository = jobPostingRepository;
        this.recruitmentApplicationRepository = recruitmentApplicationRepository;
        this.interviewRepository = interviewRepository;
        this.employeeService = employeeService;
    }

    @Transactional(readOnly = true)
    public Page<Candidate> listCandidates(Pageable pageable) {
        return candidateRepository.findAllByTenantId(TenantContext.get(), pageable);
    }

    @Transactional
    public Candidate createCandidate(String fullName) {
        return candidateRepository.save(new Candidate(UUID.randomUUID(), TenantContext.get(), fullName, null, null, null));
    }

    @Transactional
    public Candidate updateCandidate(UUID id, String fullName) {
        String tenantId = TenantContext.get();
        Candidate candidate = candidateRepository.findById(id)
            .filter(existing -> tenantId.equals(existing.getTenantId()))
            .orElseThrow(() -> new NotFoundException("CANDIDATE_NOT_FOUND"));
        candidate.updateFullName(fullName);
        return candidate;
    }

    @Transactional
    public void deleteCandidate(UUID id) {
        String tenantId = TenantContext.get();
        Candidate candidate = candidateRepository.findById(id)
            .filter(existing -> tenantId.equals(existing.getTenantId()))
            .orElseThrow(() -> new NotFoundException("CANDIDATE_NOT_FOUND"));
        candidateRepository.delete(candidate);
    }

    @Transactional(readOnly = true)
    public Page<JobPosting> listJobPostings(Pageable pageable) {
        return jobPostingRepository.findAllByTenantId(TenantContext.get(), pageable);
    }

    @Transactional
    public JobPosting createJobPosting(String title, String description, UUID departmentId,
                                        BigDecimal salaryRangeMin, BigDecimal salaryRangeMax,
                                        String requirements, String location, Integer headcount) {
        int hc = headcount != null ? headcount : 1;
        return jobPostingRepository.save(new JobPosting(UUID.randomUUID(), TenantContext.get(), title,
            description, departmentId, JobPostingStatus.DRAFT,
            salaryRangeMin, salaryRangeMax, requirements, location, hc));
    }

    @Transactional
    public JobPosting updateJobPosting(UUID id, String title, String description, UUID departmentId,
                                        BigDecimal salaryRangeMin, BigDecimal salaryRangeMax,
                                        String requirements, String location, Integer headcount) {
        String tenantId = TenantContext.get();
        JobPosting jobPosting = jobPostingRepository.findById(id)
            .filter(existing -> tenantId.equals(existing.getTenantId()))
            .orElseThrow(() -> new NotFoundException("JOB_POSTING_NOT_FOUND"));
        jobPosting.updateTitle(title);
        jobPosting.updateDescription(description);
        jobPosting.updateDepartmentId(departmentId);
        jobPosting.updateSalaryRangeMin(salaryRangeMin);
        jobPosting.updateSalaryRangeMax(salaryRangeMax);
        jobPosting.updateRequirements(requirements);
        jobPosting.updateLocation(location);
        jobPosting.updateHeadcount(headcount != null ? headcount : 1);
        return jobPosting;
    }

    @Transactional
    public void deleteJobPosting(UUID id) {
        String tenantId = TenantContext.get();
        JobPosting jobPosting = jobPostingRepository.findById(id)
            .filter(existing -> tenantId.equals(existing.getTenantId()))
            .orElseThrow(() -> new NotFoundException("JOB_POSTING_NOT_FOUND"));
        jobPostingRepository.delete(jobPosting);
    }

    @Transactional
    public JobPosting changeJobPostingStatus(UUID id, String status) {
        String tenantId = TenantContext.get();
        JobPosting jobPosting = jobPostingRepository.findById(id)
            .filter(existing -> tenantId.equals(existing.getTenantId()))
            .orElseThrow(() -> new NotFoundException("JOB_POSTING_NOT_FOUND"));
        jobPosting.updateStatus(JobPostingStatus.valueOf(status.toUpperCase(Locale.ROOT)));
        return jobPosting;
    }

    @Transactional(readOnly = true)
    public Page<RecruitmentApplication> listApplications(String status, Pageable pageable) {
        String tenantId = TenantContext.get();
        String normalizedStatus = status == null ? null : status.trim();
        if (normalizedStatus == null || normalizedStatus.isEmpty()) {
            return recruitmentApplicationRepository.findAllByTenantId(tenantId, pageable);
        }
        return recruitmentApplicationRepository.findByTenantIdAndStatus(
            tenantId,
            parseStatus(normalizedStatus),
            pageable
        );
    }

    @Transactional
    public RecruitmentApplication createApplication(UUID candidateId, UUID jobPostingId, ApplicationStatus status) {
        String tenantId = TenantContext.get();
        Candidate candidate = candidateRepository.findById(candidateId)
            .filter(c -> tenantId.equals(c.getTenantId()))
            .orElseThrow(() -> new IllegalArgumentException("CANDIDATE_NOT_FOUND"));
        JobPosting jobPosting = jobPostingRepository.findById(jobPostingId)
            .filter(jp -> tenantId.equals(jp.getTenantId()))
            .orElseThrow(() -> new IllegalArgumentException("JOB_POSTING_NOT_FOUND"));
        String applicationNo = "HS%06d".formatted(recruitmentApplicationRepository.countByTenantId(tenantId) + 1);
        return recruitmentApplicationRepository.save(
            new RecruitmentApplication(UUID.randomUUID(), tenantId, applicationNo, candidate, jobPosting, status)
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
        application.markHired();
        return new ConversionResult(employee.getId(), application.getId(), application.getStatus().name());
    }

    private static ApplicationStatus parseStatus(String status) {
        try {
            return ApplicationStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_APPLICATION_STATUS");
        }
    }

    @Transactional
    public RecruitmentApplication moveStage(UUID id, String stage) {
        String tenantId = TenantContext.get();
        RecruitmentApplication application = recruitmentApplicationRepository.findById(id)
            .filter(a -> tenantId.equals(a.getTenantId()))
            .orElseThrow(() -> new NotFoundException("APPLICATION_NOT_FOUND"));
        application.setStatus(ApplicationStatus.valueOf(stage.toUpperCase(Locale.ROOT)));
        return recruitmentApplicationRepository.save(application);
    }

    @Transactional
    public Interview scheduleInterview(UUID applicationId, UUID interviewerId, Instant scheduledAt,
                                       String location, String meetingLink) {
        return interviewRepository.save(new Interview(UUID.randomUUID(), TenantContext.get(),
            applicationId, interviewerId, scheduledAt, location, meetingLink));
    }

    @Transactional
    public Interview addFeedback(UUID id, String feedback, Integer rating) {
        String tenantId = TenantContext.get();
        Interview interview = interviewRepository.findById(id)
            .filter(i -> tenantId.equals(i.getTenantId()))
            .orElseThrow(() -> new NotFoundException("INTERVIEW_NOT_FOUND"));
        interview.addFeedback(feedback, rating);
        return interviewRepository.save(interview);
    }

    @Transactional(readOnly = true)
    public Page<Interview> listInterviews(UUID applicationId, Pageable pageable) {
        String tenantId = TenantContext.get();
        if (applicationId != null) {
            return interviewRepository.findByTenantIdAndApplicationId(tenantId, applicationId, pageable);
        }
        return interviewRepository.findAllByTenantId(tenantId, pageable);
    }

    public record ConversionResult(UUID employeeId, UUID applicationId, String applicationStatus) {
    }
}
