package com.company.hrms.attendance.application;

import com.company.hrms.attendance.domain.*;
import com.company.hrms.attendance.infrastructure.*;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Service
public class TimeTrackingService {
    private final TimeEntryRepository timeEntryRepository;

    public TimeTrackingService(TimeEntryRepository timeEntryRepository) {
        this.timeEntryRepository = timeEntryRepository;
    }

    @Transactional
    public TimeEntry clockIn(UUID employeeId) {
        String tenantId = TenantContext.get();
        LocalDate today = LocalDate.now();
        timeEntryRepository.findByTenantIdAndEmployeeIdAndDate(tenantId, employeeId, today)
            .ifPresent(e -> { throw new IllegalStateException("ALREADY_CLOCKED_IN"); });
        TimeEntry entry = new TimeEntry(UUID.randomUUID(), tenantId, employeeId, today);
        entry.clockIn(LocalTime.now());
        return timeEntryRepository.save(entry);
    }

    @Transactional
    public TimeEntry clockOut(UUID employeeId) {
        String tenantId = TenantContext.get();
        TimeEntry entry = timeEntryRepository
            .findByTenantIdAndEmployeeIdAndDate(tenantId, employeeId, LocalDate.now())
            .orElseThrow(() -> new NotFoundException("NO_CLOCK_IN"));
        entry.clockOut(LocalTime.now());
        return entry;
    }

    @Transactional(readOnly = true)
    public Page<TimeEntry> listByEmployee(UUID employeeId, LocalDate from, LocalDate to, Pageable pageable) {
        return timeEntryRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<TimeEntry> listAll(UUID employeeId, LocalDate from, LocalDate to, String status, Pageable pageable) {
        if (employeeId != null) {
            return timeEntryRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId, pageable);
        }
        return timeEntryRepository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public List<TimeEntry> timesheet(UUID employeeId, LocalDate weekStart) {
        return timeEntryRepository.findByTenantIdAndEmployeeIdAndDateBetween(
            TenantContext.get(), employeeId, weekStart, weekStart.plusDays(6));
    }

    @Transactional
    public TimeEntry approve(UUID id) {
        TimeEntry e = timeEntryRepository.findById(id).orElseThrow(() -> new NotFoundException("ENTRY_NOT_FOUND"));
        e.approve();
        return e;
    }

    @Transactional
    public TimeEntry reject(UUID id) {
        TimeEntry e = timeEntryRepository.findById(id).orElseThrow(() -> new NotFoundException("ENTRY_NOT_FOUND"));
        e.reject();
        return e;
    }

    @Transactional(readOnly = true)
    public TimeEntry todayStatus(UUID employeeId) {
        return timeEntryRepository.findByTenantIdAndEmployeeIdAndDate(
            TenantContext.get(), employeeId, LocalDate.now()).orElse(null);
    }
}
