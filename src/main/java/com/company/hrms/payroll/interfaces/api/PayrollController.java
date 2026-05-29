package com.company.hrms.payroll.interfaces.api;

import com.company.hrms.payroll.application.PayrollService;
import com.company.hrms.payroll.domain.PayrollPeriod;
import com.company.hrms.payroll.domain.PayrollRun;
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
public class PayrollController {
    private final PayrollService payrollService;

    public PayrollController(PayrollService payrollService) {
        this.payrollService = payrollService;
    }

    @PostMapping("/payroll-periods")
    @PreAuthorize("hasAuthority('payroll:create')")
    public PayrollPeriodResponse createPeriod(@RequestBody CreatePeriodRequest request) {
        PayrollPeriod period = payrollService.createPeriod(request.fromDate(), request.toDate());
        return new PayrollPeriodResponse(period.getId(), period.getStatus().name());
    }

    @PostMapping("/payroll-runs/{periodId}/execute")
    @PreAuthorize("hasAuthority('payroll:execute')")
    public PayrollRunResponse execute(@PathVariable UUID periodId) {
        PayrollRun run = payrollService.execute(periodId);
        return new PayrollRunResponse(run.getId());
    }

    @PostMapping("/payroll-periods/{periodId}/close")
    @PreAuthorize("hasAuthority('payroll:approve')")
    public PayrollPeriodResponse close(@PathVariable UUID periodId) {
        PayrollPeriod period = payrollService.closePeriod(periodId);
        return new PayrollPeriodResponse(period.getId(), period.getStatus().name());
    }

    public record CreatePeriodRequest(@NotNull LocalDate fromDate, @NotNull LocalDate toDate) {
    }

    public record PayrollPeriodResponse(UUID id, String status) {
    }

    public record PayrollRunResponse(UUID id) {
    }
}
