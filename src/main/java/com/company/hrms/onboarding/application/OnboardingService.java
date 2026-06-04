package com.company.hrms.onboarding.application;

import com.company.hrms.onboarding.domain.*;
import com.company.hrms.onboarding.infrastructure.*;
import com.company.hrms.shared.domain.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class OnboardingService {
    private final OnboardingTaskRepository taskRepository;
    private final OnboardingTemplateRepository templateRepository;
    private final OnboardingTemplateTaskRepository templateTaskRepository;

    public OnboardingService(OnboardingTaskRepository taskRepository,
                            OnboardingTemplateRepository templateRepository,
                            OnboardingTemplateTaskRepository templateTaskRepository) {
        this.taskRepository = taskRepository;
        this.templateRepository = templateRepository;
        this.templateTaskRepository = templateTaskRepository;
    }

    @Transactional
    public List<OnboardingTask> startOnboarding(UUID employeeId, UUID templateId) {
        String tenantId = TenantContext.get();
        List<OnboardingTemplateTask> templateTasks = templateTaskRepository
            .findByTenantIdAndTemplateIdOrderByOrderIndexAsc(tenantId, templateId);
        return templateTasks.stream()
            .map(tt -> taskRepository.save(new OnboardingTask(UUID.randomUUID(), tenantId, employeeId,
                tt.getTitle(), tt.getDescription())))
            .toList();
    }

    @Transactional(readOnly = true)
    public List<OnboardingTask> getTasks(UUID employeeId) {
        return taskRepository.findByTenantIdAndEmployeeIdOrderByCreatedAtAsc(TenantContext.get(), employeeId);
    }

    @Transactional
    public OnboardingTask completeTask(UUID taskId) {
        OnboardingTask task = taskRepository.findById(taskId)
            .orElseThrow(() -> new NotFoundException("Onboarding task not found: " + taskId));
        task.complete();
        return taskRepository.save(task);
    }

    @Transactional
    public OnboardingTemplate createTemplate(String name, String description) {
        return templateRepository.save(new OnboardingTemplate(UUID.randomUUID(), TenantContext.get(), name, description));
    }

    @Transactional
    public OnboardingTemplateTask addTemplateTask(UUID templateId, String title, String description, int orderIndex) {
        return templateTaskRepository.save(new OnboardingTemplateTask(UUID.randomUUID(), TenantContext.get(),
            templateId, title, description, orderIndex));
    }

    @Transactional(readOnly = true)
    public List<OnboardingTemplate> listTemplates() {
        return templateRepository.findByTenantId(TenantContext.get());
    }

    @Transactional(readOnly = true)
    public List<OnboardingTemplateTask> getTemplateTasks(UUID templateId) {
        return templateTaskRepository.findByTenantIdAndTemplateIdOrderByOrderIndexAsc(TenantContext.get(), templateId);
    }

    @Transactional
    public void deleteTemplate(UUID templateId) {
        templateRepository.deleteById(templateId);
    }
}
