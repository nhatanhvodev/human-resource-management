package com.company.hrms.training.infrastructure;

import com.company.hrms.training.domain.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface CourseRepository extends JpaRepository<Course, UUID> {
    Page<Course> findByTenantId(String tenantId, Pageable pageable);
}
