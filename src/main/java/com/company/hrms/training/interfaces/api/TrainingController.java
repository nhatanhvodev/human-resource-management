package com.company.hrms.training.interfaces.api;

import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.training.application.TrainingService;
import com.company.hrms.training.domain.Certification;
import com.company.hrms.training.domain.Course;
import com.company.hrms.training.domain.Enrollment;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/training")
public class TrainingController {
    private final TrainingService service;

    public TrainingController(TrainingService service) { this.service = service; }

    @PostMapping("/courses")
    @PreAuthorize("hasAuthority('training:create')")
    public CourseResponse createCourse(@RequestBody CreateCourseRequest request) {
        Course c = service.createCourse(request.title(), request.description(), request.category(),
            request.durationHours(), request.instructorName(), request.startDate(), request.endDate());
        return toCourseResponse(c);
    }

    @GetMapping("/courses")
    @PreAuthorize("hasAuthority('training:read')")
    public PageResponse<CourseResponse> listCourses(Pageable pageable) {
        return PageResponse.from(service.listCourses(pageable).map(TrainingController::toCourseResponse));
    }

    @PostMapping("/enroll")
    @PreAuthorize("hasAuthority('training:create')")
    public EnrollmentResponse enroll(@RequestBody EnrollRequest request) {
        return toEnrollmentResponse(service.enroll(request.courseId(), request.employeeId()));
    }

    @GetMapping("/enrollments/employee/{employeeId}")
    @PreAuthorize("hasAuthority('training:read')")
    public List<EnrollmentResponse> listEnrollmentsByEmployee(@PathVariable UUID employeeId) {
        return service.listEnrollmentsByEmployee(employeeId).stream()
            .map(TrainingController::toEnrollmentResponse).toList();
    }

    @GetMapping("/enrollments/course/{courseId}")
    @PreAuthorize("hasAuthority('training:read')")
    public List<EnrollmentResponse> listEnrollmentsByCourse(@PathVariable UUID courseId) {
        return service.listEnrollmentsByCourse(courseId).stream()
            .map(TrainingController::toEnrollmentResponse).toList();
    }

    @PutMapping("/enrollments/{id}/progress")
    @PreAuthorize("hasAuthority('training:update')")
    public EnrollmentResponse updateProgress(@PathVariable UUID id, @RequestBody UpdateProgressRequest request) {
        return toEnrollmentResponse(service.updateProgress(id, request.progress()));
    }

    @PostMapping("/certifications")
    @PreAuthorize("hasAuthority('training:create')")
    public CertificationResponse issueCertification(@RequestBody IssueCertificationRequest request) {
        Certification cert = service.issueCertification(request.employeeId(), request.courseId(),
            request.name(), request.issuedAt(), request.expiryDate(), request.credentialUrl());
        return toCertificationResponse(cert);
    }

    @GetMapping("/certifications/{employeeId}")
    @PreAuthorize("hasAuthority('training:read')")
    public List<CertificationResponse> listCertifications(@PathVariable UUID employeeId) {
        return service.listCertifications(employeeId).stream()
            .map(TrainingController::toCertificationResponse).toList();
    }

    private static CourseResponse toCourseResponse(Course c) {
        return new CourseResponse(c.getId(), c.getTitle(), c.getDescription(), c.getCategory(),
            c.getDurationHours(), c.getInstructorName(), c.getStartDate(), c.getEndDate());
    }

    private static EnrollmentResponse toEnrollmentResponse(Enrollment e) {
        return new EnrollmentResponse(e.getId(), e.getCourseId(), e.getEmployeeId(),
            e.getProgress(), e.getStatus().name(), e.getEnrolledAt());
    }

    private static CertificationResponse toCertificationResponse(Certification c) {
        return new CertificationResponse(c.getId(), c.getEmployeeId(), c.getCourseId(),
            c.getName(), c.getIssuedAt(), c.getExpiryDate(), c.getCredentialUrl());
    }

    public record CreateCourseRequest(String title, String description, String category,
                                       Integer durationHours, String instructorName,
                                       LocalDate startDate, LocalDate endDate) {}
    public record CourseResponse(UUID id, String title, String description, String category,
                                  Integer durationHours, String instructorName,
                                  LocalDate startDate, LocalDate endDate) {}
    public record EnrollRequest(UUID courseId, UUID employeeId) {}
    public record EnrollmentResponse(UUID id, UUID courseId, UUID employeeId,
                                      int progress, String status, java.time.Instant enrolledAt) {}
    public record UpdateProgressRequest(int progress) {}
    public record IssueCertificationRequest(UUID employeeId, UUID courseId, String name,
                                             LocalDate issuedAt, LocalDate expiryDate, String credentialUrl) {}
    public record CertificationResponse(UUID id, UUID employeeId, UUID courseId, String name,
                                         LocalDate issuedAt, LocalDate expiryDate, String credentialUrl) {}
}
