package com.company.hrms.attendance.interfaces.api;

import com.company.hrms.attendance.application.AttendanceService;
import com.company.hrms.attendance.domain.LeaveRequest;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
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
            attendanceService.list(status, pageable)
                .map(AttendanceController::toResponse)
        );
    }

    @PostMapping("/leave-requests")
    @PreAuthorize("hasAuthority('leave:create')")
    public LeaveResponse create(@RequestBody CreateLeaveRequest request) {
        LeaveRequest leaveRequest = attendanceService.createLeaveRequest(request.employeeId(), request.fromDate(), request.toDate());
        return toResponse(leaveRequest);
    }

    @PostMapping("/leave-requests/{id}/approve")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse approve(@PathVariable UUID id) {
        LeaveRequest leaveRequest = attendanceService.approve(id);
        return toResponse(leaveRequest);
    }

    @PostMapping("/leave-requests/{id}/reject")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse reject(@PathVariable UUID id) {
        LeaveRequest leaveRequest = attendanceService.reject(id);
        return toResponse(leaveRequest);
    }

    private static LeaveResponse toResponse(LeaveRequest leaveRequest) {
        return new LeaveResponse(
            leaveRequest.getId(),
            leaveRequest.getEmployeeId(),
            leaveRequest.getFromDate(),
            leaveRequest.getToDate(),
            leaveRequest.getStatus().name()
        );
    }

    public record CreateLeaveRequest(@NotNull UUID employeeId, @NotNull LocalDate fromDate, @NotNull LocalDate toDate) {
    }

    public record LeaveResponse(UUID id, UUID employeeId, LocalDate fromDate, LocalDate toDate, String status) {
    }
}
