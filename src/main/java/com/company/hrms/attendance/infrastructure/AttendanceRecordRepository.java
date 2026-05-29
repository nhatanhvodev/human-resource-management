package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.AttendanceRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AttendanceRecordRepository extends JpaRepository<AttendanceRecord, UUID> {
}
