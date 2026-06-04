package com.company.hrms.training.infrastructure;

import com.company.hrms.training.domain.Enrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface EnrollmentRepository extends JpaRepository<Enrollment, UUID> {
    List<Enrollment> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId);
    List<Enrollment> findByTenantIdAndCourseId(String tenantId, UUID courseId);
    boolean existsByTenantIdAndEmployeeIdAndCourseId(String tenantId, UUID employeeId, UUID courseId);
}
