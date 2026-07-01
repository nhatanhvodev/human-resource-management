import { expect, test } from "playwright/test";

import { loginAs } from "./helpers";

test("runs a basic admin create-and-navigate flow", async ({ page }) => {
  await loginAs(page, { username: "admin", password: "admin123" }, "/departments");

  const suffix = Date.now().toString().slice(-6);
  const departmentCode = `E2E-${suffix}`;
  const departmentName = `E2E Operations ${suffix}`;
  const employeeNo = `NV-E2E-${suffix}`;

  await page.getByRole("button", { name: "Add department" }).click();
  await page.getByLabel("Department code").fill(departmentCode);
  await page.getByLabel("Department name").fill(departmentName);
  await page.getByRole("button", { name: "Create new" }).click();
  await expect(page.getByRole("button", { name: "Add department" })).toBeVisible();

  await page.goto("/employees");
  await page.getByRole("button", { name: "Add employee" }).click();
  await page.getByLabel("Employee ID").fill(employeeNo);
  await page.getByLabel("Full name").fill(`E2E Employee ${suffix}`);
  await page.getByLabel("Department").click();
  await page.locator(".ant-select-item-option").first().click();
  await page.getByLabel("Hire date").fill("2026-06-01");
  await page.getByRole("button", { name: "Save employee" }).click();
  await expect(page.getByRole("button", { name: "Add employee" })).toBeVisible();

  await page.goto("/payroll");
  await expect(page.getByRole("heading", { name: "Payroll" })).toBeVisible();
});
