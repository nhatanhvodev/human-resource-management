package com.company.hrms.attendance.interfaces.api;

import com.company.hrms.attendance.application.AttendanceService;
import com.company.hrms.attendance.domain.*;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
@Validated
public class AttendanceController {
    private final AttendanceService attendanceService;

    public AttendanceController(AttendanceService attendanceService) {
        this.attendanceService = attendanceService;
    }

    @GetMapping("/leave-requests")
    @PreAuthorize("hasAuthority('leave:read')")
    public PageResponse<LeaveResponse> list(@RequestParam(required = false) String status, Pageable pageable) {
        return PageResponse.from(
            attendanceService.list(status, pageable).map(AttendanceController::toResponse));
    }

    @PostMapping("/leave-requests")
    @PreAuthorize("hasAuthority('leave:create')")
    public LeaveResponse create(@RequestBody CreateLeaveRequest request) {
        LeaveRequest lr = attendanceService.createLeaveRequest(
            request.employeeId(), request.fromDate(), request.toDate(),
            request.leaveType() != null ? request.leaveType() : LeaveType.ANNUAL,
            request.reason());
        return toResponse(lr);
    }

    @PostMapping("/leave-requests/{id}/approve")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse approve(@PathVariable UUID id) {
        return toResponse(attendanceService.approve(id));
    }

    @PostMapping("/leave-requests/{id}/reject")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse reject(@PathVariable UUID id) {
        return toResponse(attendanceService.reject(id));
    }

    @GetMapping("/leave-balances")
    @PreAuthorize("hasAuthority('leave:read')")
    public List<LeaveBalanceResponse> balances(@RequestParam UUID employeeId) {
        return attendanceService.getLeaveBalances(employeeId).stream()
            .map(lb -> new LeaveBalanceResponse(lb.getId(), lb.getEmployeeId(), lb.getLeaveType().name(),
                lb.getYear(), lb.getTotalDays(), lb.getUsedDays(), lb.getPendingDays()))
            .toList();
    }

    @GetMapping("/holidays")
    @PreAuthorize("hasAuthority('leave:read')")
    public List<HolidayResponse> holidays() {
        return attendanceService.getHolidays().stream()
            .map(h -> new HolidayResponse(h.getId(), h.getName(), h.getDate(), h.getDescription(), h.isRecurringYearly()))
            .toList();
    }

    @GetMapping("/overtime")
    @PreAuthorize("hasAuthority('leave:read')")
    public PageResponse<OvertimeResponse> listOvertime(Pageable pageable) {
        return PageResponse.from(
            attendanceService.listOvertime(pageable)
                .map(r -> new OvertimeResponse(r.getId(), r.getEmployeeId(), r.getDate(), r.getHours(), r.getStatus().name())));
    }

    @PostMapping("/overtime/{id}/approve")
    @PreAuthorize("hasAuthority('leave:approve')")
    public OvertimeResponse approveOvertime(@PathVariable UUID id) {
        OvertimeRecord r = attendanceService.approveOvertime(id);
        return new OvertimeResponse(r.getId(), r.getEmployeeId(), r.getDate(), r.getHours(), r.getStatus().name());
    }

    @PostMapping("/overtime/{id}/reject")
    @PreAuthorize("hasAuthority('leave:approve')")
    public OvertimeResponse rejectOvertime(@PathVariable UUID id) {
        OvertimeRecord r = attendanceService.rejectOvertime(id);
        return new OvertimeResponse(r.getId(), r.getEmployeeId(), r.getDate(), r.getHours(), r.getStatus().name());
    }

    private static LeaveResponse toResponse(LeaveRequest lr) {
        return new LeaveResponse(lr.getId(), lr.getEmployeeId(), lr.getFromDate(), lr.getToDate(),
            lr.getLeaveType().name(), lr.getReason(), lr.getStatus().name(), lr.getApprovedBy());
    }

    public record CreateLeaveRequest(@NotNull UUID employeeId, @NotNull LocalDate fromDate,
                                     @NotNull LocalDate toDate, LeaveType leaveType, String reason) {}

    public record LeaveResponse(UUID id, UUID employeeId, LocalDate fromDate, LocalDate toDate,
                                String leaveType, String reason, String status, UUID approvedBy) {}

    public record LeaveBalanceResponse(UUID id, UUID employeeId, String leaveType, int year,
                                       int totalDays, int usedDays, int pendingDays) {}

    public record HolidayResponse(UUID id, String name, LocalDate date, String description, boolean recurringYearly) {}

    public record OvertimeResponse(UUID id, UUID employeeId, LocalDate date, BigDecimal hours, String status) {}
}
