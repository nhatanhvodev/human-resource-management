package com.company.hrms.recruitment.interfaces.api;

import com.company.hrms.recruitment.application.RecruitmentService;
import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.domain.Candidate;
import com.company.hrms.recruitment.domain.JobPosting;
import com.company.hrms.recruitment.domain.RecruitmentApplication;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
@Validated
public class RecruitmentController {
    private final RecruitmentService recruitmentService;

    public RecruitmentController(RecruitmentService recruitmentService) {
        this.recruitmentService = recruitmentService;
    }

    @PostMapping("/candidates")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public CandidateResponse createCandidate(@RequestBody CreateCandidateRequest request) {
        Candidate candidate = recruitmentService.createCandidate(request.fullName());
        return new CandidateResponse(candidate.getId(), candidate.getFullName());
    }

    @PostMapping("/job-postings")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public JobPostingResponse createJobPosting(@RequestBody CreateJobPostingRequest request) {
        JobPosting jobPosting = recruitmentService.createJobPosting(request.title());
        return new JobPostingResponse(jobPosting.getId(), jobPosting.getTitle());
    }

    @PostMapping("/applications")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public ApplicationResponse createApplication(@RequestBody CreateApplicationRequest request) {
        RecruitmentApplication application = recruitmentService.createApplication(
            request.candidateId(),
            request.jobPostingId(),
            ApplicationStatus.valueOf(request.status())
        );
        return new ApplicationResponse(application.getId(), application.getStatus().name());
    }

    @PostMapping("/recruitment/applications/{applicationId}/convert")
    @PreAuthorize("hasAuthority('recruitment:convert')")
    public ConversionResponse convert(@PathVariable UUID applicationId, @RequestBody ConvertRequest request) {
        RecruitmentService.ConversionResult result = recruitmentService.convertToEmployee(
            applicationId,
            request.employeeNo(),
            request.departmentId()
        );
        return new ConversionResponse(result.employeeId(), result.applicationId(), result.applicationStatus());
    }

    public record CreateCandidateRequest(@NotBlank String fullName) {
    }

    public record CreateJobPostingRequest(@NotBlank String title) {
    }

    public record CreateApplicationRequest(@NotNull UUID candidateId,
                                           @NotNull UUID jobPostingId,
                                           @NotBlank String status) {
    }

    public record ConvertRequest(@NotBlank String employeeNo, @NotNull UUID departmentId) {
    }

    public record CandidateResponse(UUID id, String fullName) {
    }

    public record JobPostingResponse(UUID id, String title) {
    }

    public record ApplicationResponse(UUID id, String status) {
    }

    public record ConversionResponse(UUID employeeId, UUID applicationId, String applicationStatus) {
    }
}
