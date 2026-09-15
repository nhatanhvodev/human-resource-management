package com.company.hrms.integration.interfaces.api;

import com.company.hrms.integration.application.NotificationService;
import com.company.hrms.integration.domain.Notification;
import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.security.SecurityUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

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
    public PageResponse<NotificationResponse> mine(@RequestParam(defaultValue = "false") boolean unreadOnly,
                                                    Pageable pageable) {
        UUID employeeId = currentEmployeeId();
        return PageResponse.from(service.listMine(employeeId, unreadOnly, pageable)
            .map(NotificationController::toResponse));
    }

    @GetMapping("/mine/count")
    @PreAuthorize("hasAuthority('self:access')")
    public Map<String, Long> unreadCount() {
        return Map.of("unreadCount", service.unreadCount(currentEmployeeId()));
    }

    @PostMapping("/{id}/read")
    @PreAuthorize("hasAuthority('self:access')")
    public void markRead(@PathVariable UUID id) {
        service.markRead(id, currentEmployeeId());
    }

    @GetMapping
    @PreAuthorize("hasAuthority('notification:read')")
    public PageResponse<NotificationResponse> listAll(Pageable pageable) {
        return PageResponse.from(service.listAll(pageable)
            .map(NotificationController::toResponse));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('notification:create')")
    public NotificationResponse create(@RequestBody CreateNotificationRequest request) {
        return toResponse(service.create(request.recipientId(), request.title(), request.body(),
            request.type(), request.detail(), request.fileUrl(), request.fileName()));
    }

    private static UUID currentEmployeeId() {
        return SecurityUtils.getCurrentEmployeeId()
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Not authenticated"));
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
