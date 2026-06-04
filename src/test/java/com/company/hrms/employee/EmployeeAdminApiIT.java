package com.company.hrms.employee;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
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

    @Autowired
    private JdbcTemplate jdbcTemplate;

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
    void listsEmployeesWithPositionTitle() throws Exception {
        String tenantId = "tenant-position-list";
        String departmentId = createDepartment(tenantId, "ENG-POS-LIST", "Engineering Position List");
        String positionId = "11111111-2222-4333-8444-555555555555";
        createPosition(positionId, tenantId, "DEV-POS-LIST", "Backend Developer", departmentId);
        String employeeId = createEmployee(tenantId, "E-POS-LIST", "Position User", departmentId, "2026-05-27");

        mvc.perform(put("/api/v1/employees/{id}/profile", employeeId)
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
                .contentType("application/json")
                .content("""
                    {
                      "fullName":"Position User",
                      "departmentId":"%s",
                      "hireDate":"2026-05-27",
                      "positionId":"%s"
                    }
                    """.formatted(departmentId, positionId)))
            .andExpect(status().isOk());

        mvc.perform(get("/api/v1/employees")
                .param("page", "0")
                .param("size", "10")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items[0].employeeNo").value("E-POS-LIST"))
            .andExpect(jsonPath("$.items[0].positionTitle").value("Backend Developer"));
    }

    @Test
    void listsPositionsForEmployeeProfileForm() throws Exception {
        String tenantId = "tenant-position-options";
        String departmentId = createDepartment(tenantId, "ENG-POS-OPTIONS", "Engineering Position Options");
        String positionId = "22222222-3333-4444-8555-666666666666";
        createPosition(positionId, tenantId, "DEV-POS-OPTIONS", "Frontend Developer", departmentId);

        mvc.perform(get("/api/v1/positions")
                .param("page", "0")
                .param("size", "10")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items[0].id").value(positionId))
            .andExpect(jsonPath("$.items[0].title").value("Frontend Developer"))
            .andExpect(jsonPath("$.items[0].departmentId").value(departmentId));
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

    @Test
    void rejectsInvalidUpdatePayloadWithBadRequest() throws Exception {
        String sourceDepartmentId = createDepartment("tenant-a", "ENG-UPD-INVALID", "Engineering Invalid Update");
        String employeeId = createEmployee("tenant-a", "E-UPD-INVALID", "Before Invalid", sourceDepartmentId, "2026-05-25");

        mvc.perform(put("/api/v1/employees/{id}", employeeId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
                .contentType("application/json")
                .content("""
                    {
                      "fullName":" ",
                      "departmentId":null,
                      "hireDate":null
                    }
                    """))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    void rejectsNullStatusPayloadWithBadRequest() throws Exception {
        String departmentId = createDepartment("tenant-a", "ENG-STATUS-INVALID", "Engineering Invalid Status");
        String employeeId = createEmployee("tenant-a", "E-STATUS-INVALID", "Status Invalid", departmentId, "2026-05-26");

        mvc.perform(patch("/api/v1/employees/{id}/status", employeeId)
                .header("X-Tenant-Id", "tenant-a")
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:update")))
                .contentType("application/json")
                .content("{\"employmentStatus\":null}"))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
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

    private void createPosition(String id, String tenantId, String code, String title, String departmentId) {
        jdbcTemplate.update("""
            INSERT INTO position (id, tenant_id, code, title, department_id, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, now(), now())
            """, java.util.UUID.fromString(id), tenantId, code, title, java.util.UUID.fromString(departmentId));
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
