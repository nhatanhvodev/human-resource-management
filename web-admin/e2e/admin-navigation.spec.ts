import { expect, test } from "playwright/test";

test("hiển thị và điều hướng giữa các phân hệ quản trị", async ({ page }) => {
  await page.goto("/");

  await expect(page.getByRole("menuitem", { name: "Tuyển dụng" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Nghỉ phép" })).toBeVisible();
  await expect(page.getByRole("menuitem", { name: "Bảng lương" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Tuyển dụng" }).click();
  await expect(page.getByRole("heading", { name: "Tuyển dụng" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Nghỉ phép" }).click();
  await expect(page.getByRole("heading", { name: "Nghỉ phép" })).toBeVisible();

  await page.getByRole("menuitem", { name: "Bảng lương" }).click();
  await expect(page.getByRole("heading", { name: "Bảng lương" })).toBeVisible();
});
