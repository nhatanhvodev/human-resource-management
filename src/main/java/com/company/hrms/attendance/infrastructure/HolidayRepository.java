package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.Holiday;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface HolidayRepository extends JpaRepository<Holiday, UUID> {
    List<Holiday> findByTenantIdOrderByDateAsc(String tenantId);
}
