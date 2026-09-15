package com.company.hrms.selfservice.interfaces.api;

import com.company.hrms.attendance.application.AttendanceService;
import com.company.hrms.attendance.application.TimeTrackingService;
import com.company.hrms.attendance.domain.*;
import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.payroll.application.PayrollService;
import com.company.hrms.payroll.domain.Payslip;
import com.company.hrms.performance.application.PerformanceService;
import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.security.SecurityUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/self")
@PreAuthorize("hasAuthority('self:access')")
public class SelfServiceController {
    private final EmployeeService employeeService;
    private final AttendanceService attendanceService;
    private final TimeTrackingService timeTrackingService;
    private final PayrollService payrollService;
    private final PerformanceService performanceService;

    public SelfServiceController(EmployeeService employeeService, AttendanceService attendanceService,
                                  TimeTrackingService timeTrackingService, PayrollService payrollService,
                                  PerformanceService performanceService) {
        this.employeeService = employeeService;
        this.attendanceService = attendanceService;
        this.timeTrackingService = timeTrackingService;
        this.payrollService = payrollService;
        this.performanceService = performanceService;
    }

    @GetMapping("/profile")
    public ProfileResponse profile(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        Employee e = employeeService.getById(employeeId);
        return new ProfileResponse(e.getId(), e.getEmployeeNo(), e.getFullName(),
            e.getDepartment().getId(), e.getDepartment().getName(), e.getEmploymentStatus().name(), e.getHireDate(),
            e.getEmail(), e.getPhone(),
            e.getPosition() != null ? e.getPosition().getTitle() : null,
            e.getDateOfBirth(), e.getGender() != null ? e.getGender().name() : null,
            e.getAddress(), e.getBankAccount(), e.getTaxCode());
    }

    @PutMapping("/profile")
    public ProfileResponse updateProfile(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId,
                                          @RequestBody UpdateSelfProfileRequest request) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        Employee e = employeeService.updateExtended(employeeId, request.fullName(),
            request.departmentId(), request.hireDate(),
            request.email(), request.phone(), request.positionId(), request.dateOfBirth(),
            request.gender(), request.nationalId(), request.address(),
            request.bankAccount(), request.taxCode());
        return new ProfileResponse(e.getId(), e.getEmployeeNo(), e.getFullName(),
            e.getDepartment().getId(), e.getDepartment().getName(), e.getEmploymentStatus().name(), e.getHireDate(),
            e.getEmail(), e.getPhone(),
            e.getPosition() != null ? e.getPosition().getTitle() : null,
            e.getDateOfBirth(), e.getGender() != null ? e.getGender().name() : null,
            e.getAddress(), e.getBankAccount(), e.getTaxCode());
    }

    @GetMapping("/leave-balances")
    public List<LeaveBalanceDto> leaveBalances(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return attendanceService.getLeaveBalances(employeeId).stream()
            .map(lb -> new LeaveBalanceDto(lb.getLeaveType().name(), lb.getTotalDays(), lb.getUsedDays(), lb.getPendingDays()))
            .toList();
    }

    @PostMapping("/leave-requests")
    public LeaveDto createLeave(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId,
                                 @RequestBody CreateSelfLeaveRequest request) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        LeaveRequest lr = attendanceService.createLeaveRequest(employeeId, request.fromDate(), request.toDate(),
            request.leaveType() != null ? request.leaveType() : LeaveType.ANNUAL, request.reason());
        return new LeaveDto(lr.getId(), lr.getLeaveType().name(), lr.getFromDate(), lr.getToDate(), lr.getStatus().name());
    }

    @GetMapping("/leave-requests")
    public PageResponse<LeaveDto> leaveRequests(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId, Pageable pageable) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return PageResponse.from(attendanceService.listByEmployee(employeeId, pageable)
            .map(lr -> new LeaveDto(lr.getId(), lr.getLeaveType().name(), lr.getFromDate(), lr.getToDate(), lr.getStatus().name())));
    }

    @GetMapping("/time-entries")
    public PageResponse<TimeEntryDto> timeEntries(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId, Pageable pageable) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return PageResponse.from(timeTrackingService.listByEmployee(employeeId, null, null, pageable)
            .map(SelfServiceController::toTimeEntryDto));
    }

    @PostMapping("/time-entries/clock-in")
    public TimeEntryDto clockIn(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return toTimeEntryDto(timeTrackingService.clockIn(employeeId));
    }

    @PostMapping("/time-entries/clock-out")
    public TimeEntryDto clockOut(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return toTimeEntryDto(timeTrackingService.clockOut(employeeId));
    }

    @GetMapping("/payslips")
    public List<PayslipDto> payslips(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return payrollService.getEmployeePayslips(employeeId).stream()
            .map(p -> new PayslipDto(p.getId(), p.getBasicSalary(), p.getAllowance(), p.getDeduction(),
                p.getOvertimePay(), p.getNetPay(), p.getIssuedAt()))
            .toList();
    }

    @GetMapping("/reviews")
    public List<ReviewDto> reviews(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return performanceService.listReviewsByEmployee(employeeId).stream()
            .map(r -> new ReviewDto(r.id(), r.cycleName(), r.reviewerType(),
                r.overallScore(), r.status()))
            .toList();
    }

    private static TimeEntryDto toTimeEntryDto(TimeEntry e) {
        return new TimeEntryDto(e.getId(), e.getDate(), e.getClockIn(), e.getClockOut(), e.getTotalMinutes(), e.getStatus().name());
    }

    public record ProfileResponse(UUID id, String employeeNo, String fullName,
                                   UUID departmentId, String departmentName, String employmentStatus, LocalDate hireDate,
                                   String email, String phone, String positionTitle,
                                   LocalDate dateOfBirth, String gender,
                                   String address, String bankAccount, String taxCode) {}

    public record UpdateSelfProfileRequest(String fullName, UUID departmentId, LocalDate hireDate,
                                            String email, String phone, UUID positionId, LocalDate dateOfBirth,
                                            String gender, String nationalId, String address,
                                            String bankAccount, String taxCode) {}

    public record LeaveBalanceDto(String leaveType, int totalDays, int usedDays, int pendingDays) {}
    public record CreateSelfLeaveRequest(LocalDate fromDate, LocalDate toDate, LeaveType leaveType, String reason) {}
    public record LeaveDto(UUID id, String leaveType, LocalDate fromDate, LocalDate toDate, String status) {}
    public record TimeEntryDto(UUID id, LocalDate date, LocalTime clockIn, LocalTime clockOut,
                               Integer totalMinutes, String status) {}
    public record PayslipDto(UUID id, BigDecimal basicSalary, BigDecimal allowance, BigDecimal deduction,
                              BigDecimal overtimePay, BigDecimal netPay, Instant issuedAt) {}
    public record ReviewDto(UUID id, String cycleName, String reviewerType, BigDecimal overallScore, String status) {}
}
