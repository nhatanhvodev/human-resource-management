package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.TimeEntry;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TimeEntryRepository extends JpaRepository<TimeEntry, UUID> {
    Page<TimeEntry> findByTenantId(String tenantId, Pageable pageable);

    Page<TimeEntry> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId, Pageable pageable);

    List<TimeEntry> findByTenantIdAndEmployeeIdAndDateBetween(
        String tenantId, UUID employeeId, LocalDate from, LocalDate to);

    Optional<TimeEntry> findByTenantIdAndEmployeeIdAndDate(
        String tenantId, UUID employeeId, LocalDate date);
}
