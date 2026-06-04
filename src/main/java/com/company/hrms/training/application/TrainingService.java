package com.company.hrms.training.application;

import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import com.company.hrms.training.domain.*;
import com.company.hrms.training.infrastructure.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class TrainingService {
    private final CourseRepository courseRepository;
    private final EnrollmentRepository enrollmentRepository;
    private final CertificationRepository certificationRepository;

    public TrainingService(CourseRepository courseRepository,
                           EnrollmentRepository enrollmentRepository,
                           CertificationRepository certificationRepository) {
        this.courseRepository = courseRepository;
        this.enrollmentRepository = enrollmentRepository;
        this.certificationRepository = certificationRepository;
    }

    @Transactional
    public Course createCourse(String title, String description, String category, Integer durationHours,
                                String instructorName, LocalDate startDate, LocalDate endDate) {
        return courseRepository.save(new Course(UUID.randomUUID(), TenantContext.get(), title, description,
            category, durationHours, instructorName, startDate, endDate));
    }

    @Transactional(readOnly = true)
    public Page<Course> listCourses(Pageable pageable) {
        return courseRepository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional
    public Enrollment enroll(UUID courseId, UUID employeeId) {
        String tenantId = TenantContext.get();
        if (enrollmentRepository.existsByTenantIdAndEmployeeIdAndCourseId(tenantId, employeeId, courseId)) {
            throw new IllegalStateException("Already enrolled");
        }
        return enrollmentRepository.save(new Enrollment(UUID.randomUUID(), tenantId, courseId, employeeId));
    }

    @Transactional(readOnly = true)
    public List<Enrollment> listEnrollmentsByEmployee(UUID employeeId) {
        return enrollmentRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId);
    }

    @Transactional(readOnly = true)
    public List<Enrollment> listEnrollmentsByCourse(UUID courseId) {
        return enrollmentRepository.findByTenantIdAndCourseId(TenantContext.get(), courseId);
    }

    @Transactional
    public Enrollment updateProgress(UUID enrollmentId, int progress) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
            .orElseThrow(() -> new NotFoundException("Enrollment not found: " + enrollmentId));
        enrollment.updateProgress(progress);
        return enrollmentRepository.save(enrollment);
    }

    @Transactional
    public Certification issueCertification(UUID employeeId, UUID courseId, String name,
                                            LocalDate issuedAt, LocalDate expiryDate, String credentialUrl) {
        return certificationRepository.save(new Certification(UUID.randomUUID(), TenantContext.get(),
            employeeId, courseId, name, issuedAt, expiryDate, credentialUrl));
    }

    @Transactional(readOnly = true)
    public List<Certification> listCertifications(UUID employeeId) {
        return certificationRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId);
    }
}
