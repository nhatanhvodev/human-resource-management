package com.company.hrms.employee;

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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

@SpringBootTest
@ActiveProfiles("test")
class EmployeeApiIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void rejectsDuplicateEmployeeNoInSameTenant() throws Exception {
        MvcResult departmentResult = mvc.perform(post("/api/v1/departments")
                .header("X-Tenant-Id", "tenant-a")
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("department:create")))
                .contentType("application/json")
                .content("{\"code\":\"ENG2\",\"name\":\"Engineering 2\"}"))
            .andExpect(status().isCreated())
            .andReturn();

        String departmentId = extractId(departmentResult.getResponse().getContentAsString());

        String employeePayload = """
            {
              "employeeNo":"E-001",
              "fullName":"Nguyen Van A",
              "departmentId":"%s",
              "hireDate":"2026-06-01"
            }
            """.formatted(departmentId);

        mvc.perform(post("/api/v1/employees")
                .header("X-Tenant-Id", "tenant-a")
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("employee:create")))
                .contentType("application/json")
                .content(employeePayload))
            .andExpect(status().isOk());

        mvc.perform(post("/api/v1/employees")
                .header("X-Tenant-Id", "tenant-a")
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("employee:create")))
                .contentType("application/json")
                .content(employeePayload))
            .andExpect(status().isConflict());
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
