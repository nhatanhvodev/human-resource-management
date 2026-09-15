package com.company.hrms.recruitment.interfaces.api;

import com.company.hrms.recruitment.application.RecruitmentService;
import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.domain.Candidate;
import com.company.hrms.recruitment.domain.Interview;
import com.company.hrms.recruitment.domain.JobPosting;
import com.company.hrms.recruitment.domain.RecruitmentApplication;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Locale;
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

    @DeleteMapping("/candidates/{id}")
    @PreAuthorize("hasAuthority('recruitment:delete')")
    public void deleteCandidate(@PathVariable UUID id) {
        recruitmentService.deleteCandidate(id);
    }

    @GetMapping("/job-postings")
    @PreAuthorize("hasAuthority('recruitment:read')")
    public PageResponse<JobPostingResponse> listJobPostings(Pageable pageable) {
        return PageResponse.from(
            recruitmentService.listJobPostings(pageable)
                .map(this::toJobPostingResponse)
        );
    }

    @PostMapping("/job-postings")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public JobPostingResponse createJobPosting(@Valid @RequestBody CreateJobPostingRequest request) {
        JobPosting jobPosting = recruitmentService.createJobPosting(
            request.title(), request.description(), request.departmentId(),
            request.salaryRangeMin(), request.salaryRangeMax(),
            request.requirements(), request.location(), request.headcount());
        return toJobPostingResponse(jobPosting);
    }

    @PutMapping("/job-postings/{id}")
    @PreAuthorize("hasAuthority('recruitment:update')")
    public JobPostingResponse updateJobPosting(@PathVariable UUID id, @Valid @RequestBody CreateJobPostingRequest request) {
        JobPosting jobPosting = recruitmentService.updateJobPosting(id,
            request.title(), request.description(), request.departmentId(),
            request.salaryRangeMin(), request.salaryRangeMax(),
            request.requirements(), request.location(), request.headcount());
        return toJobPostingResponse(jobPosting);
    }

    @DeleteMapping("/job-postings/{id}")
    @PreAuthorize("hasAuthority('recruitment:delete')")
    public void deleteJobPosting(@PathVariable UUID id) {
        recruitmentService.deleteJobPosting(id);
    }

    @PatchMapping("/job-postings/{id}/status")
    @PreAuthorize("hasAuthority('recruitment:update')")
    public JobPostingResponse changeJobPostingStatus(@PathVariable UUID id, @RequestParam String status) {
        JobPosting jobPosting = recruitmentService.changeJobPostingStatus(id, status);
        return toJobPostingResponse(jobPosting);
    }

    @GetMapping("/applications")
    @PreAuthorize("hasAuthority('recruitment:read')")
    public PageResponse<ApplicationResponse> listApplications(@RequestParam(required = false) String status, Pageable pageable) {
        return PageResponse.from(
            recruitmentService.listApplications(status, pageable)
                .map(this::toApplicationResponse)
        );
    }

    @PostMapping("/applications")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public ApplicationResponse createApplication(@Valid @RequestBody CreateApplicationRequest request) {
        ApplicationStatus status;
        try {
            status = ApplicationStatus.valueOf(request.status().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_APPLICATION_STATUS: " + request.status());
        }
        RecruitmentApplication application = recruitmentService.createApplication(
            request.candidateId(),
            request.jobPostingId(),
            status
        );
        return toApplicationResponse(application);
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

    public record CreateJobPostingRequest(@NotBlank String title,
                                          String description,
                                          UUID departmentId,
                                          BigDecimal salaryRangeMin,
                                          BigDecimal salaryRangeMax,
                                          String requirements,
                                          String location,
                                          Integer headcount) {
    }

    public record CreateApplicationRequest(@NotNull UUID candidateId,
                                           @NotNull UUID jobPostingId,
                                           @NotBlank String status) {
    }

    public record ConvertRequest(@NotBlank String employeeNo, @NotNull UUID departmentId) {
    }

    public record CandidateResponse(UUID id, String fullName) {
    }

    public record JobPostingResponse(UUID id, String title, String description,
                                     UUID departmentId, String status,
                                     BigDecimal salaryRangeMin, BigDecimal salaryRangeMax,
                                     String requirements, String location, Integer headcount) {
    }

    public record ApplicationResponse(UUID id, String applicationNo, String candidateName, String jobTitle, String status) {
    }

    public record ConversionResponse(UUID employeeId, UUID applicationId, String applicationStatus) {
    }

    @PostMapping("/applications/{id}/move-stage")
    @PreAuthorize("hasAuthority('recruitment:update')")
    public ApplicationResponse moveStage(@PathVariable UUID id, @RequestParam String stage) {
        RecruitmentApplication application = recruitmentService.moveStage(id, stage);
        return toApplicationResponse(application);
    }

    private ApplicationResponse toApplicationResponse(RecruitmentApplication application) {
        return new ApplicationResponse(
            application.getId(),
            application.getApplicationNo(),
            application.getCandidate().getFullName(),
            application.getJobPosting().getTitle(),
            application.getStatus().name()
        );
    }

    private JobPostingResponse toJobPostingResponse(JobPosting jp) {
        return new JobPostingResponse(
            jp.getId(),
            jp.getTitle(),
            jp.getDescription(),
            jp.getDepartmentId(),
            jp.getStatus().name(),
            jp.getSalaryRangeMin(),
            jp.getSalaryRangeMax(),
            jp.getRequirements(),
            jp.getLocation(),
            jp.getHeadcount()
        );
    }

    @PostMapping("/interviews")
    @PreAuthorize("hasAuthority('recruitment:create')")
    public InterviewResponse scheduleInterview(@Valid @RequestBody ScheduleInterviewRequest request) {
        Interview interview = recruitmentService.scheduleInterview(
            request.applicationId(), request.interviewerId(), request.scheduledAt(),
            request.location(), request.meetingLink());
        return toInterviewResponse(interview);
    }

    @PutMapping("/interviews/{id}/feedback")
    @PreAuthorize("hasAuthority('recruitment:update')")
    public InterviewResponse addFeedback(@PathVariable UUID id, @Valid @RequestBody FeedbackRequest request) {
        return toInterviewResponse(recruitmentService.addFeedback(id, request.feedback(), request.rating()));
    }

    @GetMapping("/interviews")
    @PreAuthorize("hasAuthority('recruitment:read')")
    public PageResponse<InterviewResponse> listInterviews(@RequestParam(required = false) UUID applicationId,
                                                  Pageable pageable) {
        return PageResponse.from(recruitmentService.listInterviews(applicationId, pageable)
            .map(this::toInterviewResponse));
    }

    private InterviewResponse toInterviewResponse(Interview i) {
        return new InterviewResponse(i.getId(), i.getApplicationId(), i.getInterviewerId(),
            i.getScheduledAt(), i.getLocation(), i.getMeetingLink(), i.getFeedback(),
            i.getRating(), i.getStatus().name());
    }

    public record ScheduleInterviewRequest(@NotNull UUID applicationId, UUID interviewerId,
                                           Instant scheduledAt, String location, String meetingLink) {}
    public record FeedbackRequest(String feedback, Integer rating) {}
    public record InterviewResponse(UUID id, UUID applicationId, UUID interviewerId,
                                    Instant scheduledAt, String location, String meetingLink,
                                    String feedback, Integer rating, String status) {}
}
