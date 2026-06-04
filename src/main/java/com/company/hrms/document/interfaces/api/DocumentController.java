package com.company.hrms.document.interfaces.api;

import com.company.hrms.document.application.DocumentService;
import com.company.hrms.document.domain.Document;
import com.company.hrms.document.domain.DocumentCategory;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.domain.Pageable;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.time.Instant;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/documents")
public class DocumentController {
    private final DocumentService service;

    public DocumentController(DocumentService service) {
        this.service = service;
    }

    @PostMapping("/upload")
    @PreAuthorize("hasAuthority('document:create')")
    public DocumentResponse upload(@RequestParam UUID employeeId,
                                    @RequestParam String category,
                                    @RequestParam MultipartFile file) throws Exception {
        return toResponse(service.upload(employeeId, DocumentCategory.valueOf(category), file));
    }

    @GetMapping("/{id}/download")
    @PreAuthorize("hasAuthority('document:read')")
    public ResponseEntity<InputStreamResource> download(@PathVariable UUID id) throws IOException {
        Document doc = service.getById(id);
        java.nio.file.Path path = service.resolvePath(doc);
        InputStreamResource resource = new InputStreamResource(new FileInputStream(path.toFile()));
        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_OCTET_STREAM)
            .header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + doc.getOriginalName() + "\"")
            .body(resource);
    }

    @GetMapping
    @PreAuthorize("hasAuthority('document:read')")
    public PageResponse<DocumentResponse> list(@RequestParam(required = false) UUID employeeId,
                                                @RequestParam(required = false) String category,
                                                Pageable pageable) {
        return PageResponse.from(
            service.list(employeeId, category, pageable).map(DocumentController::toResponse));
    }

    @GetMapping("/mine")
    @PreAuthorize("hasAuthority('document:read')")
    public PageResponse<DocumentResponse> mine(@RequestHeader("X-Employee-Id") UUID employeeId,
                                                Pageable pageable) {
        return PageResponse.from(
            service.listMine(employeeId, pageable).map(DocumentController::toResponse));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('document:delete')")
    public void delete(@PathVariable UUID id) {
        service.delete(id);
    }

    private static DocumentResponse toResponse(Document d) {
        return new DocumentResponse(d.getId(), d.getEmployeeId(), d.getFileName(),
            d.getOriginalName(), d.getFileType(), d.getFileSize(),
            d.getCategory().name(), d.getUploadedAt());
    }

    public record DocumentResponse(UUID id, UUID employeeId, String fileName,
                                    String originalName, String fileType, Long fileSize,
                                    String category, Instant uploadedAt) {}
}
