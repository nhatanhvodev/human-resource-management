package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.OvertimeRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface OvertimeRecordRepository extends JpaRepository<OvertimeRecord, UUID> {
    Page<OvertimeRecord> findByTenantId(String tenantId, Pageable pageable);
    List<OvertimeRecord> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId);
}
