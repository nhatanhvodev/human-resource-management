package com.company.hrms.recruitment;

import com.company.hrms.employee.infrastructure.EmployeeRepository;
import com.company.hrms.recruitment.domain.ApplicationStatus;
import com.company.hrms.recruitment.infrastructure.RecruitmentApplicationRepository;
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

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

@SpringBootTest
@ActiveProfiles("test")
class CandidateConversionIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private RecruitmentApplicationRepository recruitmentApplicationRepository;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void convertsCandidateToEmployee() throws Exception {
        String tenant = "tenant-convert";

        MvcResult depResult = mvc.perform(post("/api/v1/departments")
                .header("X-Tenant-Id", tenant)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("department:create")))
                .contentType("application/json")
                .content("{\"code\":\"HR\",\"name\":\"HR\"}"))
            .andExpect(status().isCreated())
            .andReturn();
        String departmentId = extractId(depResult.getResponse().getContentAsString());

        MvcResult candidateResult = mvc.perform(post("/api/v1/candidates")
                .header("X-Tenant-Id", tenant)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("recruitment:create")))
                .contentType("application/json")
                .content("{\"fullName\":\"Tran Thi B\"}"))
            .andExpect(status().isOk())
            .andReturn();
        String candidateId = extractId(candidateResult.getResponse().getContentAsString());

        MvcResult postingResult = mvc.perform(post("/api/v1/job-postings")
                .header("X-Tenant-Id", tenant)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("recruitment:create")))
                .contentType("application/json")
                .content("{\"title\":\"Backend Engineer\"}"))
            .andExpect(status().isOk())
            .andReturn();
        String postingId = extractId(postingResult.getResponse().getContentAsString());

        String appPayload = """
            {"candidateId":"%s","jobPostingId":"%s","status":"OFFER_ACCEPTED"}
            """.formatted(candidateId, postingId);
        MvcResult appResult = mvc.perform(post("/api/v1/applications")
                .header("X-Tenant-Id", tenant)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("recruitment:create")))
                .contentType("application/json")
                .content(appPayload))
            .andExpect(status().isOk())
            .andReturn();
        String applicationId = extractId(appResult.getResponse().getContentAsString());

        String convertPayload = """
            {"employeeNo":"E-CONV-001","departmentId":"%s"}
            """.formatted(departmentId);
        mvc.perform(post("/api/v1/recruitment/applications/{id}/convert", applicationId)
                .header("X-Tenant-Id", tenant)
                .with(SecurityMockMvcRequestPostProcessors.jwt()
                    .authorities(new SimpleGrantedAuthority("recruitment:convert"),
                        new SimpleGrantedAuthority("employee:create")))
                .contentType("application/json")
                .content(convertPayload))
            .andExpect(status().isOk());

        assertThat(employeeRepository.existsByTenantIdAndEmployeeNo(tenant, "E-CONV-001")).isTrue();
        assertThat(recruitmentApplicationRepository.findById(UUID.fromString(applicationId)).orElseThrow().getStatus())
            .isEqualTo(ApplicationStatus.HIRED);
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
