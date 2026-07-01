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
        return toResponse(service.create(request.recipientId(), request.title(), request.body(),
            request.type(), request.detail(), request.fileUrl(), request.fileName()));
    }

    private static NotificationResponse toResponse(Notification n) {
        return new NotificationResponse(n.getId(), n.getTitle(), n.getBody(), n.getType(), n.isRead(), n.getCreatedAt(),
            n.getCreatorName(), n.getDetail(), n.getFileUrl(), n.getFileName());
    }

    public record CreateNotificationRequest(UUID recipientId, String title, String body, String type,
                                            String detail, String fileUrl, String fileName) {}
    public record NotificationResponse(UUID id, String title, String body, String type, boolean isRead, Instant createdAt,
                                       String creatorName, String detail, String fileUrl, String fileName) {}
}
