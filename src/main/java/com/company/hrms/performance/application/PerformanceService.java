package com.company.hrms.performance.application;

import com.company.hrms.performance.domain.*;
import com.company.hrms.performance.infrastructure.*;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class PerformanceService {
    private final AppraisalCycleRepository cycleRepository;
    private final PerformanceReviewRepository reviewRepository;
    private final KPIRepository kpiRepository;

    public PerformanceService(AppraisalCycleRepository cycleRepository,
                              PerformanceReviewRepository reviewRepository,
                              KPIRepository kpiRepository) {
        this.cycleRepository = cycleRepository;
        this.reviewRepository = reviewRepository;
        this.kpiRepository = kpiRepository;
    }

    // ── DTO records ────────────────────────────────────────────────

    public record AppraisalCycleDto(UUID id, String name, String cycleType,
                                    LocalDate startDate, LocalDate endDate, String status) {
    }

    public record PerformanceReviewDto(UUID id, String cycleName, UUID employeeId,
                                        String reviewerType, UUID reviewerId, BigDecimal overallScore,
                                        String strengths, String improvements, String status,
                                        Instant submittedAt) {
    }

    public record KpiDto(UUID id, UUID employeeId, String title, String description,
                          BigDecimal targetScore, BigDecimal actualScore, BigDecimal weight) {
    }

    // ── Service methods ────────────────────────────────────────────

    @Transactional(readOnly = true)
    public Page<AppraisalCycleDto> listCycles(Pageable pageable) {
        return cycleRepository.findByTenantId(TenantContext.get(), pageable)
                .map(this::toDto);
    }

    @Transactional(readOnly = true)
    public List<PerformanceReviewDto> listReviewsByCycle(UUID cycleId) {
        return reviewRepository.findByTenantIdAndCycle_Id(TenantContext.get(), cycleId)
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PerformanceReviewDto> listReviewsByEmployee(UUID employeeId) {
        return reviewRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId)
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<KpiDto> listKPIs(UUID cycleId) {
        return kpiRepository.findByTenantIdAndCycle_Id(TenantContext.get(), cycleId)
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<KpiDto> listKPIsByEmployee(UUID employeeId, UUID cycleId) {
        return kpiRepository.findByTenantIdAndEmployeeIdAndCycle_Id(TenantContext.get(), employeeId, cycleId)
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public AppraisalCycleDto getCycleById(UUID id) {
        return cycleRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new NotFoundException("CYCLE_NOT_FOUND"));
    }

    // ── Mapping helpers ────────────────────────────────────────────

    private AppraisalCycleDto toDto(AppraisalCycle cycle) {
        return new AppraisalCycleDto(
                cycle.getId(),
                cycle.getName(),
                cycle.getCycleType().name(),
                cycle.getStartDate(),
                cycle.getEndDate(),
                cycle.getStatus().name()
        );
    }

    private PerformanceReviewDto toDto(PerformanceReview review) {
        return new PerformanceReviewDto(
                review.getId(),
                review.getCycle().getName(),
                review.getEmployeeId(),
                review.getReviewerType().name(),
                review.getReviewerId(),
                review.getOverallScore(),
                review.getStrengths(),
                review.getImprovements(),
                review.getStatus().name(),
                review.getSubmittedAt()
        );
    }

    private KpiDto toDto(KPI kpi) {
        return new KpiDto(
                kpi.getId(),
                kpi.getEmployeeId(),
                kpi.getTitle(),
                kpi.getDescription(),
                kpi.getTargetScore(),
                kpi.getActualScore(),
                kpi.getWeight()
        );
    }
}
