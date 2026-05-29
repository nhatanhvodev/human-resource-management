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
    void listsPayrollRunsByPeriod() throws Exception {
        MvcResult periodResult = mvc.perform(post("/api/v1/payroll-periods")
                .header("X-Tenant-Id", "tenant-pay")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:create")))
                .contentType("application/json")
                .content("{\"fromDate\":\"2026-06-01\",\"toDate\":\"2026-06-30\"}"))
            .andExpect(status().isOk())
            .andReturn();
        String periodId = extractId(periodResult.getResponse().getContentAsString());

        mvc.perform(post("/api/v1/payroll-runs/{periodId}/execute", periodId)
                .header("X-Tenant-Id", "tenant-pay")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:execute"))))
            .andExpect(status().isOk());

        mvc.perform(get("/api/v1/payroll-runs")
                .param("periodId", periodId)
                .header("X-Tenant-Id", "tenant-pay")
                .with(jwt().authorities(new SimpleGrantedAuthority("payroll:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray());
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
