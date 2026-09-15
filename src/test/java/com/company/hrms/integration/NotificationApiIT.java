package com.company.hrms.integration;

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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class NotificationApiIT {
    @Autowired
    private WebApplicationContext context;

    @Autowired
    private JdbcTemplate jdbc;

    private MockMvc mvc;
    private static final String TENANT = "tenant-notif";
    private static final String EMPLOYEE_ID = "b1200000-0000-4000-8000-000000000001";
    private static final String OTHER_EMPLOYEE_ID = "b1200000-0000-4000-8000-000000000002";
    private static final String NOTIF_ID_1 = "c1200000-0000-4000-8000-000000000001";
    private static final String NOTIF_ID_2 = "c1200000-0000-4000-8000-000000000002";

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
        seedData();
    }

    private void seedData() {
        jdbc.update("DELETE FROM notification WHERE tenant_id = ?", TENANT);

        jdbc.update("""
            INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
            VALUES (?, ?, ?, 'Test Title 1', 'Test Body 1', 'INFO', false, now(), now())
            """, NOTIF_ID_1, TENANT, EMPLOYEE_ID);

        jdbc.update("""
            INSERT INTO notification (id, tenant_id, recipient_id, title, body, type, is_read, created_at, updated_at)
            VALUES (?, ?, ?, 'Test Title 2', 'Test Body 2', 'INFO', false, now(), now())
            """, NOTIF_ID_2, TENANT, OTHER_EMPLOYEE_ID);
    }

    @Test
    void returnsMyNotifications() throws Exception {
        mvc.perform(get("/api/v1/notifications/mine")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[0].title").value("Test Title 1"));
    }

    @Test
    void returnsUnreadOnly() throws Exception {
        mvc.perform(get("/api/v1/notifications/mine")
                .header("X-Tenant-Id", TENANT)
                .param("unreadOnly", "true")
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items", hasSize(1)));
    }

    @Test
    void returnsUnreadCount() throws Exception {
        mvc.perform(get("/api/v1/notifications/mine/count")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.unreadCount").value(1));
    }

    @Test
    void marksOwnNotificationAsRead() throws Exception {
        mvc.perform(post("/api/v1/notifications/" + NOTIF_ID_1 + "/read")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk());
    }

    @Test
    void rejectsMarkReadForOtherEmployeeNotification() throws Exception {
        mvc.perform(post("/api/v1/notifications/" + NOTIF_ID_2 + "/read")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isForbidden());
    }

    @Test
    void createsNotificationWithPermission() throws Exception {
        mvc.perform(post("/api/v1/notifications")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("notification:create")))
                .contentType("application/json")
                .content("""
                    {
                      "recipientId": "%s",
                      "title": "New Notification",
                      "body": "Test body",
                      "type": "INFO",
                      "detail": null,
                      "fileUrl": null,
                      "fileName": null
                    }
                    """.formatted(EMPLOYEE_ID)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("New Notification"))
            .andExpect(jsonPath("$.type").value("INFO"));
    }

    @Test
    void requiresAuthentication() throws Exception {
        mvc.perform(get("/api/v1/notifications/mine")
                .header("X-Tenant-Id", TENANT))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void requiresSelfAccessForMineEndpoints() throws Exception {
        mvc.perform(get("/api/v1/notifications/mine")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isForbidden());
    }

    @Test
    void requiresNotificationCreateForCreateEndpoint() throws Exception {
        mvc.perform(post("/api/v1/notifications")
                .header("X-Tenant-Id", TENANT)
                .with(jwt().jwt(j -> j.claim("employee_id", EMPLOYEE_ID))
                    .authorities(new SimpleGrantedAuthority("self:access")))
                .contentType("application/json")
                .content("""
                    {
                      "recipientId": "%s",
                      "title": "Test",
                      "body": "Test body",
                      "type": "INFO",
                      "detail": null,
                      "fileUrl": null,
                      "fileName": null
                    }
                    """.formatted(EMPLOYEE_ID)))
            .andExpect(status().isForbidden());
    }
}
