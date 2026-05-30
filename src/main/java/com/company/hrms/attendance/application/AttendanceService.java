package com.company.hrms.attendance.application;

import com.company.hrms.attendance.domain.LeaveRequest;
import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.infrastructure.LeaveRequestRepository;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Locale;
import java.util.UUID;

@Service
public class AttendanceService {
    private final LeaveRequestRepository leaveRequestRepository;

    public AttendanceService(LeaveRequestRepository leaveRequestRepository) {
        this.leaveRequestRepository = leaveRequestRepository;
    }

    @Transactional
    public LeaveRequest createLeaveRequest(UUID employeeId, LocalDate fromDate, LocalDate toDate) {
        LeaveRequest leaveRequest = new LeaveRequest(
            UUID.randomUUID(),
            TenantContext.get(),
            employeeId,
            fromDate,
            toDate,
            LeaveStatus.PENDING
        );
        return leaveRequestRepository.save(leaveRequest);
    }

    @Transactional
    public LeaveRequest approve(UUID leaveId) {
        LeaveRequest leaveRequest = findByIdScoped(leaveId);
        leaveRequest.approve();
        return leaveRequest;
    }

    @Transactional
    public LeaveRequest reject(UUID leaveId) {
        LeaveRequest leaveRequest = findByIdScoped(leaveId);
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
        return leaveRequestRepository.findByTenantIdAndStatus(tenantId, parseStatus(normalizedStatus), pageable);
    }

    private LeaveRequest findByIdScoped(UUID leaveId) {
        return leaveRequestRepository.findByIdAndTenantId(leaveId, TenantContext.get())
            .orElseThrow(() -> new NotFoundException("LEAVE_NOT_FOUND"));
    }

    private static LeaveStatus parseStatus(String status) {
        try {
            return LeaveStatus.valueOf(status.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("INVALID_LEAVE_STATUS");
        }
    }
}
