# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: manager-navigation.spec.ts >> shows manager-specific navigation and can navigate between pages
- Location: e2e\manager-navigation.spec.ts:5:1

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByRole('heading', { name: 'Dashboard' })
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 5000ms
  - waiting for getByRole('heading', { name: 'Dashboard' })

```

```yaml
- combobox
- text: EN
- main:
  - text: HRMS
  - heading "Sign in" [level=1]
  - text: "* Tenant ID"
  - textbox: default
  - text: "* Username"
  - img "user"
  - textbox: admin
  - text: "* Password"
  - img "lock"
  - textbox: admin123
  - img "eye-invisible"
  - button "login Sign in":
    - img "login"
    - text: Sign in
```

# Test source

```ts
  1  | import { expect, test } from "playwright/test";
  2  | 
  3  | import { loginAs } from "./helpers";
  4  | 
  5  | test("shows manager-specific navigation and can navigate between pages", async ({
  6  |   page
  7  | }) => {
  8  |   await loginAs(
  9  |     page,
  10 |     { username: "line-manager", password: "manager123" },
  11 |     "/manager/dashboard"
  12 |   );
  13 | 
  14 |   // Manager shell should be visible
> 15 |   await expect(page.getByRole("heading", { name: "Dashboard" })).toBeVisible();
     |                                                                  ^ Error: expect(locator).toBeVisible() failed
  16 | 
  17 |   // Assert manager menu items are visible
  18 |   await expect(page.getByRole("menuitem", { name: "Dashboard" })).toBeVisible();
  19 |   await expect(page.getByRole("menuitem", { name: "Employees" })).toBeVisible();
  20 |   await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  21 |   await expect(page.getByRole("menuitem", { name: "Attendance" })).toBeVisible();
  22 |   await expect(page.getByRole("menuitem", { name: "Documents" })).toBeVisible();
  23 |   await expect(page.getByRole("menuitem", { name: "Training" })).toBeVisible();
  24 |   await expect(page.getByRole("menuitem", { name: "Announcements" })).toBeVisible();
  25 | 
  26 |   // Assert admin-only items are NOT present in manager shell
  27 |   const adminOnlyItems = [
  28 |     "Recruitment",
  29 |     "Payroll",
  30 |     "Performance",
  31 |     "Departments",
  32 |     "Onboarding",
  33 |     "Assets",
  34 |     "Audit Log",
  35 |     "Authorization",
  36 |     "Settings"
  37 |   ];
  38 |   for (const item of adminOnlyItems) {
  39 |     await expect(page.getByRole("menuitem", { name: item })).not.toBeVisible();
  40 |   }
  41 | 
  42 |   // Navigate between manager pages
  43 |   await page.getByRole("menuitem", { name: "Employees" }).click();
  44 |   await expect(page.getByRole("heading", { name: "Employees" })).toBeVisible();
  45 | 
  46 |   await page.getByRole("menuitem", { name: "Leave" }).click();
  47 |   await expect(page.getByRole("heading", { name: "Leave" })).toBeVisible();
  48 | 
  49 |   await page.getByRole("menuitem", { name: "Attendance" }).click();
  50 |   await expect(page.getByRole("heading", { name: "Attendance" })).toBeVisible();
  51 | 
  52 |   await page.getByRole("menuitem", { name: "Training" }).click();
  53 |   await expect(page.getByRole("heading", { name: "Training" })).toBeVisible();
  54 | });
  55 | 
```