package com.company.hrms.training.infrastructure;

import com.company.hrms.training.domain.Certification;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface CertificationRepository extends JpaRepository<Certification, UUID> {
    List<Certification> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId);
}
