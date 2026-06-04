package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.LeaveRequest;
import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.domain.LeaveType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, UUID> {
    long countByTenantIdAndStatus(String tenantId, LeaveStatus status);

    Optional<LeaveRequest> findByIdAndTenantId(UUID id, String tenantId);

    Page<LeaveRequest> findAllByTenantId(String tenantId, Pageable pageable);

    Page<LeaveRequest> findByTenantIdAndStatus(String tenantId, LeaveStatus status, Pageable pageable);

    long countByTenantIdAndEmployeeIdAndLeaveTypeAndStatus(String tenantId, UUID employeeId, LeaveType leaveType, LeaveStatus status);

    long countByTenantIdAndEmployeeIdAndLeaveTypeAndStatusAndFromDateBetween(String tenantId, UUID employeeId, LeaveType leaveType, LeaveStatus status, LocalDate start, LocalDate end);
}
