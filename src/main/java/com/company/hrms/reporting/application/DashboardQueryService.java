package com.company.hrms.reporting.application;

import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.infrastructure.LeaveRequestRepository;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.payroll.domain.PayrollPeriodStatus;
import com.company.hrms.payroll.infrastructure.PayrollPeriodRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;

@Service
public class DashboardQueryService {
    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;
    private final PayrollPeriodRepository payrollPeriodRepository;
    private final LeaveRequestRepository leaveRequestRepository;
    private final OutboxEventRepository outboxEventRepository;

    public DashboardQueryService(EmployeeRepository employeeRepository,
                                 DepartmentRepository departmentRepository,
                                 PayrollPeriodRepository payrollPeriodRepository,
                                 LeaveRequestRepository leaveRequestRepository,
                                 OutboxEventRepository outboxEventRepository) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
        this.payrollPeriodRepository = payrollPeriodRepository;
        this.leaveRequestRepository = leaveRequestRepository;
        this.outboxEventRepository = outboxEventRepository;
    }

    @Transactional(readOnly = true)
    public Summary summary() {
        String tenantId = TenantContext.get();
        long employeeCount = employeeRepository.countByTenantId(tenantId);
        long departmentCount = departmentRepository.countByTenantId(tenantId);
        long openPeriodCount = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.OPEN);
        long pendingLeaveCount = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
        return new Summary(employeeCount, departmentCount, openPeriodCount, pendingLeaveCount);
    }

    @Transactional(readOnly = true)
    public List<Activity> activities() {
        String tenantId = TenantContext.get();
        return outboxEventRepository.findTop20ByTenantIdOrderByCreatedAtDesc(tenantId).stream()
            .map(event -> new Activity(event.getEventType(), event.getPayload(), event.getCreatedAt()))
            .toList();
    }

    public record Summary(long employees, long departments, long openPayrollPeriods, long pendingLeaves) {
    }

    public record Activity(String type, String message, Instant timestamp) {
    }
}
