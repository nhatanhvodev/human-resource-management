package com.company.hrms;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:h2:mem:hrms_seed_test;MODE=PostgreSQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE",
    "spring.jpa.hibernate.ddl-auto=validate"
})
class DemoSeedDataIT {
    @Autowired
    private JdbcTemplate jdbc;

    @Test
    void defaultTenantHasDetailedNonDuplicatedDemoData() {
        assertThat(count("department")).isGreaterThanOrEqualTo(16);
        assertThat(count("employee")).isGreaterThanOrEqualTo(130);
        assertThat(count("candidate")).isGreaterThanOrEqualTo(14);
        assertThat(count("job_posting")).isGreaterThanOrEqualTo(10);
        assertThat(count("recruitment_application")).isGreaterThanOrEqualTo(14);
        assertThat(count("leave_request")).isGreaterThanOrEqualTo(14);
        assertThat(count("payroll_period")).isGreaterThanOrEqualTo(6);
        assertThat(count("payroll_run")).isGreaterThanOrEqualTo(6);
        assertThat(count("position")).isGreaterThanOrEqualTo(20);

        assertThat(duplicateCount("department", "tenant_id, code")).isZero();
        assertThat(duplicateCount("employee", "tenant_id, employee_no")).isZero();
        assertThat(duplicateCount("position", "tenant_id, code")).isZero();
        assertThat(countInvalidEmployeeStatuses()).isZero();
        assertThat(countMojibakeRows()).isZero();
        assertThat(countEmployeesWithExtendedFields()).isGreaterThanOrEqualTo(48);
    }

    private int count(String tableName) {
        return jdbc.queryForObject(
            "select count(*) from " + tableName + " where tenant_id = 'default'",
            Integer.class
        );
    }

    private int duplicateCount(String tableName, String columns) {
        return jdbc.queryForObject(
            "select count(*) from (select " + columns + " from " + tableName
                + " where tenant_id = 'default' group by " + columns + " having count(*) > 1) duplicates",
            Integer.class
        );
    }

    private int countInvalidEmployeeStatuses() {
        return jdbc.queryForObject(
            "select count(*) from employee where tenant_id = 'default' and employment_status not in ('ACTIVE', 'INACTIVE')",
            Integer.class
        );
    }

    private int countEmployeesWithExtendedFields() {
        return jdbc.queryForObject(
            "select count(*) from employee where tenant_id = 'default'"
                + " and email is not null and phone is not null and gender is not null",
            Integer.class
        );
    }

    private int countMojibakeRows() {
        return jdbc.queryForObject(
            """
                select sum(row_count) from (
                    select count(*) row_count from department where tenant_id = 'default' and name like '%Ã%'
                    union all
                    select count(*) row_count from employee where tenant_id = 'default' and full_name like '%Ã%'
                    union all
                    select count(*) row_count from candidate where tenant_id = 'default' and full_name like '%Ã%'
                    union all
                    select count(*) row_count from job_posting where tenant_id = 'default' and title like '%Ã%'
                ) rows_with_mojibake
                """,
            Integer.class
        );
    }
}
