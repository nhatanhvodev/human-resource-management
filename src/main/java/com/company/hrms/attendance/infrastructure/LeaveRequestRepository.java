package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.LeaveRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, UUID> {
}
