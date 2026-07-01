package com.company.hrms.onboarding.interfaces.api;

import com.company.hrms.onboarding.application.OnboardingService;
import com.company.hrms.onboarding.domain.OnboardingTask;
import com.company.hrms.onboarding.domain.OnboardingTemplate;
import com.company.hrms.onboarding.domain.OnboardingTemplateTask;
import com.company.hrms.onboarding.domain.OnboardingStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/onboarding")
public class OnboardingController {
    private final OnboardingService service;

    public OnboardingController(OnboardingService service) { this.service = service; }

    @PostMapping("/start")
    @PreAuthorize("hasAuthority('onboarding:create')")
    public List<TaskResponse> startOnboarding(@RequestBody StartOnboardingRequest request) {
        return service.startOnboarding(request.employeeId(), request.templateId()).stream()
            .map(OnboardingController::toTaskResponse).toList();
    }

    @GetMapping("/tasks/{employeeId}")
    @PreAuthorize("hasAuthority('onboarding:read') or hasAuthority('self:access')")
    public List<TaskResponse> getTasks(@PathVariable UUID employeeId) {
        return service.getTasks(employeeId).stream()
            .map(OnboardingController::toTaskResponse).toList();
    }

    @PostMapping("/tasks/{id}/complete")
    @PreAuthorize("hasAuthority('onboarding:update')")
    public TaskResponse completeTask(@PathVariable UUID id) {
        return toTaskResponse(service.completeTask(id));
    }

    @PostMapping("/templates")
    @PreAuthorize("hasAuthority('onboarding:create')")
    public TemplateResponse createTemplate(@RequestBody CreateTemplateRequest request) {
        OnboardingTemplate t = service.createTemplate(request.name(), request.description());
        return new TemplateResponse(t.getId(), t.getName(), t.getDescription());
    }

    @GetMapping("/templates")
    @PreAuthorize("hasAuthority('onboarding:read')")
    public List<TemplateResponse> listTemplates() {
        return service.listTemplates().stream()
            .map(t -> new TemplateResponse(t.getId(), t.getName(), t.getDescription()))
            .toList();
    }

    @GetMapping("/templates/{id}/tasks")
    @PreAuthorize("hasAuthority('onboarding:read')")
    public List<TemplateTaskResponse> getTemplateTasks(@PathVariable UUID id) {
        return service.getTemplateTasks(id).stream()
            .map(tt -> new TemplateTaskResponse(tt.getId(), tt.getTemplateId(), tt.getTitle(), tt.getDescription(), tt.getOrderIndex()))
            .toList();
    }

    @PostMapping("/templates/{id}/tasks")
    @PreAuthorize("hasAuthority('onboarding:create')")
    public TemplateTaskResponse addTemplateTask(@PathVariable UUID id, @RequestBody AddTemplateTaskRequest request) {
        OnboardingTemplateTask tt = service.addTemplateTask(id, request.title(), request.description(), request.orderIndex());
        return new TemplateTaskResponse(tt.getId(), tt.getTemplateId(), tt.getTitle(), tt.getDescription(), tt.getOrderIndex());
    }

    @DeleteMapping("/templates/{id}")
    @PreAuthorize("hasAuthority('onboarding:delete')")
    public void deleteTemplate(@PathVariable UUID id) { service.deleteTemplate(id); }

    private static TaskResponse toTaskResponse(OnboardingTask t) {
        return new TaskResponse(t.getId(), t.getEmployeeId(), t.getTitle(), t.getDescription(), t.getStatus().name(), t.getCompletedAt());
    }

    public record StartOnboardingRequest(UUID employeeId, UUID templateId) {}
    public record TaskResponse(UUID id, UUID employeeId, String title, String description, String status, Instant completedAt) {}
    public record CreateTemplateRequest(String name, String description) {}
    public record TemplateResponse(UUID id, String name, String description) {}
    public record AddTemplateTaskRequest(String title, String description, int orderIndex) {}
    public record TemplateTaskResponse(UUID id, UUID templateId, String title, String description, int orderIndex) {}
}
