package com.company.hrms.reporting.application;

import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.infrastructure.LeaveRequestRepository;
import com.company.hrms.audit.infrastructure.AuditLogRepository;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.organization.infrastructure.DepartmentRepository;
import com.company.hrms.payroll.domain.PayrollPeriodStatus;
import com.company.hrms.payroll.infrastructure.PayrollPeriodRepository;
import com.company.hrms.shared.security.DepartmentScopeService;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.PageRequest;
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
    private final AuditLogRepository auditLogRepository;
    private final DepartmentScopeService departmentScopeService;

    public DashboardQueryService(EmployeeRepository employeeRepository,
                                 DepartmentRepository departmentRepository,
                                 PayrollPeriodRepository payrollPeriodRepository,
                                 LeaveRequestRepository leaveRequestRepository,
                                 AuditLogRepository auditLogRepository,
                                 DepartmentScopeService departmentScopeService) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
        this.payrollPeriodRepository = payrollPeriodRepository;
        this.leaveRequestRepository = leaveRequestRepository;
        this.auditLogRepository = auditLogRepository;
        this.departmentScopeService = departmentScopeService;
    }

    @Transactional(readOnly = true)
    public Summary summary() {
        String tenantId = TenantContext.get();
        List<UUID> scopedDepartmentIds = departmentScopeService.currentScopedDepartmentIds();
        boolean scoped = !scopedDepartmentIds.isEmpty();
        long employeeCount = scoped
            ? employeeRepository.countByTenantIdAndDepartment_IdIn(tenantId, scopedDepartmentIds)
            : employeeRepository.countByTenantId(tenantId);
        long activeEmployeeCount = scoped
            ? employeeRepository.countByTenantIdAndEmploymentStatusAndDepartment_IdIn(tenantId, EmploymentStatus.ACTIVE, scopedDepartmentIds)
            : employeeRepository.countByTenantIdAndEmploymentStatus(tenantId, EmploymentStatus.ACTIVE);
        long departmentCount = scoped ? scopedDepartmentIds.size() : departmentRepository.countByTenantId(tenantId);
        long openPeriodCount = payrollPeriodRepository.countByTenantIdAndStatus(tenantId, PayrollPeriodStatus.OPEN);
        long pendingLeaveCount = scoped
            ? leaveRequestRepository.countByTenantIdAndStatusAndEmployeeDepartmentIdIn(tenantId, LeaveStatus.PENDING, scopedDepartmentIds)
            : leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
        return new Summary(employeeCount, activeEmployeeCount, departmentCount, openPeriodCount, pendingLeaveCount);
    }

    @Transactional(readOnly = true)
    public List<DepartmentHeadcount> headcountByDepartment() {
        String tenantId = TenantContext.get();
        List<UUID> scopedDepartmentIds = departmentScopeService.currentScopedDepartmentIds();
        return departmentRepository.findAllByTenantId(tenantId).stream()
            .filter(dept -> scopedDepartmentIds.isEmpty() || scopedDepartmentIds.contains(dept.getId()))
            .map(dept -> {
                long count = employeeRepository.countByTenantIdAndDepartment_Id(tenantId, dept.getId());
                return new DepartmentHeadcount(dept.getId(), dept.getName(), count);
            })
            .sorted((left, right) -> Long.compare(right.count(), left.count()))
            .toList();
    }

    @Transactional(readOnly = true)
    public List<Activity> activities() {
        String tenantId = TenantContext.get();
        return auditLogRepository.findByTenantIdOrderByCreatedAtDesc(tenantId, PageRequest.of(0, 20)).stream()
            .map(log -> new Activity(log.getAction(), log.getDetails(), log.getCreatedAt()))
            .toList();
    }

    public record Summary(long totalEmployees, long activeEmployees, long departments,
                          long openPayrollPeriods, long pendingLeaves) {}

    public record DepartmentHeadcount(UUID departmentId, String departmentName, long count) {}

    public record Activity(String type, String message, Instant timestamp) {}

    @Transactional(readOnly = true)
    public List<DepartmentDistribution> departmentDistribution() {
        String tenantId = TenantContext.get();
        List<UUID> scopedDepartmentIds = departmentScopeService.currentScopedDepartmentIds();
        return departmentRepository.findAllByTenantId(tenantId).stream()
            .filter(d -> scopedDepartmentIds.isEmpty() || scopedDepartmentIds.contains(d.getId()))
            .map(d -> {
                long count = employeeRepository.countByTenantIdAndDepartment_Id(tenantId, d.getId());
                return new DepartmentDistribution(d.getName(), count);
            })
            .filter(d -> d.count() > 0)
            .sorted((left, right) -> Long.compare(right.count(), left.count()))
            .toList();
    }

    @Transactional(readOnly = true)
    public LeaveSummary leaveSummary() {
        String tenantId = TenantContext.get();
        long pending = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.PENDING);
        long approved = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.APPROVED);
        long rejected = leaveRequestRepository.countByTenantIdAndStatus(tenantId, LeaveStatus.REJECTED);
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
