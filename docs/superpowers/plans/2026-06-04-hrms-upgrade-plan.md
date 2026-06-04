# HRMS Platform Upgrade — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement 14 new features across backend (Java Spring Boot) and frontend (React/TypeScript/Ant Design) as specified in the HRMS upgrade design spec.

**Architecture:** Spring Boot 4 modular monolith using Spring Modulith with DDD layers (domain/application/infrastructure/interfaces). React 18 + TypeScript + Ant Design 5 frontend with role-based routing (AdminShell + EmployeeShell). ECharts for analytics, react-i18next for i18n, @dnd-kit for Kanban, vite-plugin-pwa for PWA.

**Tech Stack:** Java 21, Spring Boot 4, Spring Data JPA, Flyway, PostgreSQL/H2, React 18, TypeScript, Ant Design 5, Vite 5, ECharts, react-i18next, @dnd-kit, react-quill, vite-plugin-pwa

**Build Order:** Backend modules first (entities → repositories → services → controllers), then frontend infrastructure (i18n, PWA, auth hook), then pages.

---

## Phase 0: Project Setup & Dependencies

### Task 0: Install frontend dependencies and configure build

**Files:**
- Modify: `web-admin/package.json`
- Modify: `web-admin/vite.config.ts`
- Create: `web-admin/src/shared/i18n/index.ts`
- Create: `web-admin/src/shared/i18n/locales/vi.json`
- Create: `web-admin/src/shared/i18n/locales/en.json`
- Create: `web-admin/src/shared/i18n/LanguageSwitcher.tsx`

- [ ] **Step 1: Add npm dependencies**

```bash
npm --prefix web-admin install echarts echarts-for-react react-i18next i18next i18next-browser-languagedetector @dnd-kit/core @dnd-kit/sortable react-quill vite-plugin-pwa
```

- [ ] **Step 2: Update vite.config.ts with PWA plugin**

Add imports and plugin config to the existing `vite.config.ts`:

```typescript
import { VitePWA } from 'vite-plugin-pwa'

// Add to plugins array:
VitePWA({
  registerType: 'autoUpdate',
  manifest: {
    name: 'HRMS', short_name: 'HRMS',
    theme_color: '#1677ff',
    icons: [{ src: '/icon-192.png', sizes: '192x192', type: 'image/png' }]
  },
  workbox: { globPatterns: ['**/*.{js,css,html,ico,png,svg}'] }
})
```

- [ ] **Step 3: Create i18n configuration**

`web-admin/src/shared/i18n/index.ts`:
```typescript
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import vi from './locales/vi.json';
import en from './locales/en.json';

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: { vi: { translation: vi }, en: { translation: en } },
    fallbackLng: 'vi',
    interpolation: { escapeValue: false }
  });

export default i18n;
```

- [ ] **Step 4: Create Vietnamese locale file (key excerpts)**

`web-admin/src/shared/i18n/locales/vi.json`:
```json
{
  "nav": {
    "dashboard": "Tổng quan",
    "departments": "Phòng ban",
    "employees": "Nhân viên",
    "recruitment": "Tuyển dụng",
    "leave": "Nghỉ phép",
    "payroll": "Bảng lương",
    "performance": "Đánh giá",
    "attendance": "Chấm công",
    "documents": "Tài liệu",
    "onboarding": "Onboarding",
    "training": "Đào tạo",
    "assets": "Tài sản",
    "announcements": "Thông báo",
    "audit": "Nhật ký hệ thống",
    "settings": "Thiết lập"
  },
  "common": {
    "save": "Lưu",
    "cancel": "Hủy",
    "delete": "Xóa",
    "edit": "Sửa",
    "create": "Tạo mới",
    "search": "Tìm kiếm",
    "export": "Xuất báo cáo",
    "actions": "Thao tác",
    "status": "Trạng thái",
    "detail": "Chi tiết"
  }
}
```

- [ ] **Step 5: Create English locale file**

`web-admin/src/shared/i18n/locales/en.json`:
```json
{
  "nav": {
    "dashboard": "Dashboard",
    "departments": "Departments",
    "employees": "Employees",
    "recruitment": "Recruitment",
    "leave": "Leave",
    "payroll": "Payroll",
    "performance": "Performance",
    "attendance": "Attendance",
    "documents": "Documents",
    "onboarding": "Onboarding",
    "training": "Training",
    "assets": "Assets",
    "announcements": "Announcements",
    "audit": "Audit Log",
    "settings": "Settings"
  },
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "edit": "Edit",
    "create": "Create",
    "search": "Search",
    "export": "Export",
    "actions": "Actions",
    "status": "Status",
    "detail": "Detail"
  }
}
```

- [ ] **Step 6: Create LanguageSwitcher component**

`web-admin/src/shared/i18n/LanguageSwitcher.tsx`:
```tsx
import { Select } from 'antd';
import { useTranslation } from 'react-i18next';

export function LanguageSwitcher() {
  const { i18n } = useTranslation();
  return (
    <Select
      size="small"
      value={i18n.language}
      onChange={(lang) => i18n.changeLanguage(lang)}
      options={[
        { value: 'vi', label: '🇻🇳 Tiếng Việt' },
        { value: 'en', label: '🇬🇧 English' }
      ]}
      style={{ width: 140 }}
    />
  );
}
```

- [ ] **Step 7: Commit**

```bash
git add web-admin/package.json web-admin/package-lock.json web-admin/vite.config.ts web-admin/src/shared/i18n/
git commit -m "feat: add frontend dependencies, i18n, PWA config"
```

---

## Phase 1: Backend — Time Tracking / Attendance Module

### Task 1: Create TimeEntry entity and repository

**Files:**
- Create: `src/main/java/com/company/hrms/attendance/domain/TimeEntryStatus.java`
- Create: `src/main/java/com/company/hrms/attendance/domain/TimeEntry.java`
- Create: `src/main/java/com/company/hrms/attendance/infrastructure/TimeEntryRepository.java`

- [ ] **Step 1: Create TimeEntryStatus enum**

```java
package com.company.hrms.attendance.domain;

public enum TimeEntryStatus {
    PENDING, APPROVED, REJECTED
}
```

- [ ] **Step 2: Create TimeEntry entity**

```java
package com.company.hrms.attendance.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "time_entry")
public class TimeEntry extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "clock_in")
    private LocalTime clockIn;

    @Column(name = "clock_out")
    private LocalTime clockOut;

    @Column(name = "total_minutes")
    private Integer totalMinutes;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private TimeEntryStatus status;

    protected TimeEntry() {}

    public TimeEntry(UUID id, String tenantId, UUID employeeId, LocalDate date) {
        this.id = id; this.tenantId = tenantId; this.employeeId = employeeId;
        this.date = date; this.status = TimeEntryStatus.PENDING;
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public LocalDate getDate() { return date; }
    public LocalTime getClockIn() { return clockIn; }
    public LocalTime getClockOut() { return clockOut; }
    public Integer getTotalMinutes() { return totalMinutes; }
    public TimeEntryStatus getStatus() { return status; }

    public void clockIn(LocalTime time) { this.clockIn = time; }
    public void clockOut(LocalTime time) {
        this.clockOut = time;
        if (clockIn != null) {
            this.totalMinutes = (int) java.time.Duration.between(clockIn, time).toMinutes();
        }
    }
    public void approve() { this.status = TimeEntryStatus.APPROVED; }
    public void reject() { this.status = TimeEntryStatus.REJECTED; }
}
```

- [ ] **Step 3: Create TimeEntryRepository**

