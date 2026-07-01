package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.LeaveRequest;
import com.company.hrms.attendance.domain.LeaveStatus;
import com.company.hrms.attendance.domain.LeaveType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, UUID> {
    long countByTenantIdAndStatus(String tenantId, LeaveStatus status);

    @Query("""
        select count(l)
        from LeaveRequest l
        where l.tenantId = :tenantId
          and l.status = :status
          and l.employeeId in (
            select e.id
            from Employee e
            where e.tenantId = :tenantId
              and e.department.id in :departmentIds
          )
        """)
    long countByTenantIdAndStatusAndEmployeeDepartmentIdIn(@Param("tenantId") String tenantId,
                                                           @Param("status") LeaveStatus status,
                                                           @Param("departmentIds") Collection<UUID> departmentIds);

    Optional<LeaveRequest> findByIdAndTenantId(UUID id, String tenantId);

    Page<LeaveRequest> findAllByTenantId(String tenantId, Pageable pageable);

    Page<LeaveRequest> findByTenantIdAndStatus(String tenantId, LeaveStatus status, Pageable pageable);

    Page<LeaveRequest> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId, Pageable pageable);

    long countByTenantIdAndEmployeeIdAndLeaveTypeAndStatus(String tenantId, UUID employeeId, LeaveType leaveType, LeaveStatus status);

    long countByTenantIdAndEmployeeIdAndLeaveTypeAndStatusAndFromDateBetween(String tenantId, UUID employeeId, LeaveType leaveType, LeaveStatus status, LocalDate start, LocalDate end);
}
