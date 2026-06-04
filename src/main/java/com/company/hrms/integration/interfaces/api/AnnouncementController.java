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

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('announcement:create')")
    public AnnouncementResponse update(@PathVariable UUID id, @RequestBody CreateAnnouncementRequest request) {
        return toResponse(service.update(id, request.title(), request.content(),
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
