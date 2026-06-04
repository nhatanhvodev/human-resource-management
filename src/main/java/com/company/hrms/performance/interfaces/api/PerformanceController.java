package com.company.hrms.performance.interfaces.api;

import com.company.hrms.performance.application.PerformanceService;
import com.company.hrms.performance.domain.*;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/performance")
public class PerformanceController {
    private final PerformanceService performanceService;

    public PerformanceController(PerformanceService performanceService) {
        this.performanceService = performanceService;
    }

    @GetMapping("/cycles")
    @PreAuthorize("hasAuthority('performance:read')")
    public PageResponse<CycleResponse> listCycles(Pageable pageable) {
        return PageResponse.from(performanceService.listCycles(pageable)
            .map(c -> new CycleResponse(c.getId(), c.getName(), c.getCycleType().name(),
                c.getStartDate(), c.getEndDate(), c.getStatus().name())));
    }

    @GetMapping("/cycles/{cycleId}/reviews")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<ReviewResponse> listReviews(@PathVariable UUID cycleId) {
        return performanceService.listReviewsByCycle(cycleId).stream()
            .map(r -> new ReviewResponse(r.getId(), r.getCycle().getId(), r.getEmployeeId(),
                r.getReviewerType().name(), r.getReviewerId(), r.getOverallScore(),
                r.getStrengths(), r.getImprovements(), r.getStatus().name(), r.getSubmittedAt()))
            .toList();
    }

    @GetMapping("/cycles/{cycleId}/kpis")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<KPIResponse> listKPIs(@PathVariable UUID cycleId) {
        return performanceService.listKPIs(cycleId).stream()
            .map(k -> new KPIResponse(k.getId(), k.getEmployeeId(), k.getCycle().getId(),
                k.getTitle(), k.getDescription(), k.getTargetScore(), k.getActualScore(), k.getWeight()))
            .toList();
    }

    @GetMapping("/employees/{employeeId}/reviews")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<ReviewResponse> listEmployeeReviews(@PathVariable UUID employeeId) {
        return performanceService.listReviewsByEmployee(employeeId).stream()
            .map(r -> new ReviewResponse(r.getId(), r.getCycle().getId(), r.getEmployeeId(),
                r.getReviewerType().name(), r.getReviewerId(), r.getOverallScore(),
                r.getStrengths(), r.getImprovements(), r.getStatus().name(), r.getSubmittedAt()))
            .toList();
    }

    public record CycleResponse(UUID id, String name, String cycleType,
                                LocalDate startDate, LocalDate endDate, String status) {}

    public record ReviewResponse(UUID id, UUID cycleId, UUID employeeId, String reviewerType,
                                  UUID reviewerId, BigDecimal overallScore,
                                  String strengths, String improvements,
                                  String status, Instant submittedAt) {}

    public record KPIResponse(UUID id, UUID employeeId, UUID cycleId, String title,
                               String description, BigDecimal targetScore,
                               BigDecimal actualScore, BigDecimal weight) {}
}
