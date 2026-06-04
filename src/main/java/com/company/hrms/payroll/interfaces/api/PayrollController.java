package com.company.hrms.payroll.interfaces.api;

import com.company.hrms.payroll.application.PayrollService;
import com.company.hrms.payroll.domain.PayrollPeriod;
import com.company.hrms.payroll.domain.PayrollRun;
import com.company.hrms.payroll.domain.Payslip;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
@Validated
public class PayrollController {
    private final PayrollService payrollService;

    public PayrollController(PayrollService payrollService) {
        this.payrollService = payrollService;
    }

    @GetMapping("/payroll-periods")
    @PreAuthorize("hasAuthority('payroll:read')")
    public PageResponse<PayrollPeriodResponse> listPeriods(Pageable pageable) {
        return PageResponse.from(
            payrollService.listPeriods(pageable)
                .map(PayrollController::toPeriodResponse)
        );
    }

    @PostMapping("/payroll-periods")
    @PreAuthorize("hasAuthority('payroll:create')")
    public PayrollPeriodResponse createPeriod(@RequestBody CreatePeriodRequest request) {
        PayrollPeriod period = payrollService.createPeriod(request.fromDate(), request.toDate());
        return toPeriodResponse(period);
    }

    @GetMapping("/payroll-runs")
    @PreAuthorize("hasAuthority('payroll:read')")
    public PageResponse<PayrollRunResponse> listRuns(@RequestParam UUID periodId, Pageable pageable) {
        return PageResponse.from(
            payrollService.listRuns(periodId, pageable)
                .map(PayrollController::toRunResponse)
        );
    }

    @PostMapping("/payroll-runs/{periodId}/execute")
    @PreAuthorize("hasAuthority('payroll:execute')")
    public PayrollRunResponse execute(@PathVariable UUID periodId) {
        PayrollRun run = payrollService.execute(periodId);
        return toRunResponse(run);
    }

    @PostMapping("/payroll-periods/{periodId}/close")
    @PreAuthorize("hasAuthority('payroll:approve')")
    public PayrollPeriodResponse close(@PathVariable UUID periodId) {
        PayrollPeriod period = payrollService.closePeriod(periodId);
        return toPeriodResponse(period);
    }

    @GetMapping("/payroll-runs/{runId}/payslips")
    @PreAuthorize("hasAuthority('payroll:read')")
    public List<PayslipResponse> payslipsByRun(@PathVariable UUID runId) {
        return payrollService.getPayslipsByRun(runId).stream()
            .map(PayrollController::toPayslipResponse)
            .toList();
    }

    private static PayslipResponse toPayslipResponse(Payslip p) {
        return new PayslipResponse(p.getId(), p.getPayrollRun().getId(), p.getEmployee().getId(),
            p.getBasicSalary(), p.getAllowance(), p.getDeduction(), p.getOvertimePay(), p.getNetPay(), p.getIssuedAt());
    }

    private static PayrollPeriodResponse toPeriodResponse(PayrollPeriod period) {
        return new PayrollPeriodResponse(period.getId(), period.getPeriodFrom(), period.getPeriodTo(), period.getStatus().name());
    }

    private static PayrollRunResponse toRunResponse(PayrollRun run) {
        return new PayrollRunResponse(run.getId(), run.getStatus().name());
    }

    public record CreatePeriodRequest(@NotNull LocalDate fromDate, @NotNull LocalDate toDate) {}
    public record PayrollPeriodResponse(UUID id, LocalDate periodFrom, LocalDate periodTo, String status) {}
    public record PayrollRunResponse(UUID id, String status) {}
    public record PayslipResponse(UUID id, UUID payrollRunId, UUID employeeId, BigDecimal basicSalary,
                                   BigDecimal allowance, BigDecimal deduction, BigDecimal overtimePay,
                                   BigDecimal netPay, Instant issuedAt) {}
}
