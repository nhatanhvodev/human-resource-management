package com.company.hrms.selfservice;

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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class SelfServiceApiIT {
    @Autowired
    private WebApplicationContext context;

    @Autowired
    private JdbcTemplate jdbc;

    private MockMvc mvc;
    private static final String TENANT = "tenant-self";
    private static final String EMPLOYEE_ID = "a1200000-0000-4000-8000-eeee00000001";
    private static final String DEPARTMENT_ID = "a1200000-0000-4000-8000-000000000d01";
    private static final String LEAVE_BALANCE_ID = "a1200000-0000-4000-8000-000000001b01";
    private static final String PAYROLL_PERIOD_ID = "a1200000-0000-4000-8000-00000000dd01";
    private static final String PAYROLL_RUN_ID = "a1200000-0000-4000-8000-00000000de01";
    private static final String PAYSLIP_ID = "a1200000-0000-4000-8000-00000000da01";
    private static final String APPRAISAL_CYCLE_ID = "a1200000-0000-4000-8000-acac00000001";
    private static final String PERFORMANCE_REVIEW_ID = "a1200000-0000-4000-8000-abad00000001";
    private static final String REVIEWER_ID = "a1200000-0000-4000-8000-cafe00000001";

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
        seedData();
    }

    private void seedData() {
        jdbc.update("""
            INSERT INTO department (id, tenant_id, code, name, created_at, updated_at)
            SELECT ?, ?, 'SELF-DEPT', 'Self Service Dept', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM department WHERE id = ?)
            """, DEPARTMENT_ID, TENANT, DEPARTMENT_ID);

        jdbc.update("""
            INSERT INTO employee (id, tenant_id, employee_no, full_name, department_id, hire_date, employment_status, email, phone, gender, created_at, updated_at)
            SELECT ?, ?, 'SELF-EMP', 'Self Service Employee', ?, '2026-01-15', 'ACTIVE', 'self@company.vn', '0901234567', 'MALE', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM employee WHERE id = ?)
            """, EMPLOYEE_ID, TENANT, DEPARTMENT_ID, EMPLOYEE_ID);

        jdbc.update("""
            INSERT INTO leave_balance (id, tenant_id, employee_id, "year", leave_type, total_days, used_days, pending_days, created_at, updated_at)
            SELECT ?, ?, ?, 2026, 'ANNUAL', 12, 3, 1, now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM leave_balance WHERE id = ?)
            """, LEAVE_BALANCE_ID, TENANT, EMPLOYEE_ID, LEAVE_BALANCE_ID);

        jdbc.update("""
            INSERT INTO payroll_period (id, tenant_id, period_from, period_to, status, created_at, updated_at)
            SELECT ?, ?, '2026-05-01', '2026-05-31', 'CLOSED', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM payroll_period WHERE id = ?)
            """, PAYROLL_PERIOD_ID, TENANT, PAYROLL_PERIOD_ID);

        jdbc.update("""
            INSERT INTO payroll_run (id, tenant_id, period_id, status, created_at, updated_at)
            SELECT ?, ?, ?, 'EXECUTED', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM payroll_run WHERE id = ?)
            """, PAYROLL_RUN_ID, TENANT, PAYROLL_PERIOD_ID, PAYROLL_RUN_ID);

        jdbc.update("""
            INSERT INTO payslip (id, tenant_id, payroll_run_id, employee_id, basic_salary, allowance, deduction, overtime_pay, net_pay, issued_at, created_at, updated_at)
            SELECT ?, ?, ?, ?, 15000000, 2000000, 1000000, 500000, 16500000, now(), now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM payslip WHERE id = ?)
            """, PAYSLIP_ID, TENANT, PAYROLL_RUN_ID, EMPLOYEE_ID, PAYSLIP_ID);

        jdbc.update("""
            INSERT INTO appraisal_cycle (id, tenant_id, name, cycle_type, start_date, end_date, status, created_at, updated_at)
            SELECT ?, ?, 'H1 2026', 'H1', '2026-01-01', '2026-06-30', 'ACTIVE', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM appraisal_cycle WHERE id = ?)
            """, APPRAISAL_CYCLE_ID, TENANT, APPRAISAL_CYCLE_ID);

        jdbc.update("""
            INSERT INTO performance_review (id, tenant_id, cycle_id, employee_id, reviewer_type, reviewer_id, overall_score, strengths, improvements, status, created_at, updated_at)
            SELECT ?, ?, ?, ?, 'MANAGER', ?, 4.0, 'Leadership', 'Delegation', 'SUBMITTED', now(), now()
            WHERE NOT EXISTS (SELECT 1 FROM performance_review WHERE id = ?)
            """, PERFORMANCE_REVIEW_ID, TENANT, APPRAISAL_CYCLE_ID, EMPLOYEE_ID, REVIEWER_ID, PERFORMANCE_REVIEW_ID);
    }

    @Test
    void returnsProfile() throws Exception {
        mvc.perform(get("/api/v1/self/profile")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(EMPLOYEE_ID))
            .andExpect(jsonPath("$.employeeNo").value("SELF-EMP"))
            .andExpect(jsonPath("$.fullName").value("Self Service Employee"))
            .andExpect(jsonPath("$.email").value("self@company.vn"))
            .andExpect(jsonPath("$.gender").value("MALE"));
    }

    @Test
    void updatesProfile() throws Exception {
        mvc.perform(put("/api/v1/self/profile")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("self:access")))
                .contentType("application/json")
                .content("""
                    {
                      "fullName":"Updated Self Name",
                      "departmentId":"%s",
                      "hireDate":"2026-01-15",
                      "email":"updated@company.vn",
                      "phone":"0909999999"
                    }
                    """.formatted(DEPARTMENT_ID)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.fullName").value("Updated Self Name"))
            .andExpect(jsonPath("$.email").value("updated@company.vn"))
            .andExpect(jsonPath("$.phone").value("0909999999"));
    }

    @Test
    void returnsLeaveBalances() throws Exception {
        mvc.perform(get("/api/v1/self/leave-balances")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$", hasSize(1)))
            .andExpect(jsonPath("$[0].leaveType").value("ANNUAL"))
            .andExpect(jsonPath("$[0].totalDays").value(12))
            .andExpect(jsonPath("$[0].usedDays").value(3))
            .andExpect(jsonPath("$[0].pendingDays").value(1));
    }

    @Test
    void createsLeaveRequest() throws Exception {
        mvc.perform(post("/api/v1/self/leave-requests")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("self:access")))
                .contentType("application/json")
                .content("""
                    {
                      "fromDate":"2026-06-10",
                      "toDate":"2026-06-12",
                      "leaveType":"ANNUAL",
                      "reason":"Family vacation"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.leaveType").value("ANNUAL"))
            .andExpect(jsonPath("$.fromDate").value("2026-06-10"))
            .andExpect(jsonPath("$.toDate").value("2026-06-12"))
            .andExpect(jsonPath("$.status").value("PENDING"));
    }

    @Test
    void returnsPayslips() throws Exception {
        mvc.perform(get("/api/v1/self/payslips")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$[0].basicSalary").value(15000000))
            .andExpect(jsonPath("$[0].netPay").value(16500000));
    }

    @Test
    void returnsReviews() throws Exception {
        mvc.perform(get("/api/v1/self/reviews")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("self:access"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$[0].cycleName").value("H1 2026"))
            .andExpect(jsonPath("$[0].reviewerType").value("MANAGER"))
            .andExpect(jsonPath("$[0].overallScore").value(4.0));
    }

    @Test
    void selfServiceEndpointsRequireAuthentication() throws Exception {
        mvc.perform(get("/api/v1/self/profile")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void selfServiceEndpointsRequireSelfAccessAuthority() throws Exception {
        mvc.perform(get("/api/v1/self/profile")
                .header("X-Tenant-Id", TENANT)
                .header("X-Employee-Id", EMPLOYEE_ID)
                .with(jwt().authorities(new SimpleGrantedAuthority("employee:read"))))
            .andExpect(status().isForbidden());
    }
}
