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
            .map(c -> new CycleResponse(c.id(), c.name(), c.cycleType(),
                c.startDate(), c.endDate(), c.status())));
    }

    @GetMapping("/cycles/{cycleId}/reviews")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<ReviewResponse> listReviews(@PathVariable UUID cycleId) {
        return performanceService.listReviewsByCycle(cycleId).stream()
            .map(r -> new ReviewResponse(r.id(), null, r.employeeId(),
                r.reviewerType(), r.reviewerId(), r.overallScore(),
                r.strengths(), r.improvements(), r.status(), r.submittedAt()))
            .toList();
    }

    @GetMapping("/cycles/{cycleId}/kpis")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<KPIResponse> listKPIs(@PathVariable UUID cycleId) {
        return performanceService.listKPIs(cycleId).stream()
            .map(k -> new KPIResponse(k.id(), k.employeeId(), null,
                k.title(), k.description(), k.targetScore(), k.actualScore(), k.weight()))
            .toList();
    }

    @GetMapping("/employees/{employeeId}/reviews")
    @PreAuthorize("hasAuthority('performance:read')")
    public List<ReviewResponse> listEmployeeReviews(@PathVariable UUID employeeId) {
        return performanceService.listReviewsByEmployee(employeeId).stream()
            .map(r -> new ReviewResponse(r.id(), null, r.employeeId(),
                r.reviewerType(), r.reviewerId(), r.overallScore(),
                r.strengths(), r.improvements(), r.status(), r.submittedAt()))
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
