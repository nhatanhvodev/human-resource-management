package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.EmergencyContact;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EmergencyContactRepository extends JpaRepository<EmergencyContact, UUID> {
    List<EmergencyContact> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
