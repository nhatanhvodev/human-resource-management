package com.company.hrms.performance.application;

import com.company.hrms.performance.domain.*;
import com.company.hrms.performance.infrastructure.*;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional(readOnly = true)
    public Page<AppraisalCycle> listCycles(Pageable pageable) {
        return cycleRepository.findByTenantId(TenantContext.get(), pageable);
    }

    @Transactional(readOnly = true)
    public List<PerformanceReview> listReviewsByCycle(UUID cycleId) {
        return reviewRepository.findByTenantIdAndCycle_Id(TenantContext.get(), cycleId);
    }

    @Transactional(readOnly = true)
    public List<PerformanceReview> listReviewsByEmployee(UUID employeeId) {
        return reviewRepository.findByTenantIdAndEmployeeId(TenantContext.get(), employeeId);
    }

    @Transactional(readOnly = true)
    public List<KPI> listKPIs(UUID cycleId) {
        return kpiRepository.findByTenantIdAndCycle_Id(TenantContext.get(), cycleId);
    }

    @Transactional(readOnly = true)
    public List<KPI> listKPIsByEmployee(UUID employeeId, UUID cycleId) {
        return kpiRepository.findByTenantIdAndEmployeeIdAndCycle_Id(TenantContext.get(), employeeId, cycleId);
    }

    @Transactional(readOnly = true)
    public AppraisalCycle getCycleById(UUID id) {
        return cycleRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("CYCLE_NOT_FOUND"));
    }
}
