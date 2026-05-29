package com.company.hrms.attendance.interfaces.api;

import com.company.hrms.attendance.application.AttendanceService;
import com.company.hrms.attendance.domain.LeaveRequest;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
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

    @PostMapping("/leave-requests")
    @PreAuthorize("hasAuthority('leave:create')")
    public LeaveResponse create(@RequestBody CreateLeaveRequest request) {
        LeaveRequest leaveRequest = attendanceService.createLeaveRequest(request.employeeId(), request.fromDate(), request.toDate());
        return new LeaveResponse(leaveRequest.getId(), leaveRequest.getStatus().name());
    }

    @PostMapping("/leave-requests/{id}/approve")
    @PreAuthorize("hasAuthority('leave:approve')")
    public LeaveResponse approve(@PathVariable UUID id) {
        LeaveRequest leaveRequest = attendanceService.approve(id);
        return new LeaveResponse(leaveRequest.getId(), leaveRequest.getStatus().name());
    }

    public record CreateLeaveRequest(@NotNull UUID employeeId, @NotNull LocalDate fromDate, @NotNull LocalDate toDate) {
    }

    public record LeaveResponse(UUID id, String status) {
    }
}
