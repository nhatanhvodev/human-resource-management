package com.company.hrms.attendance.application;

import com.company.hrms.attendance.domain.LeaveRequest;
import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.infrastructure.LeaveRequestRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
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
        LeaveRequest leaveRequest = leaveRequestRepository.findById(leaveId)
            .orElseThrow(() -> new IllegalArgumentException("LEAVE_NOT_FOUND"));
        leaveRequest.setStatus(LeaveStatus.APPROVED);
        return leaveRequest;
    }
}
