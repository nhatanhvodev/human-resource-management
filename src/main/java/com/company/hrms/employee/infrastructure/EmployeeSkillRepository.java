package com.company.hrms.employee.infrastructure;

import com.company.hrms.employee.domain.EmployeeSkill;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EmployeeSkillRepository extends JpaRepository<EmployeeSkill, UUID> {
    List<EmployeeSkill> findByTenantIdAndEmployee_Id(String tenantId, UUID employeeId);
}