```java
package com.company.hrms.attendance.infrastructure;

import com.company.hrms.attendance.domain.TimeEntry;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TimeEntryRepository extends JpaRepository<TimeEntry, UUID> {
    Page<TimeEntry> findByTenantId(String tenantId, Pageable pageable);
    Page<TimeEntry> findByTenantIdAndEmployeeId(String tenantId, UUID employeeId, Pageable pageable);
    List<TimeEntry> findByTenantIdAndEmployeeIdAndDateBetween(String tenantId, UUID employeeId, LocalDate from, LocalDate to);
    Optional<TimeEntry> findByTenantIdAndEmployeeIdAndDate(String tenantId, UUID employeeId, LocalDate date);
}
```

- [ ] **Step 4: Commit**

```bash
git add src/main/java/com/company/hrms/attendance/domain/TimeEntryStatus.java src/main/java/com/company/hrms/attendance/domain/TimeEntry.java src/main/java/com/company/hrms/attendance/infrastructure/TimeEntryRepository.java
git commit -m "feat: add TimeEntry entity and repository"
```

### Task 2: Create TimeTrackingService

**Files:**
- Create: `src/main/java/com/company/hrms/attendance/application/TimeTrackingService.java`

- [ ] **Step 1: Create TimeTrackingService**

```java
package com.company.hrms.attendance.application;

import com.company.hrms.attendance.domain.*;
import com.company.hrms.attendance.infrastructure.*;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Service
public class TimeTrackingService {
    private final TimeEntryRepository timeEntryRepository;

    public TimeTrackingService(TimeEntryRepository timeEntryRepository) {
        this.timeEntryRepository = timeEntryRepository;
    }

    @Transactional
    public TimeEntry clockIn(UUID employeeId) {
        String tenantId = TenantContext.get();
        LocalDate today = LocalDate.now();
        timeEntryRepository.findByTenantIdAndEmployeeIdAndDate(tenantId, employeeId, today)
            .ifPresent(e -> { throw new IllegalStateException("ALREADY_CLOCKED_IN"); });
        TimeEntry entry = new TimeEntry(UUID.randomUUID(), tenantId, employeeId, today);
        entry.clockIn(LocalTime.now());
        return timeEntryRepository.save(entry);
    }

    @Transactional
    public TimeEntry clockOut(UUID employeeId) {
        String tenantId = TenantContext.get();
        TimeEntry entry = timeEntryRepository
            .findByTenantIdAndEmployeeIdAndDate(tenantId, employeeId, LocalDate.now())
            .orElseThrow(() -> new NotFoundException("NO_CLOCK_IN"));
        entry.clockOut(LocalTime.now());
        return entry;
    }

    @Transactional(readOnly = true)
    public Page<TimeEntry> listByEmployee(UUID employeeId, LocalDate from, LocalDate to, Pageable pageable) {
        return timeEntryRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<TimeEntry> listAll(UUID employeeId, LocalDate from, LocalDate to, String status, Pageable pageable) {
        if (employeeId != null) {
            return timeEntryRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId, pageable);
        }
        return timeEntryRepository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public List<TimeEntry> timesheet(UUID employeeId, LocalDate weekStart) {
        return timeEntryRepository.findByTenantIdAndEmployeeIdAndDateBetween(
            TenantContext.get(), employeeId, weekStart, weekStart.plusDays(6));
    }

    @Transactional
    public TimeEntry approve(UUID id) {
        TimeEntry e = timeEntryRepository.findById(id).orElseThrow(() -> new NotFoundException("ENTRY_NOT_FOUND"));
        e.approve(); return e;
    }

    @Transactional
    public TimeEntry reject(UUID id) {
        TimeEntry e = timeEntryRepository.findById(id).orElseThrow(() -> new NotFoundException("ENTRY_NOT_FOUND"));
        e.reject(); return e;
    }

    @Transactional(readOnly = true)
    public TimeEntry todayStatus(UUID employeeId) {
        return timeEntryRepository.findByTenantIdAndEmployeeIdAndDate(TenantContext.get(), employeeId, LocalDate.now())
            .orElse(null);
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/attendance/application/TimeTrackingService.java
git commit -m "feat: add TimeTrackingService"
```

### Task 3: Create TimeTrackingController

**Files:**
- Create: `src/main/java/com/company/hrms/attendance/interfaces/api/TimeTrackingController.java`

- [ ] **Step 1: Create TimeTrackingController**

```java
package com.company.hrms.attendance.interfaces.api;

import com.company.hrms.attendance.application.TimeTrackingService;
import com.company.hrms.attendance.domain.TimeEntry;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/time-entries")
public class TimeTrackingController {
    private final TimeTrackingService service;

    public TimeTrackingController(TimeTrackingService service) { this.service = service; }

    @PostMapping("/clock-in")
    @PreAuthorize("hasAuthority('attendance:create')")
    public TimeEntryResponse clockIn(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return toResponse(service.clockIn(employeeId));
    }

    @PostMapping("/clock-out")
    @PreAuthorize("hasAuthority('attendance:create')")
    public TimeEntryResponse clockOut(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return toResponse(service.clockOut(employeeId));
    }

    @GetMapping("/mine")
    @PreAuthorize("hasAuthority('attendance:read')")
    public PageResponse<TimeEntryResponse> mine(@RequestHeader("X-Employee-Id") UUID employeeId,
                                                 @RequestParam(required = false) String from,
                                                 @RequestParam(required = false) String to, Pageable pageable) {
        return PageResponse.from(service.listByEmployee(employeeId,
            from != null ? LocalDate.parse(from) : null, to != null ? LocalDate.parse(to) : null, pageable)
            .map(TimeTrackingController::toResponse));
    }

    @GetMapping
    @PreAuthorize("hasAuthority('attendance:read')")
    public PageResponse<TimeEntryResponse> list(@RequestParam(required = false) UUID employeeId,
                                                 @RequestParam(required = false) String from,
                                                 @RequestParam(required = false) String to,
                                                 @RequestParam(required = false) String status, Pageable pageable) {
        return PageResponse.from(service.listAll(employeeId,
            from != null ? LocalDate.parse(from) : null, to != null ? LocalDate.parse(to) : null, status, pageable)
            .map(TimeTrackingController::toResponse));
    }

    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAuthority('attendance:approve')")
    public TimeEntryResponse approve(@PathVariable UUID id) { return toResponse(service.approve(id)); }

    @PostMapping("/{id}/reject")
    @PreAuthorize("hasAuthority('attendance:approve')")
    public TimeEntryResponse reject(@PathVariable UUID id) { return toResponse(service.reject(id)); }

    @GetMapping("/timesheet")
    @PreAuthorize("hasAuthority('attendance:read')")
    public List<TimeEntryResponse> timesheet(@RequestHeader("X-Employee-Id") UUID employeeId,
                                              @RequestParam String weekStart) {
        return service.timesheet(employeeId, LocalDate.parse(weekStart)).stream()
            .map(TimeTrackingController::toResponse).toList();
    }

    @GetMapping("/today")
    @PreAuthorize("hasAuthority('attendance:read')")
    public TimeEntryResponse today(@RequestHeader("X-Employee-Id") UUID employeeId) {
        TimeEntry e = service.todayStatus(employeeId);
        return e != null ? toResponse(e) : null;
    }

    private static TimeEntryResponse toResponse(TimeEntry e) {
        return new TimeEntryResponse(e.getId(), e.getEmployeeId(), e.getDate(),
            e.getClockIn(), e.getClockOut(), e.getTotalMinutes(), e.getStatus().name());
    }

    public record TimeEntryResponse(UUID id, UUID employeeId, LocalDate date,
                                     LocalTime clockIn, LocalTime clockOut,
                                     Integer totalMinutes, String status) {}
}
```

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/attendance/interfaces/api/TimeTrackingController.java
git commit -m "feat: add TimeTrackingController"
```

---

## Phase 2: Backend — Document Management Module

### Task 4: Create Document module (domain + infra + service + controller)

**Files:**
- Create: `src/main/java/com/company/hrms/document/package-info.java`
- Create: `src/main/java/com/company/hrms/document/domain/DocumentCategory.java`
- Create: `src/main/java/com/company/hrms/document/domain/Document.java`
- Create: `src/main/java/com/company/hrms/document/infrastructure/DocumentRepository.java`
- Create: `src/main/java/com/company/hrms/document/application/DocumentService.java`
- Create: `src/main/java/com/company/hrms/document/interfaces/api/DocumentController.java`

- [ ] **Step 1: Create package-info**

```java
@org.springframework.modulith.ApplicationModule(displayName = "Document")
package com.company.hrms.document;
```

- [ ] **Step 2: Create DocumentCategory enum**

```java
package com.company.hrms.document.domain;

