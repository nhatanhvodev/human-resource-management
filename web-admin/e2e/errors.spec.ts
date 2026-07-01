import { expect, test } from "playwright/test";

test.describe("Error states", () => {
  test("redirects to login when accessing protected page without auth", async ({
    page
  }) => {
    // Clear any existing auth state and set English locale
    await page.goto("/login");
    await page.evaluate(() => {
      localStorage.clear();
      localStorage.setItem("i18nextLng", "en");
    });

    // Try accessing a protected page
    await page.goto("/dashboard");

    // Should be redirected to login since there's no token
    await page.waitForURL("/login", { timeout: 10000 });

    // Verify we're on the login page — look for the heading text
    await expect(page.locator("h1")).toHaveText("Sign in", { timeout: 10000 });
  });

  test("redirects to login when token is invalid (401)", async ({ page }) => {
    // Set an invalid token and English locale
    await page.goto("/login");
    await page.evaluate(() => {
      localStorage.setItem("hrms.dev.token", "invalid-jwt-token-that-will-be-rejected");
      localStorage.setItem("hrms.dev.tenant", "default");
      localStorage.setItem("i18nextLng", "en");
    });

    // Navigate to dashboard — the app will try to load /authz/me
    // with the invalid token, get 401, and the interceptor redirects to /login
    await page.goto("/dashboard");

    // Wait for the redirect to login (either from RoleShell or axios interceptor)
    await page.waitForURL("/login", { timeout: 15000 });

    // Verify we're on the login page
    await expect(page.locator("h1")).toHaveText("Sign in", { timeout: 10000 });
  });
});
