package com.company.hrms.reporting.interfaces.api;

import com.company.hrms.reporting.application.DashboardQueryService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/dashboard")
public class DashboardController {
    private final DashboardQueryService dashboardQueryService;

    public DashboardController(DashboardQueryService dashboardQueryService) {
        this.dashboardQueryService = dashboardQueryService;
    }

    @GetMapping("/summary")
    @PreAuthorize("hasAuthority('dashboard:read')")
    public DashboardQueryService.Summary summary() {
        return dashboardQueryService.summary();
    }

    @GetMapping("/activities")
    @PreAuthorize("hasAuthority('dashboard:read')")
    public List<DashboardQueryService.Activity> activities() {
        return dashboardQueryService.activities();
    }

    @GetMapping("/headcount-by-department")
    @PreAuthorize("hasAuthority('dashboard:read')")
    public List<DashboardQueryService.DepartmentHeadcount> headcountByDepartment() {
        return dashboardQueryService.headcountByDepartment();
    }
}