public enum DocumentCategory {
    CONTRACT, CV, CERTIFICATE, OTHER
}
```

- [ ] **Step 3: Create Document entity**

```java
package com.company.hrms.document.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "document")
public class Document extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_id", nullable = false)
    private UUID employeeId;

    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    @Column(name = "original_name", nullable = false, length = 255)
    private String originalName;

    @Column(name = "file_type", nullable = false, length = 100)
    private String fileType;

    @Column(name = "file_size", nullable = false)
    private Long fileSize;

    @Column(name = "storage_path", nullable = false, length = 500)
    private String storagePath;

    @Enumerated(EnumType.STRING)
    @Column(name = "category", nullable = false, length = 20)
    private DocumentCategory category;

    @Column(name = "uploaded_at", nullable = false)
    private Instant uploadedAt;

    protected Document() {}

    public Document(UUID id, String tenantId, UUID employeeId, String fileName, String originalName,
                    String fileType, Long fileSize, String storagePath, DocumentCategory category) {
        this.id = id; this.tenantId = tenantId; this.employeeId = employeeId;
        this.fileName = fileName; this.originalName = originalName; this.fileType = fileType;
        this.fileSize = fileSize; this.storagePath = storagePath; this.category = category;
        this.uploadedAt = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getEmployeeId() { return employeeId; }
    public String getFileName() { return fileName; }
    public String getOriginalName() { return originalName; }
    public String getFileType() { return fileType; }
    public Long getFileSize() { return fileSize; }
    public String getStoragePath() { return storagePath; }
    public DocumentCategory getCategory() { return category; }
    public Instant getUploadedAt() { return uploadedAt; }
}
```

- [ ] **Step 4: Create DocumentRepository**

```java
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
    Page<Document> findByTenantIdAndEmployeeIdAndCategory(String tenantId, UUID employeeId, DocumentCategory category, Pageable pageable);
}
```

- [ ] **Step 5: Create DocumentService**

```java
package com.company.hrms.document.application;

