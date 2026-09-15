package com.company.hrms.security;

import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.cookie;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
class RefreshTokenIT {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
    }

    @Test
    void loginSetsHttpOnlyRefreshCookie() throws Exception {
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"username":"line-manager","password":"manager123","tenantId":"default"}
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.token").isNotEmpty())
            .andExpect(cookie().exists("hrms_refresh"))
            .andExpect(cookie().httpOnly("hrms_refresh", true));
    }

    @Test
    void refreshRotatesAndOldTokenIsRejected() throws Exception {
        MvcResult login = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"username":"line-manager","password":"manager123","tenantId":"default"}
                    """))
            .andExpect(status().isOk())
            .andReturn();

        Cookie first = login.getResponse().getCookie("hrms_refresh");
        assertThat(first).isNotNull();
        assertThat(first.getValue()).isNotBlank();

        // First rotation succeeds and yields a new cookie.
        MvcResult rotated = mvc.perform(post("/api/v1/auth/refresh")
                .cookie(first))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.token").isNotEmpty())
            .andExpect(cookie().exists("hrms_refresh"))
            .andReturn();

        Cookie second = rotated.getResponse().getCookie("hrms_refresh");
        assertThat(second).isNotNull();
        assertThat(second.getValue()).isNotEqualTo(first.getValue());

        // Reuse of the revoked token is rejected.
        mvc.perform(post("/api/v1/auth/refresh")
                .cookie(first))
            .andExpect(status().isUnauthorized());

        // The rotated access token works.
        String accessToken = new com.fasterxml.jackson.databind.ObjectMapper()
            .readTree(rotated.getResponse().getContentAsString()).get("token").asText();
        mvc.perform(get("/api/v1/authz/me")
                .header("Authorization", "Bearer " + accessToken))
            .andExpect(status().isOk());
    }

    @Test
    void logoutRevokesRefreshToken() throws Exception {
        MvcResult login = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"username":"line-manager","password":"manager123","tenantId":"default"}
                    """))
            .andExpect(status().isOk())
            .andReturn();

        Cookie refresh = login.getResponse().getCookie("hrms_refresh");
        assertThat(refresh).isNotNull();

        mvc.perform(post("/api/v1/auth/logout")
                .cookie(refresh))
            .andExpect(status().isNoContent())
            .andExpect(cookie().maxAge("hrms_refresh", 0));

        mvc.perform(post("/api/v1/auth/refresh")
                .cookie(refresh))
            .andExpect(status().isUnauthorized());
    }

    @Test
    void refreshWithoutCookieIsUnauthorized() throws Exception {
        mvc.perform(post("/api/v1/auth/refresh"))
            .andExpect(status().isUnauthorized());
    }
}
