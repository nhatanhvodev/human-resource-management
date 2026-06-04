package com.company.hrms.payroll.application;

import com.company.hrms.payroll.domain.*;
import com.company.hrms.payroll.infrastructure.*;
import com.company.hrms.shared.exception.ConflictException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class PayrollService {
    private final PayrollPeriodRepository payrollPeriodRepository;
    private final PayrollRunRepository payrollRunRepository;
    private final PayslipRepository payslipRepository;

    public PayrollService(PayrollPeriodRepository payrollPeriodRepository,
                          PayrollRunRepository payrollRunRepository,
                          PayslipRepository payslipRepository) {
        this.payrollPeriodRepository = payrollPeriodRepository;
        this.payrollRunRepository = payrollRunRepository;
        this.payslipRepository = payslipRepository;
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

    @Transactional(readOnly = true)
    public Page<PayrollPeriod> listPeriods(Pageable pageable) {
        return payrollPeriodRepository.findAllByTenantId(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public Page<PayrollRun> listRuns(UUID periodId, Pageable pageable) {
        return payrollRunRepository.findByTenantIdAndPayrollPeriodId(TenantContext.get(), periodId, pageable);
    }

    @Transactional(readOnly = true)
    public List<Payslip> getPayslipsByRun(UUID payrollRunId) {
        return payslipRepository.findByTenantIdAndPayrollRun_Id(TenantContext.get(), payrollRunId);
    }

    @Transactional(readOnly = true)
    public List<Payslip> getEmployeePayslips(UUID employeeId) {
        return payslipRepository.findByTenantIdAndEmployee_Id(TenantContext.get(), employeeId);
    }
}
