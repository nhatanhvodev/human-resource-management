import { expect, test } from "playwright/test";

import { loginAs } from "./helpers";

test("shows and navigates between admin modules", async ({ page }) => {
  await loginAs(page, { username: "admin", password: "admin123" });

  await expect(page.getByRole("menuitem", { name: "Recruitment" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Payroll" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Recruitment" }).click();
  await expect(page.getByRole("heading", { name: "Recruitment" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Leave" }).click();
  await expect(page.getByRole("heading", { name: "Leave" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Payroll" }).click();
  await expect(page.getByRole("heading", { name: "Payroll" })).toBeVisible();
});

