import { expect, test } from "playwright/test";

test.beforeEach(async ({ page }) => {
  await page.route("**/api/v1/dashboard/summary", async (route) => {
    await route.fulfill({
      contentType: "application/json",
      body: JSON.stringify({ employees: 0, departments: 0, openPayrollPeriods: 0, pendingLeaves: 0 })
    });
  });
  await page.route("**/api/v1/dashboard/activities", async (route) => {
    await route.fulfill({ contentType: "application/json", body: JSON.stringify([]) });
  });
  await page.route("**/api/v1/departments**", async (route) => {
    await route.fulfill({
      contentType: "application/json",
      body: JSON.stringify({ items: [], page: 0, size: 10, totalItems: 0, totalPages: 0 })
    });
  });
  await page.route("**/api/v1/employees**", async (route) => {
    await route.fulfill({
      contentType: "application/json",
      body: JSON.stringify({ items: [], page: 0, size: 10, totalItems: 0, totalPages: 0 })
    });
  });
  await page.route("**/api/v1/payroll-periods**", async (route) => {
    await route.fulfill({
      contentType: "application/json",
      body: JSON.stringify({ items: [], page: 0, size: 10, totalItems: 0, totalPages: 0 })
    });
  });
});

test("admin happy path", async ({ page }) => {
  await page.goto("/settings");
  await page.getByLabel("Token").fill("e2e-token");
  await page.getByLabel("Tenant").fill("tenant-e2e");
  await page.getByRole("button", { name: "Luu" }).click();

  await page.goto("/departments");
  await page.getByRole("button", { name: "Them phong ban" }).click();
  await page.getByLabel("Ma phong ban").fill("ENG-E2E");
  await page.getByLabel("Ten phong ban").fill("Engineering E2E");
  await page.getByRole("button", { name: "Tao moi" }).click();

  await page.goto("/employees");
  await page.getByRole("button", { name: "Them nhan vien" }).click();
  await page.getByLabel("Ma nhan vien").fill("E2E-001");
  await page.getByLabel("Ho va ten").fill("Test Employee");
  await page.getByRole("button", { name: "Luu nhan vien" }).click();

  await page.goto("/payroll");
  await page.getByRole("button", { name: "Create payroll period" }).click();
  await page.getByLabel("Tu ngay").fill("2026-06-01");
  await page.getByLabel("Den ngay").fill("2026-06-30");
  await page.getByRole("button", { name: "Tao ky" }).click();

  await expect(page.getByRole("heading", { name: "Payroll" })).toBeVisible();
});
