package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.LeaveBalance;
import com.company.hrms.attendance.domain.LeaveType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface LeaveBalanceRepository extends JpaRepository<LeaveBalance, UUID> {
    List<LeaveBalance> findByTenantIdAndEmployeeIdAndYear(String tenantId, UUID employeeId, int year);
    Optional<LeaveBalance> findByTenantIdAndEmployeeIdAndLeaveTypeAndYear(String tenantId, UUID employeeId, LeaveType leaveType, int year);
}
