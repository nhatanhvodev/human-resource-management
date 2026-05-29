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

import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class EmployeeAdminApiIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void updatesEmployeeStatus() throws Exception {
        String departmentId = createDepartment("tenant-a", "ENG-STATUS", "Engineering Status");
        String employeeId = createEmployee("tenant-a", "E-STATUS", "Status User", departmentId, "2026-05-20");

        mvc.perform(patch("/api/v1/employees/{id}/status", employeeId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
                .contentType("application/json")
                .content("{\"employmentStatus\":\"INACTIVE\"}"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.employmentStatus").value("INACTIVE"));
    }

    @Test
    void listsEmployeesWithPaginationAndFilters() throws Exception {
        String departmentId = createDepartment("tenant-a", "ENG-LIST", "Engineering List");
        String firstEmployeeId = createEmployee("tenant-a", "E-LIST-1", "Alpha List", departmentId, "2026-05-21");
        createEmployee("tenant-a", "E-LIST-2", "Beta List", departmentId, "2026-05-22");

        mvc.perform(patch("/api/v1/employees/{id}/status", firstEmployeeId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
                .contentType("application/json")
                .content("{\"employmentStatus\":\"INACTIVE\"}"))
            .andExpect(status().isOk());

        mvc.perform(get("/api/v1/employees")
                .param("page", "0")
                .param("size", "10")
                .param("q", "List")
                .param("status", "ACTIVE")
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].employeeNo", hasItem("E-LIST-2")))
            .andExpect(jsonPath("$.items[*].employeeNo", not(hasItem("E-LIST-1"))))
            .andExpect(jsonPath("$.totalItems").value(1))
            .andExpect(jsonPath("$.page").value(0));
    }

    @Test
    void updatesEmployeeProfile() throws Exception {
        String sourceDepartmentId = createDepartment("tenant-a", "ENG-UPD", "Engineering Update");
        String targetDepartmentId = createDepartment("tenant-a", "OPS-UPD", "Operations Update");
        String employeeId = createEmployee("tenant-a", "E-UPD-1", "Before Name", sourceDepartmentId, "2026-05-23");

        mvc.perform(put("/api/v1/employees/{id}", employeeId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
                .contentType("application/json")
                .content("""
                    {
                      "fullName":"After Name",
                      "departmentId":"%s",
                      "hireDate":"2026-05-24"
                    }
                    """.formatted(targetDepartmentId)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(employeeId))
            .andExpect(jsonPath("$.fullName").value("After Name"))
            .andExpect(jsonPath("$.departmentId").value(targetDepartmentId))
            .andExpect(jsonPath("$.hireDate").value("2026-05-24"));
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

    private String createEmployee(String tenantId,
                                  String employeeNo,
                                  String fullName,
                                  String departmentId,
                                  String hireDate) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/employees")
                .header("X-Tenant-Id", tenantId)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("employee:create")))
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
