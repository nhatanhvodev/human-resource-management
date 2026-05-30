package com.company.hrms.recruitment.interfaces.api;

import com.company.hrms.recruitment.application.RecruitmentService;
import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.domain.Candidate;
import com.company.hrms.recruitment.domain.JobPosting;
import com.company.hrms.recruitment.domain.RecruitmentApplication;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

    @GetMapping("/candidates")
    @PreAuthorize("hasAuthority('recruitment:read')")
    public PageResponse<CandidateResponse> listCandidates(Pageable pageable) {
        return PageResponse.from(
            recruitmentService.listCandidates(pageable)
                .map(candidate -> new CandidateResponse(candidate.getId(), candidate.getFullName()))
        );
    }

    @PostMapping("/candidates")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public CandidateResponse createCandidate(@Valid @RequestBody CreateCandidateRequest request) {
        Candidate candidate = recruitmentService.createCandidate(request.fullName());
        return new CandidateResponse(candidate.getId(), candidate.getFullName());
    }

    @PutMapping("/candidates/{id}")
    @PreAuthorize("hasAuthority('recruitment:update')")
    public CandidateResponse updateCandidate(@PathVariable UUID id, @Valid @RequestBody CreateCandidateRequest request) {
        Candidate candidate = recruitmentService.updateCandidate(id, request.fullName());
        return new CandidateResponse(candidate.getId(), candidate.getFullName());
    }

    @GetMapping("/job-postings")
    @PreAuthorize("hasAuthority('recruitment:read')")
    public PageResponse<JobPostingResponse> listJobPostings(Pageable pageable) {
        return PageResponse.from(
            recruitmentService.listJobPostings(pageable)
                .map(jobPosting -> new JobPostingResponse(jobPosting.getId(), jobPosting.getTitle()))
        );
    }

    @PostMapping("/job-postings")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public JobPostingResponse createJobPosting(@Valid @RequestBody CreateJobPostingRequest request) {
        JobPosting jobPosting = recruitmentService.createJobPosting(request.title());
        return new JobPostingResponse(jobPosting.getId(), jobPosting.getTitle());
    }

    @PutMapping("/job-postings/{id}")
    @PreAuthorize("hasAuthority('recruitment:update')")
    public JobPostingResponse updateJobPosting(@PathVariable UUID id, @Valid @RequestBody CreateJobPostingRequest request) {
        JobPosting jobPosting = recruitmentService.updateJobPosting(id, request.title());
        return new JobPostingResponse(jobPosting.getId(), jobPosting.getTitle());
    }

    @GetMapping("/applications")
    @PreAuthorize("hasAuthority('recruitment:read')")
    public PageResponse<ApplicationResponse> listApplications(@RequestParam(required = false) String status, Pageable pageable) {
        return PageResponse.from(
            recruitmentService.listApplications(status, pageable)
                .map(application -> new ApplicationResponse(application.getId(), application.getStatus().name()))
        );
    }

    @PostMapping("/applications")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public ApplicationResponse createApplication(@Valid @RequestBody CreateApplicationRequest request) {
        RecruitmentApplication application = recruitmentService.createApplication(
            request.candidateId(),
            request.jobPostingId(),
            ApplicationStatus.valueOf(request.status())
        );
        return new ApplicationResponse(application.getId(), application.getStatus().name());
    }

    @PostMapping("/recruitment/applications/{applicationId}/convert")
    @PreAuthorize("hasAuthority('recruitment:convert')")
    public ConversionResponse convert(@PathVariable UUID applicationId, @Valid @RequestBody ConvertRequest request) {
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