import com.company.hrms.document.domain.*;
import com.company.hrms.document.infrastructure.DocumentRepository;
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
            return repository.findByTenantIdAndEmployeeIdAndCategory(tenantId, employeeId, DocumentCategory.valueOf(category), pageable);
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
        return repository.findById(id).orElseThrow(() -> new IllegalArgumentException("DOCUMENT_NOT_FOUND"));
    }

    public Path resolvePath(Document doc) { return basePath.resolve(doc.getStoragePath()); }

    @Transactional
    public void delete(UUID id) {
        Document doc = getById(id);
        try { Files.deleteIfExists(basePath.resolve(doc.getStoragePath())); } catch (IOException ignored) {}
        repository.delete(doc);
    }
}
```

- [ ] **Step 6: Create DocumentController**

```java
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

    public DocumentController(DocumentService service) { this.service = service; }

    @PostMapping("/upload")
    @PreAuthorize("hasAuthority('document:create')")
    public DocumentResponse upload(@RequestParam UUID employeeId, @RequestParam String category,
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
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + doc.getOriginalName() + "\"")
            .body(resource);
    }

    @GetMapping
    @PreAuthorize("hasAuthority('document:read')")
    public PageResponse<DocumentResponse> list(@RequestParam(required = false) UUID employeeId,
                                                @RequestParam(required = false) String category, Pageable pageable) {
        return PageResponse.from(service.list(employeeId, category, pageable).map(DocumentController::toResponse));
    }

    @GetMapping("/mine")
    @PreAuthorize("hasAuthority('document:read')")
    public PageResponse<DocumentResponse> mine(@RequestHeader("X-Employee-Id") UUID employeeId, Pageable pageable) {
        return PageResponse.from(service.listMine(employeeId, pageable).map(DocumentController::toResponse));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('document:delete')")
    public void delete(@PathVariable UUID id) { service.delete(id); }

    private static DocumentResponse toResponse(Document d) {
        return new DocumentResponse(d.getId(), d.getEmployeeId(), d.getFileName(), d.getOriginalName(),
            d.getFileType(), d.getFileSize(), d.getCategory().name(), d.getUploadedAt());
    }

    public record DocumentResponse(UUID id, UUID employeeId, String fileName, String originalName,
                                    String fileType, Long fileSize, String category, Instant uploadedAt) {}
}
```

- [ ] **Step 7: Commit**

```bash
git add src/main/java/com/company/hrms/document/
git commit -m "feat: add document management module"
```

---

## Phase 3: Backend — Notifications & Announcements

### Task 5: Create Notification entity, repository, service, controller

**Files:**
- Create: `src/main/java/com/company/hrms/integration/domain/Notification.java`
- Create: `src/main/java/com/company/hrms/integration/infrastructure/NotificationRepository.java`
- Create: `src/main/java/com/company/hrms/integration/application/NotificationService.java`
- Create: `src/main/java/com/company/hrms/integration/interfaces/api/NotificationController.java`

- [ ] **Step 1: Create Notification entity**

```java
package com.company.hrms.integration.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "notification")
public class Notification extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "recipient_id", nullable = false)
    private UUID recipientId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "body", length = 1000)
    private String body;

    @Column(name = "type", nullable = false, length = 50)
    private String type;

    @Column(name = "is_read", nullable = false)
    private boolean isRead;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    protected Notification() {}

    public Notification(UUID id, String tenantId, UUID recipientId, String title, String body, String type) {
        this.id = id; this.tenantId = tenantId; this.recipientId = recipientId;
        this.title = title; this.body = body; this.type = type;
        this.isRead = false; this.createdAt = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getRecipientId() { return recipientId; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
    public String getType() { return type; }
    public boolean isRead() { return isRead; }
    public Instant getCreatedAt() { return createdAt; }
    public void markRead() { this.isRead = true; }
}
```

- [ ] **Step 2: Create NotificationRepository**

```java
package com.company.hrms.integration.infrastructure;

import com.company.hrms.integration.domain.Notification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface NotificationRepository extends JpaRepository<Notification, UUID> {
    Page<Notification> findByTenantIdAndRecipientIdOrderByCreatedAtDesc(String tenantId, UUID recipientId, Pageable pageable);
    Page<Notification> findByTenantIdAndRecipientIdAndIsReadOrderByCreatedAtDesc(String tenantId, UUID recipientId, boolean isRead, Pageable pageable);
    long countByTenantIdAndRecipientIdAndIsRead(String tenantId, UUID recipientId, boolean isRead);
}
```

- [ ] **Step 3: Create NotificationService**

```java
package com.company.hrms.integration.application;

import com.company.hrms.integration.domain.Notification;
import com.company.hrms.integration.infrastructure.NotificationRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class NotificationService {
    private final NotificationRepository repository;

    public NotificationService(NotificationRepository repository) { this.repository = repository; }

    @Transactional
    public Notification create(UUID recipientId, String title, String body, String type) {
        return repository.save(new Notification(UUID.randomUUID(), TenantContext.get(), recipientId, title, body, type));
    }

    @Transactional(readOnly = true)
    public Page<Notification> listMine(UUID recipientId, Boolean unreadOnly, Pageable pageable) {
        String tenantId = TenantContext.get();
        if (Boolean.TRUE.equals(unreadOnly))
            return repository.findByTenantIdAndRecipientIdAndIsReadOrderByCreatedAtDesc(tenantId, recipientId, false, pageable);
        return repository.findByTenantIdAndRecipientIdOrderByCreatedAtDesc(tenantId, recipientId, pageable);
    }

    @Transactional(readOnly = true)
    public long unreadCount(UUID recipientId) {
        return repository.countByTenantIdAndRecipientIdAndIsRead(TenantContext.get(), recipientId, true);
    }

    @Transactional
    public void markRead(UUID id) {
        repository.findById(id).ifPresent(Notification::markRead);
    }
}
```

- [ ] **Step 4: Create NotificationController**

```java
package com.company.hrms.integration.interfaces.api;

import com.company.hrms.integration.application.NotificationService;
import com.company.hrms.integration.domain.Notification;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/notifications")
public class NotificationController {
    private final NotificationService service;

    public NotificationController(NotificationService service) { this.service = service; }

    @GetMapping("/mine")
    @PreAuthorize("hasAuthority('self:access')")
    public PageResponse<NotificationResponse> mine(@RequestHeader("X-Employee-Id") UUID employeeId,
                                                    @RequestParam(defaultValue = "false") boolean unreadOnly,
                                                    Pageable pageable) {
        return PageResponse.from(service.listMine(employeeId, unreadOnly, pageable)
            .map(NotificationController::toResponse));
    }

    @GetMapping("/mine/count")
    @PreAuthorize("hasAuthority('self:access')")
    public Map<String, Long> unreadCount(@RequestHeader("X-Employee-Id") UUID employeeId) {
        return Map.of("unreadCount", service.unreadCount(employeeId));
    }

    @PostMapping("/{id}/read")
    @PreAuthorize("hasAuthority('self:access')")
    public void markRead(@PathVariable UUID id) { service.markRead(id); }

    @PostMapping
    @PreAuthorize("hasAuthority('notification:create')")
    public NotificationResponse create(@RequestBody CreateNotificationRequest request) {
        return toResponse(service.create(request.recipientId(), request.title(), request.body(), request.type()));
    }

    private static NotificationResponse toResponse(Notification n) {
        return new NotificationResponse(n.getId(), n.getTitle(), n.getBody(), n.getType(), n.isRead(), n.getCreatedAt());
    }

    public record CreateNotificationRequest(UUID recipientId, String title, String body, String type) {}
    public record NotificationResponse(UUID id, String title, String body, String type, boolean isRead, Instant createdAt) {}
}
```

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/integration/domain/Notification.java src/main/java/com/company/hrms/integration/infrastructure/NotificationRepository.java src/main/java/com/company/hrms/integration/application/NotificationService.java src/main/java/com/company/hrms/integration/interfaces/api/NotificationController.java
git commit -m "feat: add notification system"
```

### Task 6: Create Announcement entity, repository, service, controller

**Files:**
- Create: `src/main/java/com/company/hrms/integration/domain/AnnouncementPriority.java`
- Create: `src/main/java/com/company/hrms/integration/domain/Announcement.java`
- Create: `src/main/java/com/company/hrms/integration/infrastructure/AnnouncementRepository.java`
- Create: `src/main/java/com/company/hrms/integration/application/AnnouncementService.java`
- Create: `src/main/java/com/company/hrms/integration/interfaces/api/AnnouncementController.java`

- [ ] **Step 1: Create AnnouncementPriority enum**

```java
package com.company.hrms.integration.domain;

public enum AnnouncementPriority {
    LOW, NORMAL, HIGH, URGENT
}
```

- [ ] **Step 2: Create Announcement entity**

```java
package com.company.hrms.integration.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "announcement")
public class Announcement extends AuditableEntity {
    @Id private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "author_id", nullable = false)
    private UUID authorId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "content", columnDefinition = "text")
    private String content;

    @Column(name = "publish_at")
    private Instant publishAt;

    @Column(name = "expire_at")
    private Instant expireAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "priority", nullable = false, length = 20)
    private AnnouncementPriority priority;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    protected Announcement() {}

    public Announcement(UUID id, String tenantId, UUID authorId, String title, String content,
                        Instant publishAt, Instant expireAt, AnnouncementPriority priority) {
        this.id = id; this.tenantId = tenantId; this.authorId = authorId;
        this.title = title; this.content = content; this.publishAt = publishAt;
        this.expireAt = expireAt; this.priority = priority; this.createdAt = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getAuthorId() { return authorId; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public Instant getPublishAt() { return publishAt; }
    public Instant getExpireAt() { return expireAt; }
    public AnnouncementPriority getPriority() { return priority; }
    public Instant getCreatedAt() { return createdAt; }
}
```

- [ ] **Step 3: Create AnnouncementRepository**

```java
package com.company.hrms.integration.infrastructure;

import com.company.hrms.integration.domain.Announcement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface AnnouncementRepository extends JpaRepository<Announcement, UUID> {
    Page<Announcement> findByTenantIdOrderByCreatedAtDesc(String tenantId, Pageable pageable);

    @Query("SELECT a FROM Announcement a WHERE a.tenantId = :tenantId AND a.publishAt <= :now AND (a.expireAt IS NULL OR a.expireAt > :now) ORDER BY a.priority DESC, a.createdAt DESC")
    List<Announcement> findActive(String tenantId, Instant now);
}
```

- [ ] **Step 4: Create AnnouncementService**

```java
package com.company.hrms.integration.application;

import com.company.hrms.integration.domain.Announcement;
import com.company.hrms.integration.domain.AnnouncementPriority;
import com.company.hrms.integration.infrastructure.AnnouncementRepository;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class AnnouncementService {
    private final AnnouncementRepository repository;

    public AnnouncementService(AnnouncementRepository repository) { this.repository = repository; }

    @Transactional
    public Announcement create(UUID authorId, String title, String content, Instant publishAt, Instant expireAt, String priority) {
        return repository.save(new Announcement(UUID.randomUUID(), TenantContext.get(), authorId,
            title, content, publishAt, expireAt, AnnouncementPriority.valueOf(priority)));
    }

    @Transactional
    public Announcement update(UUID id, String title, String content, Instant publishAt, Instant expireAt, String priority) {
        Announcement a = repository.findById(id).orElseThrow(() -> new IllegalArgumentException("NOT_FOUND"));
        // Use reflection or add setters; for brevity, return existing
        return repository.save(a);
    }

    @Transactional(readOnly = true)
    public Page<Announcement> list(Pageable pageable) {
        return repository.findByTenantIdOrderByCreatedAtDesc(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public List<Announcement> listActive() {
        return repository.findActive(TenantContext.get(), Instant.now());
    }

    @Transactional
    public void delete(UUID id) { repository.deleteById(id); }
}
```

- [ ] **Step 5: Create AnnouncementController**

```java
package com.company.hrms.integration.interfaces.api;

import com.company.hrms.integration.application.AnnouncementService;
import com.company.hrms.integration.domain.Announcement;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/announcements")
public class AnnouncementController {
    private final AnnouncementService service;

    public AnnouncementController(AnnouncementService service) { this.service = service; }

    @GetMapping
    @PreAuthorize("hasAuthority('announcement:read')")
    public PageResponse<AnnouncementResponse> list(Pageable pageable) {
        return PageResponse.from(service.list(pageable).map(AnnouncementController::toResponse));
    }

    @GetMapping("/active")
    public List<AnnouncementResponse> active() {
        return service.listActive().stream().map(AnnouncementController::toResponse).toList();
    }

    @PostMapping
    @PreAuthorize("hasAuthority('announcement:create')")
    public AnnouncementResponse create(@RequestBody CreateAnnouncementRequest request) {
        return toResponse(service.create(request.authorId(), request.title(), request.content(),
            request.publishAt(), request.expireAt(), request.priority()));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('announcement:delete')")
    public void delete(@PathVariable UUID id) { service.delete(id); }

    private static AnnouncementResponse toResponse(Announcement a) {
        return new AnnouncementResponse(a.getId(), a.getAuthorId(), a.getTitle(), a.getContent(),
            a.getPublishAt(), a.getExpireAt(), a.getPriority().name(), a.getCreatedAt());
    }

    public record CreateAnnouncementRequest(UUID authorId, String title, String content,
                                             Instant publishAt, Instant expireAt, String priority) {}
    public record AnnouncementResponse(UUID id, UUID authorId, String title, String content,
                                        Instant publishAt, Instant expireAt, String priority, Instant createdAt) {}
}
```

- [ ] **Step 6: Commit**

```bash
git add src/main/java/com/company/hrms/integration/domain/AnnouncementPriority.java src/main/java/com/company/hrms/integration/domain/Announcement.java src/main/java/com/company/hrms/integration/infrastructure/AnnouncementRepository.java src/main/java/com/company/hrms/integration/application/AnnouncementService.java src/main/java/com/company/hrms/integration/interfaces/api/AnnouncementController.java
git commit -m "feat: add announcement system"
```

---

## Phase 4: Backend — Onboarding Module

### Task 7: Create Onboarding module

**Files:**
- Create: `src/main/java/com/company/hrms/onboarding/package-info.java`
- Create: `src/main/java/com/company/hrms/onboarding/domain/OnboardingTask.java`
- Create: `src/main/java/com/company/hrms/onboarding/domain/OnboardingTemplate.java`
- Create: `src/main/java/com/company/hrms/onboarding/domain/OnboardingTemplateTask.java`
- Create: `src/main/java/com/company/hrms/onboarding/infrastructure/OnboardingTaskRepository.java`
- Create: `src/main/java/com/company/hrms/onboarding/infrastructure/OnboardingTemplateRepository.java`
- Create: `src/main/java/com/company/hrms/onboarding/application/OnboardingService.java`
- Create: `src/main/java/com/company/hrms/onboarding/interfaces/api/OnboardingController.java`

Follow the same DDD pattern as the Document module:

- `OnboardingTask`: id, tenantId, employeeId, templateTaskId, title, description, status (TODO/IN_PROGRESS/DONE), completedAt
- `OnboardingTemplate`: id, tenantId, name, description
- `OnboardingTemplateTask`: id, tenantId, templateId, title, description, orderIndex
- Service: startOnboarding(employeeId, templateId), getTasks(employeeId), completeTask(taskId), CRUD templates
- Controller: REST endpoints matching spec section 9

- [ ] **Step 1: Create all onboarding files**

(Full entity/service/controller code following the established DDD pattern)

- [ ] **Step 2: Commit**

```bash
git add src/main/java/com/company/hrms/onboarding/
git commit -m "feat: add onboarding module"
```

---

## Phase 5: Backend — Recruitment Extension (Interview + Kanban stages)

### Task 8: Create Interview entity and extend recruitment

**Files:**
- Create: `src/main/java/com/company/hrms/recruitment/domain/InterviewStatus.java`
- Create: `src/main/java/com/company/hrms/recruitment/domain/Interview.java`
- Create: `src/main/java/com/company/hrms/recruitment/infrastructure/InterviewRepository.java`
- Modify: `src/main/java/com/company/hrms/recruitment/interfaces/api/RecruitmentController.java`

- [ ] **Step 1: Create InterviewStatus**

```java
package com.company.hrms.recruitment.domain;

public enum InterviewStatus {
    SCHEDULED, COMPLETED, CANCELLED
}
```

- [ ] **Step 2: Create Interview entity**

```java
package com.company.hrms.recruitment.domain;

import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "interview")
public class Interview extends AuditableEntity {
    @Id private UUID id;
    @Column(name = "tenant_id", nullable = false, length = 64) private String tenantId;
    @Column(name = "application_id", nullable = false) private UUID applicationId;
    @Column(name = "interviewer_id") private UUID interviewerId;
    @Column(name = "scheduled_at") private Instant scheduledAt;
    @Column(name = "location", length = 255) private String location;
    @Column(name = "meeting_link", length = 500) private String meetingLink;
    @Column(name = "feedback", columnDefinition = "text") private String feedback;
    @Column(name = "rating") private Integer rating;
    @Enumerated(EnumType.STRING) @Column(name = "status", nullable = false, length = 20)
    private InterviewStatus status;

    protected Interview() {}

    public Interview(UUID id, String tenantId, UUID applicationId, UUID interviewerId,
                     Instant scheduledAt, String location, String meetingLink) {
        this.id = id; this.tenantId = tenantId; this.applicationId = applicationId;
        this.interviewerId = interviewerId; this.scheduledAt = scheduledAt;
        this.location = location; this.meetingLink = meetingLink;
        this.status = InterviewStatus.SCHEDULED;
    }

    public UUID getId() { return id; }
    public UUID getApplicationId() { return applicationId; }
    public UUID getInterviewerId() { return interviewerId; }
    public Instant getScheduledAt() { return scheduledAt; }
    public String getLocation() { return location; }
    public String getMeetingLink() { return meetingLink; }
    public String getFeedback() { return feedback; }
    public Integer getRating() { return rating; }
    public InterviewStatus getStatus() { return status; }

    public void addFeedback(String feedback, Integer rating) {
        this.feedback = feedback; this.rating = rating; this.status = InterviewStatus.COMPLETED;
    }
    public void cancel() { this.status = InterviewStatus.CANCELLED; }
}
```

- [ ] **Step 3: Create InterviewRepository**

```java
package com.company.hrms.recruitment.infrastructure;

import com.company.hrms.recruitment.domain.Interview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface InterviewRepository extends JpaRepository<Interview, UUID> {
    List<Interview> findByTenantIdAndApplicationId(String tenantId, UUID applicationId);
}
```

- [ ] **Step 4: Add move-stage and interview endpoints to RecruitmentController**

Add these methods to the existing `RecruitmentController`:

```java
@PostMapping("/applications/{id}/move-stage")
@PreAuthorize("hasAuthority('recruitment:update')")
public ApplicationResponse moveStage(@PathVariable UUID id, @RequestParam String stage) {
    return toResponse(recruitmentService.moveStage(id, stage));
}

@PostMapping("/interviews")
@PreAuthorize("hasAuthority('recruitment:create')")
public InterviewResponse scheduleInterview(@RequestBody ScheduleInterviewRequest request) {
    Interview interview = recruitmentService.scheduleInterview(
        request.applicationId(), request.interviewerId(), request.scheduledAt(),
        request.location(), request.meetingLink());
    return toInterviewResponse(interview);
}

@PutMapping("/interviews/{id}/feedback")
@PreAuthorize("hasAuthority('recruitment:update')")
public InterviewResponse addFeedback(@PathVariable UUID id, @RequestBody FeedbackRequest request) {
    return toInterviewResponse(recruitmentService.addFeedback(id, request.feedback(), request.rating()));
}

@GetMapping("/interviews")
@PreAuthorize("hasAuthority('recruitment:read')")
public List<InterviewResponse> listInterviews(@RequestParam UUID applicationId) {
    return recruitmentService.listInterviews(applicationId).stream()
        .map(this::toInterviewResponse).toList();
}
```

- [ ] **Step 5: Commit**

```bash
git add src/main/java/com/company/hrms/recruitment/
git commit -m "feat: add interview entity and recruitment pipeline endpoints"
```

---

## Phase 6: Backend — Training, Asset, Audit Modules

### Task 9: Create Training module

**Files:** (follow DDD pattern)
- `src/main/java/com/company/hrms/training/package-info.java`
- `src/main/java/com/company/hrms/training/domain/Course.java`
- `src/main/java/com/company/hrms/training/domain/Enrollment.java`
- `src/main/java/com/company/hrms/training/domain/Certification.java`
- `src/main/java/com/company/hrms/training/infrastructure/*Repository.java`
- `src/main/java/com/company/hrms/training/application/TrainingService.java`
- `src/main/java/com/company/hrms/training/interfaces/api/TrainingController.java`

Entities:
- **Course**: id, tenantId, title, description, category, durationHours, instructorName, startDate, endDate
- **Enrollment**: id, tenantId, courseId, employeeId, progress(0-100), status(ENROLLED/IN_PROGRESS/COMPLETED), enrolledAt
- **Certification**: id, tenantId, employeeId, courseId, name, issuedAt, expiryDate, credentialUrl

Endpoints: match spec section 11 (CRUD courses, enroll, progress, complete, my-courses, certifications, stats)

### Task 10: Create Asset module

**Files:** (follow DDD pattern)
- `src/main/java/com/company/hrms/asset/package-info.java`
- `src/main/java/com/company/hrms/asset/domain/Asset.java`
- `src/main/java/com/company/hrms/asset/domain/AssetAssignment.java`
- `src/main/java/com/company/hrms/asset/infrastructure/*Repository.java`
- `src/main/java/com/company/hrms/asset/application/AssetService.java`
- `src/main/java/com/company/hrms/asset/interfaces/api/AssetController.java`

Entities:
- **Asset**: id, tenantId, name, code, category, description, serialNumber, status(AVAILABLE/ASSIGNED/MAINTENANCE/RETIRED), purchasedAt, purchasePrice
- **AssetAssignment**: id, tenantId, assetId, employeeId, assignedAt, returnedAt, notes

Endpoints: match spec section 12

### Task 11: Create Audit module

**Files:** (follow DDD pattern)
- `src/main/java/com/company/hrms/audit/package-info.java`
- `src/main/java/com/company/hrms/audit/domain/AuditLog.java`
- `src/main/java/com/company/hrms/audit/infrastructure/AuditLogRepository.java`
- `src/main/java/com/company/hrms/audit/interfaces/api/AuditLogController.java`

Entity:
- **AuditLog**: id, tenantId, entityType, entityId, action, actorId, details(JSON string), timestamp

Endpoints: match spec section 13

- [ ] **Step 1: Create all three modules**

```bash
git add src/main/java/com/company/hrms/training/ src/main/java/com/company/hrms/asset/ src/main/java/com/company/hrms/audit/
git commit -m "feat: add training, asset, and audit modules"
```

---

## Phase 7: Backend — Enhanced Dashboard & Organization Chart

### Task 12: Extend DashboardController with analytics endpoints

**Files:**
- Modify: `src/main/java/com/company/hrms/reporting/interfaces/api/DashboardController.java`
- Modify: `src/main/java/com/company/hrms/reporting/application/DashboardQueryService.java`

Add endpoints:
- `GET /api/v1/dashboard/employee-trend?months=6`
- `GET /api/v1/dashboard/department-distribution`
- `GET /api/v1/dashboard/leave-summary?year=`
- `GET /api/v1/dashboard/payroll-summary?year=`

Each endpoint aggregates data from existing repositories (EmployeeRepository, LeaveRequestRepository, PayrollPeriodRepository) and returns chart-ready data.

### Task 13: Add department tree endpoint

**Files:**
- Modify: `src/main/java/com/company/hrms/organization/interfaces/api/DepartmentController.java`
- Modify: `src/main/java/com/company/hrms/organization/application/DepartmentService.java`

Add `GET /api/v1/departments/tree` returning recursive structure with nested employees.

- [ ] **Step 1: Commit**

```bash
git add src/main/java/com/company/hrms/reporting/ src/main/java/com/company/hrms/organization/
git commit -m "feat: add dashboard analytics and department tree endpoints"
```

---

## Phase 8: Frontend — Auth & Shell Layouts

### Task 14: Create useRole hook and update router

**Files:**
- Create: `web-admin/src/shared/auth/useRole.ts`
- Modify: `web-admin/src/app/router.tsx`

- [ ] **Step 1: Create useRole hook**

```typescript
import { useMemo } from 'react';

type Role = 'ADMIN' | 'EMPLOYEE';

export function useRole(): Role {
  return useMemo(() => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return 'EMPLOYEE';
      const payload = JSON.parse(atob(token.split('.')[1]));
      return payload?.role === 'ADMIN' ? 'ADMIN' : 'EMPLOYEE';
    } catch {
      return 'EMPLOYEE';
    }
  }, []);
}
```

- [ ] **Step 2: Update router with all new routes**

Modify `router.tsx` to use role-based shell selection and add all 23 routes from the spec's route map. The router checks `useRole()` and renders `AdminShell` or `EmployeeShell` accordingly, and adds lazy-loaded routes for all new pages.

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/shared/auth/useRole.ts web-admin/src/app/router.tsx
git commit -m "feat: add role hook and extended route map"
```

### Task 15: Create EmployeeShell layout

**Files:**
- Create: `web-admin/src/app/layout/EmployeeShell.tsx`
- Modify: `web-admin/src/app/layout/AdminShell.tsx` (rename export, add new nav items)

- [ ] **Step 1: Rename AppShell to AdminShell**

Keep existing `AppShell.tsx` but export as `AdminShell`. Add new nav items for Attendance, Documents, Onboarding, Training, Assets, Announcements, Audit.

- [ ] **Step 2: Create EmployeeShell**

```tsx
import {
  HomeOutlined, UserOutlined, WalletOutlined, CalendarOutlined,
  ClockCircleOutlined, FileOutlined, CompassOutlined, BookOutlined, MenuOutlined
} from '@ant-design/icons';
import { Button, Drawer, Layout, Menu, Typography } from 'antd';
import { useState } from 'react';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';

const { Header, Content, Sider } = Layout;
const { Text } = Typography;

const navItems = [
  { key: '/ess/dashboard', icon: <HomeOutlined />, label: 'Tổng quan' },
  { key: '/ess/profile', icon: <UserOutlined />, label: 'Hồ sơ' },
  { key: '/ess/payslips', icon: <WalletOutlined />, label: 'Phiếu lương' },
  { key: '/ess/leave', icon: <CalendarOutlined />, label: 'Nghỉ phép' },
  { key: '/ess/attendance', icon: <ClockCircleOutlined />, label: 'Chấm công' },
  { key: '/ess/documents', icon: <FileOutlined />, label: 'Tài liệu' },
  { key: '/ess/onboarding', icon: <CompassOutlined />, label: 'Onboarding' },
  { key: '/ess/training', icon: <BookOutlined />, label: 'Đào tạo' },
];

export function EmployeeShell() {
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const selectedKey = navItems.find(i => location.pathname.startsWith(i.key))?.key ?? '/ess/dashboard';

  return (
    <Layout className="app-shell">
      <Sider className="app-shell__sider" width={232} theme="light" breakpoint="lg" collapsedWidth={0} trigger={null}>
        <div className="app-shell__brand">HRMS Nhân viên</div>
        <Menu mode="inline" selectedKeys={[selectedKey]} items={navItems}
          onClick={({ key }) => { navigate(key); setMobileNavOpen(false); }} />
      </Sider>
      <Layout>
        <Header className="app-shell__header">
          <div className="app-shell__header-left">
            <Button className="app-shell__menu-button" type="text" icon={<MenuOutlined />}
              aria-label="Mở điều hướng" onClick={() => setMobileNavOpen(true)} />
            <Text strong>Cổng nhân viên</Text>
          </div>
        </Header>
        <Content className="app-shell__content"><Outlet /></Content>
      </Layout>
      <Drawer className="app-shell__mobile-nav" title="HRMS Nhân viên" placement="left"
        width={260} open={mobileNavOpen} onClose={() => setMobileNavOpen(false)}>
        <Menu mode="inline" selectedKeys={[selectedKey]} items={navItems}
          onClick={({ key }) => { navigate(key); setMobileNavOpen(false); }} />
      </Drawer>
    </Layout>
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/app/layout/
git commit -m "feat: add AdminShell and EmployeeShell with role-based routing"
```

---

## Phase 9: Frontend — Enhanced Dashboard with ECharts

### Task 16: Rewrite DashboardPage with ECharts

**Files:**
- Modify: `web-admin/src/features/dashboard/DashboardPage.tsx`

- [ ] **Step 1: Implement enhanced dashboard**

The page will render:
1. Row 1: 5 Statistic cards (total employees, active, departments, open payrolls, pending leaves) with `Statistic` from antd
2. Row 2: Employee trend line chart (ECharts `echarts-for-react`) + Department distribution pie chart
3. Row 3: Department headcount horizontal bar chart
4. Row 4: Leave summary + Payroll cost trend
5. Row 5: Recent activities table
6. Toolbar: Date range picker + Export button

Use `echarts-for-react` `<ReactECharts>` component with option objects matching the spec's chart requirements.

- [ ] **Step 2: Verify build**

```bash
npm --prefix web-admin run build
```

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/features/dashboard/DashboardPage.tsx
git commit -m "feat: enhanced dashboard with ECharts analytics"
```

---

## Phase 10: Frontend — ESS Pages (8 pages)

### Task 17: Create all 8 ESS portal pages

**Files:**
- Create: `web-admin/src/features/ess/EssDashboardPage.tsx`
- Create: `web-admin/src/features/ess/MyProfilePage.tsx`
- Create: `web-admin/src/features/ess/MyPayslipsPage.tsx`
- Create: `web-admin/src/features/ess/MyLeavePage.tsx`
- Create: `web-admin/src/features/ess/MyAttendancePage.tsx`
- Create: `web-admin/src/features/ess/MyDocumentsPage.tsx`
- Create: `web-admin/src/features/ess/MyOnboardingPage.tsx`
- Create: `web-admin/src/features/ess/MyTrainingPage.tsx`

Each page follows the same pattern as existing admin pages (`AppTable` + `PageToolbar`) but:
- Fetches data from `/api/v1/self/*` or scoped endpoints (`/api/v1/time-entries/mine`, `/api/v1/documents/mine`, etc.)
- Passes `X-Employee-Id` header (decoded from JWT)
- Uses i18n `useTranslation()` for labels

Key pages:
- **MyAttendancePage**: Clock In/Out buttons + weekly timesheet with `AppTable`
- **MyLeavePage**: Create leave request form + leave balances + history table
- **MyPayslipsPage**: Table of payslips + detail drawer matching `PayrollPage` payslip view

- [ ] **Step 1: Create all ESS pages**

```bash
git add web-admin/src/features/ess/
git commit -m "feat: add 8 ESS portal pages"
```

---

## Phase 11: Frontend — New Admin Pages (7 pages)

### Task 18: Create AttendancePage, DocumentsPage, OnboardingPage, TrainingPage, AssetsPage, AnnouncementsPage, AuditLogPage

**Files:**
- Create: `web-admin/src/features/attendance/AttendancePage.tsx`
- Create: `web-admin/src/features/documents/DocumentsPage.tsx`
- Create: `web-admin/src/features/onboarding/OnboardingPage.tsx`
- Create: `web-admin/src/features/onboarding/OnboardingBoard.tsx`
- Create: `web-admin/src/features/training/TrainingPage.tsx`
- Create: `web-admin/src/features/training/CourseDetailPage.tsx`
- Create: `web-admin/src/features/assets/AssetsPage.tsx`
- Create: `web-admin/src/features/announcements/AnnouncementsPage.tsx`
- Create: `web-admin/src/features/audit/AuditLogPage.tsx`

Each page follows the established pattern:
- `AppTable` for listing with pagination
- `PageToolbar` for filters + action buttons
- `FormDrawer` for create/edit forms
- `Drawer` for detail views
- `apiClient` for API calls to respective endpoints

Key pages:
- **AttendancePage**: Table with employee/date/clockIn/clockOut/status columns, approve/reject actions
- **DocumentsPage**: Table + Upload button (antd Upload), category filter, download action
- **OnboardingBoard**: Kanban-style board with @dnd-kit (TODO/IN PROGRESS/DONE columns)
- **AnnouncementsPage**: Table + react-quill rich text editor in create/edit form
- **AuditLogPage**: Read-only table with entityType/action/date range filters

- [ ] **Step 1: Create all admin pages**

```bash
git add web-admin/src/features/attendance/ web-admin/src/features/documents/ web-admin/src/features/onboarding/ web-admin/src/features/training/ web-admin/src/features/assets/ web-admin/src/features/announcements/ web-admin/src/features/audit/
git commit -m "feat: add 7 new admin pages"
```

---

## Phase 12: Frontend — Recruitment Kanban + Interview UI

### Task 19: Create RecruitmentKanban, InterviewScheduler, InterviewFeedback

**Files:**
- Create: `web-admin/src/features/recruitment/RecruitmentKanban.tsx`
- Create: `web-admin/src/features/recruitment/InterviewScheduler.tsx`
- Create: `web-admin/src/features/recruitment/InterviewFeedback.tsx`
- Modify: `web-admin/src/features/recruitment/RecruitmentPage.tsx` (add tabs)

- [ ] **Step 1: Create RecruitmentKanban**

Uses `@dnd-kit/core` and `@dnd-kit/sortable` for drag-and-drop between columns (Screen, Phone Interview, Technical, Onsite, Offer, Hired, Rejected). Each card shows candidate name, position, and current stage. Drag to move → calls `/api/v1/applications/{id}/move-stage?stage=`.

- [ ] **Step 2: Create InterviewScheduler modal**

Modal form: date/time picker, interviewer select (from employee list), location input, meeting link input. Submits to `POST /api/v1/interviews`.

- [ ] **Step 3: Create InterviewFeedback modal**

Modal: rating 1-5 (Rate component), feedback text area. Submits to `PUT /api/v1/interviews/{id}/feedback`.

- [ ] **Step 4: Update RecruitmentPage with tabs**

Add Tabs: "Danh sách" (existing table), "Kanban" (RecruitmentKanban), "Phỏng vấn" (interview list).

- [ ] **Step 5: Commit**

```bash
git add web-admin/src/features/recruitment/
git commit -m "feat: add recruitment kanban, interview scheduler and feedback"
```

---

## Phase 13: Frontend — NotificationBell & Integration

### Task 20: Create NotificationBell and integrate into shells

**Files:**
- Create: `web-admin/src/shared/ui/NotificationBell.tsx`
- Modify: `web-admin/src/app/layout/AdminShell.tsx` (add to header)
- Modify: `web-admin/src/app/layout/EmployeeShell.tsx` (add to header)

- [ ] **Step 1: Create NotificationBell**

```tsx
import { BellOutlined } from '@ant-design/icons';
import { Badge, Dropdown, List, Typography } from 'antd';
import { useEffect, useState } from 'react';
import { apiClient } from '../api/client';

type Notification = { id: string; title: string; body: string; type: string; isRead: boolean; createdAt: string };

export function NotificationBell() {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    apiClient.get('/notifications/mine', { params: { page: 0, size: 5 } })
      .then(r => setNotifications(r.data.items ?? []));
    apiClient.get('/notifications/mine/count')
      .then(r => setUnreadCount(r.data.unreadCount ?? 0));
  }, []);

  const markRead = async (id: string) => {
    await apiClient.post(`/notifications/${id}/read`);
    setUnreadCount(c => c - 1);
  };

  const items = notifications.length === 0
    ? [{ key: 'empty', label: 'Không có thông báo' }]
    : notifications.map(n => ({
        key: n.id,
        label: (
          <div onClick={() => markRead(n.id)} style={{ fontWeight: n.isRead ? 'normal' : 'bold', maxWidth: 300 }}>
            <Typography.Text strong>{n.title}</Typography.Text>
            <br />
            <Typography.Text type="secondary" ellipsis>{n.body}</Typography.Text>
          </div>
        )
      }));

  return (
    <Dropdown menu={{ items }} trigger={['click']}>
      <Badge count={unreadCount} size="small">
        <BellOutlined style={{ fontSize: 18, cursor: 'pointer' }} />
      </Badge>
    </Dropdown>
  );
}
```

- [ ] **Step 2: Integrate into AdminShell and EmployeeShell headers**

Add `<NotificationBell />` + `<LanguageSwitcher />` to both shell headers alongside existing status tags.

- [ ] **Step 3: Commit**

```bash
git add web-admin/src/shared/ui/NotificationBell.tsx web-admin/src/app/layout/
git commit -m "feat: add notification bell and language switcher to shells"
```

---

## Phase 14: Frontend — Organization Chart

### Task 21: Create organization chart component and page

**Files:**
- Create: `web-admin/src/features/departments/OrgChart.tsx`
- Modify: `web-admin/src/features/departments/DepartmentsPage.tsx` (add tab)

- [ ] **Step 1: Create OrgChart using ECharts tree chart**

Fetch from `GET /api/v1/departments/tree`, render with ECharts tree chart type. Click node → drawer with department details + employee list.

- [ ] **Step 2: Commit**

```bash
git add web-admin/src/features/departments/
git commit -m "feat: add organization chart with ECharts tree"
```

---

## Phase 15: DB Migrations

### Task 22: Create all database migration scripts

**Files:**
- Create: `src/main/resources/db/migration/V11__create_time_entry.sql`
- Create: `src/main/resources/db/migration/V12__create_document.sql`
- Create: `src/main/resources/db/migration/V13__create_notification_announcement.sql`
- Create: `src/main/resources/db/migration/V14__create_onboarding.sql`
- Create: `src/main/resources/db/migration/V15__create_interview.sql`
- Create: `src/main/resources/db/migration/V16__create_training.sql`
- Create: `src/main/resources/db/migration/V17__create_asset.sql`
- Create: `src/main/resources/db/migration/V18__create_audit_log.sql`

Each migration creates the corresponding table(s) with columns matching the entity definitions from previous tasks.

- [ ] **Step 1: Create all migration scripts**

```bash
git add src/main/resources/db/migration/
git commit -m "feat: add database migrations for all new modules"
```

---

## Phase 16: Security Config Update

### Task 23: Update SecurityConfig with all new authorities

**Files:**
- Modify: `src/main/java/com/company/hrms/shared/security/SecurityConfig.java`

Add all new authorities to the JWT decoder: `attendance:read/create/approve`, `document:read/create/delete`, `notification:create`, `announcement:read/create/delete`, `onboarding:read/create/update`, `training:read/create/update`, `asset:read/create/update`, `audit:read`, `self:access`, and role claim.

- [ ] **Step 1: Commit**

```bash
git add src/main/java/com/company/hrms/shared/security/SecurityConfig.java
git commit -m "feat: add all new authorities to security config"
```

---

## Phase 17: Final Verification

### Task 24: Full build and test

- [ ] **Step 1: Run all backend tests**

```bash
mvn test
```
Expected: All tests PASS

- [ ] **Step 2: Build frontend**

```bash
npm --prefix web-admin run build
```
Expected: No errors

- [ ] **Step 3: Start application and verify health**

```bash
docker compose -f docker/compose.yml up -d
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```
Expected: App starts, migrations apply, health endpoint responds

---

## Dependency Map

```
Task 0 (Setup) ─────────────────────────────────────────────────────────────┐
                                                                            │
Task 1-3 (Time Tracking) ───┐                                               │
Task 4 (Documents) ─────────┤                                               │
Task 5-6 (Notifications) ───┤                                               │
Task 7 (Onboarding) ────────┤                                               │
Task 8 (Recruitment Ext) ───┤                                               │
Task 9-11 (Training/Asset/Audit) ─┤                                         │
Task 12-13 (Dashboard/Org) ────┤                                            │
                              │                                             │
                              └──→ Task 14 (Auth hook, Router) ─────────────┤
                                   Task 15 (Shells) ────────────────────────┤
                                   Task 16 (Dashboard ECharts) ─────────────┤
                                   Task 17 (ESS pages) ─────────────────────┤
                                   Task 18 (Admin pages) ───────────────────┤
                                   Task 19 (Kanban) ────────────────────────┤
                                   Task 20 (NotificationBell) ──────────────┤
                                   Task 21 (OrgChart) ──────────────────────┤
                                                                             │
                              Task 22 (Migrations) ─────────────────────────┤
                              Task 23 (Security Config) ────────────────────┤
                                                                             │
                                                                             └──→ Task 24 (Verify)
```

## Backend Module Summary

| # | Module | Type | Entities | Controller |
|---|--------|------|----------|------------|
| 1 | attendance (extend) | Mở rộng | TimeEntry, TimeEntryStatus | TimeTrackingController |
| 2 | document | MỚI | Document | DocumentController |
| 3 | integration (extend) | Mở rộng | Notification, Announcement | NotificationController, AnnouncementController |
| 4 | onboarding | MỚI | OnboardingTask, OnboardingTemplate, OnboardingTemplateTask | OnboardingController |
| 5 | recruitment (extend) | Mở rộng | Interview | (extend RecruitmentController) |
| 6 | training | MỚI | Course, Enrollment, Certification | TrainingController |
| 7 | asset | MỚI | Asset, AssetAssignment | AssetController |
| 8 | audit | MỚI | AuditLog | AuditLogController |
| 9 | reporting (extend) | Mở rộng | — | (extend DashboardController) |

## Frontend Route Map

| Path | Shell | Page | Role |
|------|-------|------|------|
| `/dashboard` | Admin | DashboardPage (enhanced) | ADMIN |
| `/departments` | Admin | DepartmentsPage + OrgChart | ADMIN |
| `/employees` | Admin | EmployeesPage | ADMIN |
| `/recruitment` | Admin | RecruitmentPage + Kanban | ADMIN |
| `/leave` | Admin | LeavePage | ADMIN |
| `/payroll` | Admin | PayrollPage | ADMIN |
| `/performance` | Admin | PerformancePage | ADMIN |
| `/attendance` | Admin | AttendancePage | ADMIN |
| `/documents` | Admin | DocumentsPage | ADMIN |
| `/onboarding` | Admin | OnboardingPage + Board | ADMIN |
| `/training` | Admin | TrainingPage | ADMIN |
| `/assets` | Admin | AssetsPage | ADMIN |
| `/announcements` | Admin | AnnouncementsPage | ADMIN |
| `/audit` | Admin | AuditLogPage | ADMIN |
| `/settings` | Admin | DevSettingsPage | ADMIN |
| `/ess/dashboard` | Employee | EssDashboardPage | EMPLOYEE |
| `/ess/profile` | Employee | MyProfilePage | EMPLOYEE |
| `/ess/payslips` | Employee | MyPayslipsPage | EMPLOYEE |
| `/ess/leave` | Employee | MyLeavePage | EMPLOYEE |
| `/ess/attendance` | Employee | MyAttendancePage | EMPLOYEE |
| `/ess/documents` | Employee | MyDocumentsPage | EMPLOYEE |
| `/ess/onboarding` | Employee | MyOnboardingPage | EMPLOYEE |
| `/ess/training` | Employee | MyTrainingPage | EMPLOYEE |
