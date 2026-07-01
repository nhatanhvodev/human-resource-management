import { expect, test } from "playwright/test";

import { loginAs } from "./helpers";

test("shows manager-specific navigation and can navigate between pages", async ({
  page
}) => {
  await loginAs(
    page,
    { username: "line-manager", password: "manager123" },
    "/manager/dashboard"
  );

  // Manager shell should be visible
  await expect(page.getByRole("heading", { name: "Dashboard" })).toBeVisible();

  // Assert manager menu items are visible
  await expect(page.getByRole("menuitem", { name: "Dashboard" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Employees" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Attendance" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Documents" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Training" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Announcements" })).toBeVisible();

  // Assert admin-only items are NOT present in manager shell
  const adminOnlyItems = [
    "Recruitment",
    "Payroll",
    "Performance",
    "Departments",
    "Onboarding",
    "Assets",
    "Audit Log",
    "Authorization",
    "Settings"
  ];
  for (const item of adminOnlyItems) {
    await expect(page.getByRole("menuitem", { name: item })).not.toBeVisible();
  }

  // Navigate between manager pages
  await page.getByRole("menuitem", { name: "Employees" }).click();
  await expect(page.getByRole("heading", { name: "Employees" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Leave" }).click();
  await expect(page.getByRole("heading", { name: "Leave" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Attendance" }).click();
  await expect(page.getByRole("heading", { name: "Attendance" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Training" }).click();
  await expect(page.getByRole("heading", { name: "Training" })).toBeVisible();
});
