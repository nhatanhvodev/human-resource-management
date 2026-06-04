package com.company.hrms.attendance.interfaces.api;

import com.company.hrms.attendance.application.TimeTrackingService;
import com.company.hrms.attendance.domain.TimeEntry;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/time-entries")
public class TimeTrackingController {
    private final TimeTrackingService service;

    public TimeTrackingController(TimeTrackingService service) {
        this.service = service;
    }

    @PostMapping("/clock-in")
    @PreAuthorize("hasAuthority('attendance:create')")
    public TimeEntryResponse clockIn(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return toResponse(service.clockIn(employeeId));
    }

    @PostMapping("/clock-out")
    @PreAuthorize("hasAuthority('attendance:create')")
    public TimeEntryResponse clockOut(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return toResponse(service.clockOut(employeeId));
    }

    @GetMapping("/mine")
    @PreAuthorize("hasAuthority('attendance:read')")
    public PageResponse<TimeEntryResponse> mine(@RequestHeader("X-Employee-Id") UUID employeeId,
                                                 @RequestParam(required = false) String from,
                                                 @RequestParam(required = false) String to,
                                                 Pageable pageable) {
        return PageResponse.from(service.listByEmployee(employeeId,
            from != null ? LocalDate.parse(from) : null,
            to != null ? LocalDate.parse(to) : null, pageable)
            .map(TimeTrackingController::toResponse));
    }

    @GetMapping
    @PreAuthorize("hasAuthority('attendance:read')")
    public PageResponse<TimeEntryResponse> list(@RequestParam(required = false) UUID employeeId,
                                                 @RequestParam(required = false) String from,
                                                 @RequestParam(required = false) String to,
                                                 @RequestParam(required = false) String status,
                                                 Pageable pageable) {
        return PageResponse.from(service.listAll(employeeId,
            from != null ? LocalDate.parse(from) : null,
            to != null ? LocalDate.parse(to) : null, status, pageable)
            .map(TimeTrackingController::toResponse));
    }

    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAuthority('attendance:approve')")
    public TimeEntryResponse approve(@PathVariable UUID id) {
        return toResponse(service.approve(id));
    }

    @PostMapping("/{id}/reject")
    @PreAuthorize("hasAuthority('attendance:approve')")
    public TimeEntryResponse reject(@PathVariable UUID id) {
        return toResponse(service.reject(id));
    }

    @GetMapping("/timesheet")
    @PreAuthorize("hasAuthority('attendance:read')")
    public List<TimeEntryResponse> timesheet(@RequestHeader("X-Employee-Id") UUID employeeId,
                                              @RequestParam String weekStart) {
        return service.timesheet(employeeId, LocalDate.parse(weekStart)).stream()
            .map(TimeTrackingController::toResponse).toList();
    }

    @GetMapping("/today")
    @PreAuthorize("hasAuthority('attendance:read')")
    public TimeEntryResponse today(@RequestHeader("X-Employee-Id") UUID employeeId) {
        TimeEntry e = service.todayStatus(employeeId);
        return e != null ? toResponse(e) : null;
    }

    private static TimeEntryResponse toResponse(TimeEntry e) {
        return new TimeEntryResponse(e.getId(), e.getEmployeeId(), e.getDate(),
            e.getClockIn(), e.getClockOut(), e.getTotalMinutes(), e.getStatus().name());
    }

    public record TimeEntryResponse(UUID id, UUID employeeId, LocalDate date,
                                     LocalTime clockIn, LocalTime clockOut,
                                     Integer totalMinutes, String status) {}
}
