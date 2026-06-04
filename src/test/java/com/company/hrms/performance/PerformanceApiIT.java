package com.company.hrms.performance;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class PerformanceApiIT {
    @Autowired
    private WebApplicationContext context;

    @Autowired
    private JdbcTemplate jdbc;

    private MockMvc mvc;
    private static final String TENANT = "tenant-perf";
    private String cycleId;
    private String employeeId;
    private String departmentId;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
        cycleId = "a1100000-0000-4000-8000-000000000001";
        employeeId = "a1100000-0000-4000-8000-eeee00000001";
        departmentId = "a1100000-0000-4000-8000-000000000d01";
        seedPerformanceData();
    }

    private void seedPerformanceData() {
        jdbc.update("""
            INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
            SELECT ?, ?, 'PERF-DEPT', 'Performance Dept', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM department WHERE id = ?)
            """, departmentId, TENANT, departmentId);

        jdbc.update("""
            INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, created_at, updated_at)
            SELECT ?, ?, 'PERF-EMP', 'Performance Employee', ?, '2026-01-01', 'ACTIVE', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM employee WHERE tenant_id = ? AND employee_no = 'PERF-EMP')
            """, employeeId, TENANT, departmentId, TENANT);

        jdbc.update("""
            INSERT INTO appraisal_cycle (id, tenant_id, name, cycle_type, start_date, end_date, status, created_at, updated_at)
            SELECT ?, ?, 'Q2 2026', 'Q2', '2026-04-01', '2026-06-30', 'ACTIVE', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM appraisal_cycle WHERE id = ?)
            """, cycleId, TENANT, cycleId);

        String reviewId = "a1100000-0000-4000-8000-abad00000001";
        jdbc.update("""
            INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, created_at, updated_at)
            SELECT ?, ?, ?, ?, 'SELF', ?, 4.5, 'Strong teamwork', 'Time management', 'SUBMITTED', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM performance_review WHERE id = ?)
            """, reviewId, TENANT, cycleId, employeeId, employeeId, reviewId);

        String kpiId = "a1100000-0000-4000-8000-feed00000001";
        jdbc.update("""
            INSERT INTO kpi (id, tenant_id, cycle_id, employee_id, title, description, target_score, actual_score, weight, created_at, updated_at)
            SELECT ?, ?, ?, ?, 'Code Quality', 'Maintain 95%% test coverage', 5.0, 4.5, 1.0, now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM kpi WHERE id = ?)
            """, kpiId, TENANT, cycleId, employeeId, kpiId);
    }

    @Test
    void listsAppraisalCycles() throws Exception {
        mvc.perform(get("/api/v1/performance/cycles")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().authorities(new SimpleGrantedAuthority("performance:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[0].name").value("Q2 2026"))
            .andExpect(jsonPath("$.items[0].cycleType").value("Q2"))
            .andExpect(jsonPath("$.items[0].status").value("ACTIVE"));
    }

    @Test
    void listsReviewsByCycle() throws Exception {
        mvc.perform(get("/api/v1/performance/cycles/{cycleId}/reviews", cycleId)
                .header("X-Tenant-Id", TENANT)
                .with(jwt().authorities(new SimpleGrantedAuthority("performance:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$", hasSize(1)))
            .andExpect(jsonPath("$[0].reviewerType").value("SELF"))
            .andExpect(jsonPath("$[0].overallScore").value(4.5))
            .andExpect(jsonPath("$[0].status").value("SUBMITTED"));
    }

    @Test
    void listsKPIsByCycle() throws Exception {
        mvc.perform(get("/api/v1/performance/cycles/{cycleId}/kpis", cycleId)
                .header("X-Tenant-Id", TENANT)
                .with(jwt().authorities(new SimpleGrantedAuthority("performance:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$", hasSize(1)))
            .andExpect(jsonPath("$[0].title").value("Code Quality"))
            .andExpect(jsonPath("$[0].targetScore").value(5.0))
            .andExpect(jsonPath("$[0].actualScore").value(4.5));
    }

    @Test
    void listsEmployeeReviews() throws Exception {
        mvc.perform(get("/api/v1/performance/employees/{employeeId}/reviews", employeeId)
                .header("X-Tenant-Id", TENANT)
                .with(jwt().authorities(new SimpleGrantedAuthority("performance:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$[0].strengths").value("Strong teamwork"))
            .andExpect(jsonPath("$[0].improvements").value("Time management"));
    }

    @Test
    void performanceEndpointsRequireAuthentication() throws Exception {
        mvc.perform(get("/api/v1/performance/cycles")
                .header("X-Tenant-Id", TENANT))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void performanceEndpointsRequirePerformanceReadAuthority() throws Exception {
        mvc.perform(get("/api/v1/performance/cycles")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isForbidden());
    }

    @Test
    void performanceDataIsTenantIsolated() throws Exception {
        mvc.perform(get("/api/v1/performance/cycles")
                .header("X-Tenant-Id", "tenant-perf-other")
                .with(jwt().authorities(new SimpleGrantedAuthority("performance:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items", hasSize(0)));
    }
}
