package com.company.hrms.recruitment;

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

import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class RecruitmentAdminApiIT {
    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void listsApplicationsByStatus() throws Exception {
        String tenantId = "tenant-r";
        String candidateId = createCandidate(tenantId, "Applicant One");
        String jobPostingId = createJobPosting(tenantId, "Backend Engineer");
        createApplication(tenantId, candidateId, jobPostingId, "OFFER_ACCEPTED");
        createApplication(tenantId, candidateId, jobPostingId, "APPLIED");

        mvc.perform(get("/api/v1/applications")
                .param("status", "OFFER_ACCEPTED")
                .header("X-Tenant-Id", "tenant-r")
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray())
            .andExpect(jsonPath("$.items[*].status", hasItem("OFFER_ACCEPTED")))
            .andExpect(jsonPath("$.items[*].status", not(hasItem("APPLIED"))));
    }

    @Test
    void listsCandidates() throws Exception {
        createCandidate("tenant-r-candidate-list", "Candidate List A");

        mvc.perform(get("/api/v1/candidates")
                .header("X-Tenant-Id", "tenant-r-candidate-list")
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray());
    }

    @Test
    void updatesCandidate() throws Exception {
        String tenantId = "tenant-r-candidate-update";
        String candidateId = createCandidate(tenantId, "Candidate Before");

        mvc.perform(put("/api/v1/candidates/{id}", candidateId)
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:update")))
                .contentType("application/json")
                .content("{\"fullName\":\"Candidate After\"}"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(candidateId))
            .andExpect(jsonPath("$.fullName").value("Candidate After"));
    }

    @Test
    void listsJobPostings() throws Exception {
        createJobPosting("tenant-r-posting-list", "HR Manager");

        mvc.perform(get("/api/v1/job-postings")
                .header("X-Tenant-Id", "tenant-r-posting-list")
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:read"))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.items").isArray());
    }

    @Test
    void updatesJobPosting() throws Exception {
        String tenantId = "tenant-r-posting-update";
        String jobPostingId = createJobPosting(tenantId, "QA Engineer");

        mvc.perform(put("/api/v1/job-postings/{id}", jobPostingId)
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:update")))
                .contentType("application/json")
                .content("{\"title\":\"Senior QA Engineer\"}"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(jobPostingId))
            .andExpect(jsonPath("$.title").value("Senior QA Engineer"));
    }

    private String createCandidate(String tenantId, String fullName) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/candidates")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:create")))
                .contentType("application/json")
                .content("""
                    {
                      "fullName":"%s"
                    }
                    """.formatted(fullName)))
            .andExpect(status().isOk())
            .andReturn();

        return extractId(result.getResponse().getContentAsString());
    }

    private String createJobPosting(String tenantId, String title) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/job-postings")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:create")))
                .contentType("application/json")
                .content("""
                    {
                      "title":"%s"
                    }
                    """.formatted(title)))
            .andExpect(status().isOk())
            .andReturn();

        return extractId(result.getResponse().getContentAsString());
    }

    private String createApplication(String tenantId, String candidateId, String jobPostingId, String status) throws Exception {
        MvcResult result = mvc.perform(post("/api/v1/applications")
                .header("X-Tenant-Id", tenantId)
                .with(jwt().authorities(new SimpleGrantedAuthority("recruitment:create")))
                .contentType("application/json")
                .content("""
                    {
                      "candidateId":"%s",
                      "jobPostingId":"%s",
                      "status":"%s"
                    }
                    """.formatted(candidateId, jobPostingId, status)))
            .andExpect(status().isOk())
            .andReturn();

        return extractId(result.getResponse().getContentAsString());
    }

    private static String extractId(String json) {
        return json.replaceAll("(?s).*\"id\"\\s*:\\s*\"([^\"]+)\".*", "$1");
    }
}
