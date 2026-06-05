package com.company.hrms.attendance.application;

import com.company.hrms.attendance.domain.*;
import com.company.hrms.attendance.infrastructure.*;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
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
    private final EmployeeRepository employeeRepository;
    private final JdbcTemplate jdbcTemplate;

    public AttendanceService(LeaveRequestRepository leaveRequestRepository,
                             LeaveBalanceRepository leaveBalanceRepository,
                             HolidayRepository holidayRepository,
                             OvertimeRecordRepository overtimeRecordRepository,
                             EmployeeRepository employeeRepository,
                             JdbcTemplate jdbcTemplate) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveBalanceRepository = leaveBalanceRepository;
        this.holidayRepository = holidayRepository;
        this.overtimeRecordRepository = overtimeRecordRepository;
        this.employeeRepository = employeeRepository;
        this.jdbcTemplate = jdbcTemplate;
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
        UUID currentEmployeeId = getCurrentEmployeeId();
        if (currentEmployeeId != null) {
            assertCanManage(TenantContext.get(), currentEmployeeId, leaveRequest.getEmployeeId());
        }
        leaveRequest.approve();
        leaveRequest.setApprovedBy(currentEmployeeId);
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

    private void assertCanManage(String tenantId, UUID managerId, UUID employeeId) {
        Employee target = employeeRepository.findByIdAndTenantId(employeeId, tenantId).orElse(null);
        if (target == null) return;
        boolean isDirectManager = target.getManagerId() != null && target.getManagerId().equals(managerId);
        if (isDirectManager) return;
        List<UUID> scopedDeptIds = jdbcTemplate.queryForList(
            "select department_id from security_role_scope where user_id = ?",
            UUID.class, managerId
        );
        if (target.getDepartment() != null && scopedDeptIds.contains(target.getDepartment().getId())) return;
        throw new AccessDeniedException("NOT_YOUR_SUBORDINATE");
    }

    private UUID getCurrentEmployeeId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String empId = jwtAuth.getToken().getClaimAsString("employee_id");
            if (empId != null) return UUID.fromString(empId);
        }
        return null;
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
