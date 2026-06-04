package com.company.hrms.document.infrastructure;

import com.company.hrms.document.domain.Document;
import com.company.hrms.document.domain.DocumentCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface DocumentRepository extends JpaRepository<Document, UUID> {
    Page<Document> findByTenantId(String tenantId, Pageable pageable);

    Page<Document> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId, Pageable pageable);

    Page<Document> findByTenantIdAndEmployeeIdAndCategory(String tenantId, UUID employeeId,
                                                           DocumentCategory category, Pageable pageable);
}
