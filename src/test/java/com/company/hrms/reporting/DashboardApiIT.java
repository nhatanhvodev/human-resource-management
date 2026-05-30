package com.company.hrms.reporting;

import com.company.hrms.integration.domain.OutboxEvent;
import com.company.hrms.integration.domain.OutboxStatus;
import com.company.hrms.integration.infrastructure.OutboxEventRepository;
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

import java.util.UUID;

import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class DashboardApiIT {
    @Autowired
    private WebApplicationContext context;

    @Autowired
    private OutboxEventRepository outboxEventRepository;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void returnsDashboardSummary() throws Exception {
        mvc.perform(get("/api/v1/dashboard/summary")
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("dashboard:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.employees").isNumber())
            .andExpect(jsonPath("$.departments").isNumber());
    }

    @Test
    void returnsDashboardActivitiesWithOrderingAndLimit() throws Exception {
        String tenantId = "tenant-dashboard-activities";
        outboxEventRepository.save(new OutboxEvent(
            UUID.randomUUID(), "tenant-dashboard-activities-other", "OTHER_EVENT", "payload-other", OutboxStatus.PENDING));

        for (int i = 0; i < 22; i++) {
            outboxEventRepository.save(new OutboxEvent(
                UUID.randomUUID(), tenantId, "TEST_EVENT_" + i, "payload-" + i, OutboxStatus.PENDING));
            Thread.sleep(2);
        }

        mvc.perform(get("/api/v1/dashboard/activities")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("dashboard:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$", hasSize(20)))
            .andExpect(jsonPath("$[0].type").value("TEST_EVENT_21"))
            .andExpect(jsonPath("$[19].type").value("TEST_EVENT_2"))
            .andExpect(jsonPath("$[*].type", not(hasItem("OTHER_EVENT"))));
    }

    @Test
    void dashboardEndpointsRequireAuthentication() throws Exception {
        mvc.perform(get("/api/v1/dashboard/summary")
                .header("X-Tenant-Id", "tenant-auth-check"))
            .andExpect(status().isUnauthorized());

        mvc.perform(get("/api/v1/dashboard/activities")
                .header("X-Tenant-Id", "tenant-auth-check"))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void dashboardEndpointsRequireDashboardReadAuthority() throws Exception {
        mvc.perform(get("/api/v1/dashboard/summary")
                .header("X-Tenant-Id", "tenant-authz-check")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isForbidden());

        mvc.perform(get("/api/v1/dashboard/activities")
                .header("X-Tenant-Id", "tenant-authz-check")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isForbidden());
    }

    @Test
    void summaryIsTenantIsolated() throws Exception {
        String departmentId = createDepartment("tenant-dashboard-summary-a", "ENG-DB-SUM", "Engineering Dashboard");
        createEmployee("tenant-dashboard-summary-a", "E-DB-SUM-1", "Dashboard Employee", departmentId, "2026-05-29");

        mvc.perform(get("/api/v1/dashboard/summary")
                .header("X-Tenant-Id", "tenant-dashboard-summary-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("dashboard:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.employees").value(1))
            .andExpect(jsonPath("$.departments").value(1));

        mvc.perform(get("/api/v1/dashboard/summary")
                .header("X-Tenant-Id", "tenant-dashboard-summary-b")
                .with(jwt().authorities(new SimpleGrantedAuthority("dashboard:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.employees").value(0))
            .andExpect(jsonPath("$.departments").value(0));
    }

    private String createDepartment(String tenantId, String code, String name) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/departments")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("department:create")))
                .contentType("application/json")
                .content("""
                    {
                      "code":"%s",
                      "name":"%s"
                    }
                    """.formatted(code, name)))
            .andExpect(status().isCreated())
            .andReturn();

        return extractId(result.getResponse().getContentAsString());
    }

    private String createEmployee(String tenantId,
                                  String employeeNo,
                                  String fullName,
                                  String departmentId,
                                  String hireDate) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/employees")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:create")))
                .contentType("application/json")
                .content("""
                    {
                      "employeeNo":"%s",
                      "fullName":"%s",
                      "departmentId":"%s",
                      "hireDate":"%s"
                    }
                    """.formatted(employeeNo, fullName, departmentId, hireDate)))
            .andExpect(status().isOk())
            .andReturn();

        return extractId(result.getResponse().getContentAsString());
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
