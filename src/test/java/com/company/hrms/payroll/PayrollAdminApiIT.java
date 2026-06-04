package com.company.hrms.payroll;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class PayrollAdminApiIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void listsPayrollPeriods() throws Exception {
        String tenantId = "tenant-pay-period-list";
        String firstPeriodId = createPayrollPeriod(tenantId, "2026-06-01", "2026-06-30");
        String secondPeriodId = createPayrollPeriod(tenantId, "2026-07-01", "2026-07-31");

        mvc.perform(get("/api/v1/payroll-periods")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].id", hasItem(firstPeriodId)))
            .andExpect(jsonPath("$.items[*].id", hasItem(secondPeriodId)))
            .andExpect(jsonPath("$.items[*].status", hasItem("OPEN")));
    }

    @Test
    void listsPayrollRunsByPeriod() throws Exception {
        String tenantId = "tenant-pay-runs-filter";
        String firstPeriodId = createPayrollPeriod(tenantId, "2026-06-01", "2026-06-30");
        String secondPeriodId = createPayrollPeriod(tenantId, "2026-07-01", "2026-07-31");
        String firstRunId = executePayrollRun(tenantId, firstPeriodId);
        String secondRunId = executePayrollRun(tenantId, secondPeriodId);

        mvc.perform(get("/api/v1/payroll-runs")
                .param("periodId", firstPeriodId)
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].id", hasItem(firstRunId)))
            .andExpect(jsonPath("$.items[*].id", not(hasItem(secondRunId))));
    }

    @Test
    void defaultTenantSeededPayrollDataIsReadable() throws Exception {
        mvc.perform(get("/api/v1/payroll-periods")
                .param("page", "0")
                .param("size", "20")
                .header("X-Tenant-Id", "default")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items[*].id", hasItem("a2000000-0000-4000-8000-000000000007")))
            .andExpect(jsonPath("$.items[*].periodFrom", hasItem("2024-01-01")))
            .andExpect(jsonPath("$.items[*].status", not(hasItem("COMPLETED"))));

        mvc.perform(get("/api/v1/payroll-runs")
                .param("periodId", "a2000000-0000-4000-8000-000000000007")
                .param("page", "0")
                .param("size", "10")
                .header("X-Tenant-Id", "default")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items[*].id", hasItem("a3000000-0000-4000-8000-000000000007")))
            .andExpect(jsonPath("$.items[*].status", hasItem("EXECUTED")));

        mvc.perform(get("/api/v1/payroll-runs/{runId}/payslips", "a3000000-0000-4000-8000-000000000007")
                .header("X-Tenant-Id", "default")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$[*].netPay").isNotEmpty());

        mvc.perform(get("/api/v1/payroll-runs/{runId}/payslips", "f3000000-0000-4000-8000-000000000001")
                .header("X-Tenant-Id", "default")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$[*].netPay").isNotEmpty());
    }

    private String createPayrollPeriod(String tenantId, String fromDate, String toDate) throws Exception {
        MvcResult periodResult = mvc.perform(post("/api/v1/payroll-periods")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:create")))
                .contentType("application/json")
                .content("""
                    {
                      "fromDate":"%s",
                      "toDate":"%s"
                    }
                    """.formatted(fromDate, toDate)))
            .andExpect(status().isOk())
            .andReturn();

        return extractId(periodResult.getResponse().getContentAsString());
    }

    private String executePayrollRun(String tenantId, String periodId) throws Exception {
        MvcResult runResult = mvc.perform(post("/api/v1/payroll-runs/{periodId}/execute", periodId)
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:execute"))))
            .andExpect(status().isOk())
            .andReturn();

        return extractId(runResult.getResponse().getContentAsString());
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
