package com.company.hrms.organization;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.UUID;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.hamcrest.Matchers.hasItem;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class DepartmentAdminApiIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void listsDepartmentsWithPaginationAndKeyword() throws Exception {
        createDepartment("tenant-a", "ENG", "Engineering");
        createDepartment("tenant-a", "HR", "Human Resources");

        mvc.perform(get("/api/v1/departments")
                .param("page", "0")
                .param("size", "10")
                .param("q", "Eng")
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("department:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].code", hasItem("ENG")))
            .andExpect(jsonPath("$.page").value(0));
    }

    @Test
    void getsUpdatesAndDeletesDepartment() throws Exception {
        String departmentId = createDepartment("tenant-a", "OPS", "Operations");

        mvc.perform(get("/api/v1/departments/{id}", departmentId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("department:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value("OPS"))
            .andExpect(jsonPath("$.name").value("Operations"));

        mvc.perform(put("/api/v1/departments/{id}", departmentId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("department:update")))
                .contentType("application/json")
                .content("{\"code\":\"OPS-NEW\",\"name\":\"Operations New\"}"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(departmentId))
            .andExpect(jsonPath("$.code").value("OPS-NEW"))
            .andExpect(jsonPath("$.name").value("Operations New"));

        mvc.perform(delete("/api/v1/departments/{id}", departmentId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("department:delete"))))
            .andExpect(status().isNoContent());

        mvc.perform(get("/api/v1/departments/{id}", departmentId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("department:read"))))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("NOT_FOUND"))
            .andExpect(jsonPath("$.message").value("DEPARTMENT_NOT_FOUND"));
    }

    @Test
    void returnsNotFoundWhenDepartmentMissingViaServicePath() throws Exception {
        mvc.perform(get("/api/v1/departments/{id}", UUID.randomUUID())
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("department:read"))))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.code").value("NOT_FOUND"))
            .andExpect(jsonPath("$.message").value("DEPARTMENT_NOT_FOUND"));
    }

    private String createDepartment(String tenantId, String code, String name) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/departments")
                .header("X-Tenant-Id", tenantId)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("department:create")))
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

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
