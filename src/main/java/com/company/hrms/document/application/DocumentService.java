package com.company.hrms.document.application;

import com.company.hrms.document.domain.*;
import com.company.hrms.document.infrastructure.DocumentRepository;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.UUID;

@Service
public class DocumentService {
    private final DocumentRepository repository;
    private final Path basePath;

    public DocumentService(DocumentRepository repository,
                           @Value("${app.storage.base-path:./storage}") String basePath) {
        this.repository = repository;
        this.basePath = Path.of(basePath);
    }

    @Transactional
    public Document upload(UUID employeeId, DocumentCategory category, MultipartFile file) throws IOException {
        String tenantId = TenantContext.get();
        LocalDate now = LocalDate.now();
        String relativePath = String.format("tenants/%s/%d/%02d/%s-%s",
            tenantId, now.getYear(), now.getMonthValue(), UUID.randomUUID(), file.getOriginalFilename());
        Path target = basePath.resolve(relativePath);
        Files.createDirectories(target.getParent());
        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

        Document doc = new Document(UUID.randomUUID(), tenantId, employeeId,
            target.getFileName().toString(), file.getOriginalFilename(),
            file.getContentType(), file.getSize(), relativePath, category);
        return repository.save(doc);
    }

    @Transactional(readOnly = true)
    public Page<Document> list(UUID employeeId, String category, Pageable pageable) {
        String tenantId = TenantContext.get();
        if (employeeId != null && category != null)
            return repository.findByTenantIdAndEmployeeIdAndCategory(
                tenantId, employeeId, DocumentCategory.valueOf(category), pageable);
        if (employeeId != null)
            return repository.findByTenantIdAndEmployeeId(tenantId, employeeId, pageable);
        return repository.findByTenantId(tenantId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<Document> listMine(UUID employeeId, Pageable pageable) {
        return repository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId, pageable);
    }

    @Transactional(readOnly = true)
    public Document getById(UUID id) {
        return repository.findById(id)
            .orElseThrow(() -> new NotFoundException("DOCUMENT_NOT_FOUND"));
    }

    public Path resolvePath(Document doc) {
        return basePath.resolve(doc.getStoragePath());
    }

    @Transactional
    public void delete(UUID id) {
        Document doc = getById(id);
        try {
            Files.deleteIfExists(basePath.resolve(doc.getStoragePath()));
        } catch (IOException ignored) {
        }
        repository.delete(doc);
    }
}
