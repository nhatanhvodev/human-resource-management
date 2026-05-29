package com.company.hrms.payroll.application;

import com.company.hrms.payroll.domain.PayrollPeriod;
import com.company.hrms.payroll.domain.PayrollPeriodStatus;
import com.company.hrms.payroll.domain.PayrollRun;
import com.company.hrms.payroll.domain.PayrollRunStatus;
import com.company.hrms.payroll.infrastructure.PayrollPeriodRepository;
import com.company.hrms.payroll.infrastructure.PayrollRunRepository;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.UUID;

@Service
public class PayrollService {
    private final PayrollPeriodRepository payrollPeriodRepository;
    private final PayrollRunRepository payrollRunRepository;

    public PayrollService(PayrollPeriodRepository payrollPeriodRepository,
                          PayrollRunRepository payrollRunRepository) {
        this.payrollPeriodRepository = payrollPeriodRepository;
        this.payrollRunRepository = payrollRunRepository;
    }

    @Transactional
    public PayrollPeriod createPeriod(LocalDate fromDate, LocalDate toDate) {
        PayrollPeriod payrollPeriod = new PayrollPeriod(
            UUID.randomUUID(),
            TenantContext.get(),
            fromDate,
            toDate,
            PayrollPeriodStatus.OPEN
        );
        return payrollPeriodRepository.save(payrollPeriod);
    }

    @Transactional
    public PayrollRun execute(UUID periodId) {
        PayrollPeriod period = payrollPeriodRepository.findByIdAndTenantId(periodId, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("PAYROLL_PERIOD_NOT_FOUND"));
        if (period.isClosed()) {
            throw new ConflictException("PAYROLL_PERIOD_LOCKED");
        }
        return payrollRunRepository.save(new PayrollRun(UUID.randomUUID(), TenantContext.get(), period, PayrollRunStatus.EXECUTED));
    }

    @Transactional
    public PayrollPeriod closePeriod(UUID periodId) {
        PayrollPeriod period = payrollPeriodRepository.findByIdAndTenantId(periodId, TenantContext.get())
            .orElseThrow(() -> new IllegalArgumentException("PAYROLL_PERIOD_NOT_FOUND"));
        period.close();
        return period;
    }
}
