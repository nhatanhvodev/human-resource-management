package com.company.hrms.reporting.application;

import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.infrastructure.LeaveRequestRepository;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.payroll.domain.PayrollPeriodStatus;
import com.company.hrms.payroll.infrastructure.PayrollPeriodRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

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
        long activeEmployeeCount = employeeRepository.countByTenantIdAndEmploymentStatus(tenantId, EmploymentStatus.ACTIVE);
        long departmentCount = departmentRepository.countByTenantId(tenantId);
        long openPeriodCount = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.OPEN);
        long pendingLeaveCount = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
        return new Summary(employeeCount, activeEmployeeCount, departmentCount, openPeriodCount, pendingLeaveCount);
    }

    @Transactional(readOnly = true)
    public List<DepartmentHeadcount> headcountByDepartment() {
        String tenantId = TenantContext.get();
        return departmentRepository.findAllByTenantId(tenantId).stream()
            .map(dept -> {
                long count = employeeRepository.countByTenantIdAndDepartment_Id(tenantId, dept.getId());
                return new DepartmentHeadcount(dept.getId(), dept.getName(), count);
            })
            .toList();
    }

    @Transactional(readOnly = true)
    public List<Activity> activities() {
        String tenantId = TenantContext.get();
        return outboxEventRepository.findTop20ByTenantIdOrderByCreatedAtDesc(tenantId).stream()
            .map(event -> new Activity(event.getEventType(), event.getPayload(), event.getCreatedAt()))
            .toList();
    }

    public record Summary(long totalEmployees, long activeEmployees, long departments,
                          long openPayrollPeriods, long pendingLeaves) {}

    public record DepartmentHeadcount(UUID departmentId, String departmentName, long count) {}

    public record Activity(String type, String message, Instant timestamp) {}

    @Transactional(readOnly = true)
    public List<DepartmentDistribution> departmentDistribution() {
        String tenantId = TenantContext.get();
        return departmentRepository.findAllByTenantId(tenantId).stream()
            .map(d -> {
                long count = employeeRepository.countByTenantIdAndDepartment_Id(tenantId, d.getId());
                return new DepartmentDistribution(d.getName(), count);
            }).toList();
    }

    @Transactional(readOnly = true)
    public LeaveSummary leaveSummary() {
        String tenantId = TenantContext.get();
        long pending = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
        long approved = leaveRequestRepository.findByTenantIdAndStatus(tenantId, LeaveStatus.APPROVED, org.springframework.data.domain.Pageable.unpaged()).getTotalElements();
        long rejected = leaveRequestRepository.findByTenantIdAndStatus(tenantId, LeaveStatus.REJECTED, org.springframework.data.domain.Pageable.unpaged()).getTotalElements();
        return new LeaveSummary(pending + approved + rejected, approved, pending);
    }

    @Transactional(readOnly = true)
    public PayrollSummary payrollSummary() {
        String tenantId = TenantContext.get();
        long open = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.OPEN);
        long closed = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.CLOSED);
        return new PayrollSummary(open + closed, closed, open);
    }

    public record DepartmentDistribution(String name, long count) {}
    public record LeaveSummary(long total, long approved, long pending) {}
    public record PayrollSummary(long total, long closed, long open) {}
}
