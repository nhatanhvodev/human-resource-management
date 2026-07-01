import { expect, test } from "playwright/test";

test("logs in via UI form and redirects to dashboard", async ({ page }) => {
  await page.goto("/login");

  // Set English locale so we can use English text for assertions
  await page.evaluate(() => {
    localStorage.setItem("i18nextLng", "en");
  });
  await page.reload();

  // The form has initial values { username: "admin", password: "admin123" }
  // Use CSS selectors to target Ant Design form inputs reliably
  const usernameInput = page.locator("#username");
  const passwordInput = page.locator("#password");

  await usernameInput.clear();
  await usernameInput.fill("admin");
  await passwordInput.clear();
  await passwordInput.fill("admin123");

  // Submit the login form
  await page.getByRole("button", { name: "Sign in" }).click();

  // Wait for successful login redirect to admin dashboard
  await page.waitForURL("/dashboard", { timeout: 15000 });

  // Assert key admin navigation items are visible
  await expect(page.getByRole("menuitem", { name: "Recruitment" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Payroll" })).toBeVisible();
});

test("shows error for invalid credentials", async ({ page }) => {
  await page.goto("/login");

  // Set English locale so we can use English text for assertions
  await page.evaluate(() => {
    localStorage.setItem("i18nextLng", "en");
  });
  await page.reload();

  // Fill wrong credentials using CSS selectors
  const usernameInput = page.locator("#username");
  const passwordInput = page.locator("#password");

  await usernameInput.clear();
  await usernameInput.fill("admin");
  await passwordInput.clear();
  await passwordInput.fill("wrong-password-123");

  // Submit the login form
  await page.getByRole("button", { name: "Sign in" }).click();

  // Assert error alert is visible
  await expect(page.locator(".login-page__alert")).toBeVisible({ timeout: 10000 });

  // Assert still on login page (not redirected)
  await expect(page).toHaveURL("/login");
});
