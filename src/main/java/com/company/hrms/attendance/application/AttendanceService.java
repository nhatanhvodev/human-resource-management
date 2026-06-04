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
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
public class AttendanceService {
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveBalanceRepository leaveBalanceRepository;
    private final HolidayRepository holidayRepository;
    private final OvertimeRecordRepository overtimeRecordRepository;

    public AttendanceService(LeaveRequestRepository leaveRequestRepository,
                             LeaveBalanceRepository leaveBalanceRepository,
                             HolidayRepository holidayRepository,
                             OvertimeRecordRepository overtimeRecordRepository) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveBalanceRepository = leaveBalanceRepository;
        this.holidayRepository = holidayRepository;
        this.overtimeRecordRepository = overtimeRecordRepository;
    }

    @Transactional
    public LeaveRequest createLeaveRequest(UUID employeeId, LocalDate fromDate, LocalDate toDate,
                                            LeaveType leaveType, String reason) {
        LeaveRequest leaveRequest = new LeaveRequest(
            UUID.randomUUID(), TenantContext.get(), employeeId, fromDate, toDate,
            leaveType, reason, LeaveStatus.PENDING
        );
        return leaveRequestRepository.save(leaveRequest);
    }

    @Transactional
    public LeaveRequest approve(UUID leaveId) {
        LeaveRequest leaveRequest = findLeaveByIdScoped(leaveId);
        leaveRequest.approve();
        return leaveRequest;
    }

    @Transactional
    public LeaveRequest reject(UUID leaveId) {
        LeaveRequest leaveRequest = findLeaveByIdScoped(leaveId);
        leaveRequest.reject();
        return leaveRequest;
    }

    @Transactional(readOnly = true)
    public Page<LeaveRequest> list(String status, Pageable pageable) {
        String tenantId = TenantContext.get();
        String normalizedStatus = status == null ? null : status.trim();
        if (normalizedStatus == null || normalizedStatus.isEmpty()) {
            return leaveRequestRepository.findAllByTenantId(tenantId, pageable);
        }
        return leaveRequestRepository.findByTenantIdAndStatus(tenantId, parseLeaveStatus(normalizedStatus), pageable);
    }

    @Transactional(readOnly = true)
    public List<LeaveBalance> getLeaveBalances(UUID employeeId) {
        return leaveBalanceRepository.findByTenantIdAndEmployeeIdAndYear(TenantContext.get(), employeeId, LocalDate.now().getYear());
    }

    @Transactional(readOnly = true)
    public List<Holiday> getHolidays() {
        return holidayRepository.findByTenantIdOrderByDateAsc(TenantContext.get());
    }

    @Transactional(readOnly = true)
    public Page<OvertimeRecord> listOvertime(Pageable pageable) {
        return overtimeRecordRepository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional
    public OvertimeRecord approveOvertime(UUID overtimeId) {
        OvertimeRecord record = overtimeRecordRepository.findById(overtimeId)
            .orElseThrow(() -> new NotFoundException("OVERTIME_NOT_FOUND"));
        record.approve();
        return record;
    }

    @Transactional
    public OvertimeRecord rejectOvertime(UUID overtimeId) {
        OvertimeRecord record = overtimeRecordRepository.findById(overtimeId)
            .orElseThrow(() -> new NotFoundException("OVERTIME_NOT_FOUND"));
        record.reject();
        return record;
    }

    private LeaveRequest findLeaveByIdScoped(UUID leaveId) {
        return leaveRequestRepository.findByIdAndTenantId(leaveId, TenantContext.get())
            .orElseThrow(() -> new NotFoundException("LEAVE_NOT_FOUND"));
    }

    private static LeaveStatus parseLeaveStatus(String status) {
        try {
            return LeaveStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_LEAVE_STATUS");
        }
    }
}
