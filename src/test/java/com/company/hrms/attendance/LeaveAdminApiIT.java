package com.company.hrms.attendance;

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
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class LeaveAdminApiIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void listsLeaveRequestsWithoutStatusFilter() throws Exception {
        String tenantId = "tenant-att-list-all";
        String pendingLeaveId = createLeaveRequest(tenantId, "2026-06-01", "2026-06-03");
        String rejectedLeaveId = createLeaveRequest(tenantId, "2026-06-04", "2026-06-05");
        rejectLeaveRequest(tenantId, rejectedLeaveId);

        mvc.perform(get("/api/v1/leave-requests")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("leave:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].id", hasItem(pendingLeaveId)))
            .andExpect(jsonPath("$.items[*].id", hasItem(rejectedLeaveId)))
            .andExpect(jsonPath("$.items[*].status", hasItem("PENDING")))
            .andExpect(jsonPath("$.items[*].status", hasItem("REJECTED")));
    }

    @Test
    void listsLeaveRequestsWithStatusFilter() throws Exception {
        String tenantId = "tenant-att-list-filtered";
        createLeaveRequest(tenantId, "2026-06-10", "2026-06-12");
        String rejectedLeaveId = createLeaveRequest(tenantId, "2026-06-13", "2026-06-14");
        rejectLeaveRequest(tenantId, rejectedLeaveId);

        mvc.perform(get("/api/v1/leave-requests")
                .param("status", "REJECTED")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("leave:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].id", hasItem(rejectedLeaveId)))
            .andExpect(jsonPath("$.items[*].status", hasItem("REJECTED")))
            .andExpect(jsonPath("$.items[*].status", not(hasItem("PENDING"))));
    }

    @Test
    void rejectsLeaveRequest() throws Exception {
        String leaveId = createLeaveRequest("tenant-att", "2026-06-01", "2026-06-03");

        mvc.perform(post("/api/v1/leave-requests/{id}/reject", leaveId)
                .header("X-Tenant-Id", "tenant-att")
                .with(jwt().authorities(new SimpleGrantedAuthority("leave:approve"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("REJECTED"));
    }

    private String createLeaveRequest(String tenantId, String fromDate, String toDate) throws Exception {
        UUID employeeId = UUID.randomUUID();
        MvcResult createResult = mvc.perform(post("/api/v1/leave-requests")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("leave:create")))
                .contentType("application/json")
                .content("""
                    {
                      "employeeId":"%s",
                      "fromDate":"%s",
                      "toDate":"%s"
                    }
                    """.formatted(employeeId, fromDate, toDate)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("PENDING"))
            .andReturn();

        return extractId(createResult.getResponse().getContentAsString());
    }

    private void rejectLeaveRequest(String tenantId, String leaveId) throws Exception {
        mvc.perform(post("/api/v1/leave-requests/{id}/reject", leaveId)
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("leave:approve"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("REJECTED"));
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
