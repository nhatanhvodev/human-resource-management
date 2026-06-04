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
      body: JSON.stringify({
        items: [{ id: "11111111-1111-1111-1111-111111111111", code: "ENG-E2E", name: "Phòng kỹ thuật E2E" }],
        page: 0,
        size: 10,
        totalItems: 1,
        totalPages: 1
      })
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

test("luồng quản trị cơ bản", async ({ page }) => {
  await page.goto("/settings");
  await page.getByLabel("Token truy cập").fill("e2e-token");
  await page.getByLabel("Mã đơn vị").fill("tenant-e2e");
  await page.getByRole("button", { name: "Lưu" }).click();

  await page.goto("/departments");
  await page.getByRole("button", { name: "Thêm phòng ban" }).click();
  await page.getByLabel("Mã phòng ban").fill("ENG-E2E");
  await page.getByLabel("Tên phòng ban").fill("Phòng kỹ thuật E2E");
  await page.getByRole("button", { name: "Tạo mới" }).click();

  await page.goto("/employees");
  await page.getByRole("button", { name: "Thêm nhân viên" }).click();
  await page.getByLabel("Mã nhân viên").fill("E2E-001");
  await page.getByLabel("Họ và tên").fill("Nhân viên E2E");
  await page.getByLabel("Phòng ban").click();
  await page.getByText("ENG-E2E - Phòng kỹ thuật E2E").click();
  await page.getByLabel("Ngày vào làm").fill("2026-05-30");
  await page.getByRole("button", { name: "Lưu nhân viên" }).click();

  await page.goto("/payroll");
  await page.getByRole("button", { name: "Tạo kỳ lương" }).click();
  await page.getByLabel("Từ ngày").fill("2026-06-01");
  await page.getByLabel("Đến ngày").fill("2026-06-30");
  await page.getByRole("button", { name: "Tạo kỳ", exact: true }).click();

  await expect(page.getByRole("heading", { name: "Bảng lương" })).toBeVisible();
});
