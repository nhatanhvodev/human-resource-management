# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: admin-navigation.spec.ts >> shows and navigates between admin modules
- Location: e2e\admin-navigation.spec.ts:5:1

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByRole('menuitem', { name: 'Recruitment' })
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 5000ms
  - waiting for getByRole('menuitem', { name: 'Recruitment' })

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
  5  | test("shows and navigates between admin modules", async ({ page }) => {
  6  |   await loginAs(page, { username: "admin", password: "admin123" });
  7  | 
> 8  |   await expect(page.getByRole("menuitem", { name: "Recruitment" })).toBeVisible();
     |                                                                     ^ Error: expect(locator).toBeVisible() failed
  9  |   await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  10 |   await expect(page.getByRole("menuitem", { name: "Payroll" })).toBeVisible();
  11 | 
  12 |   await page.getByRole("menuitem", { name: "Recruitment" }).click();
  13 |   await expect(page.getByRole("heading", { name: "Recruitment" })).toBeVisible();
  14 | 
  15 |   await page.getByRole("menuitem", { name: "Leave" }).click();
  16 |   await expect(page.getByRole("heading", { name: "Leave" })).toBeVisible();
  17 | 
  18 |   await page.getByRole("menuitem", { name: "Payroll" }).click();
  19 |   await expect(page.getByRole("heading", { name: "Payroll" })).toBeVisible();
  20 | });
  21 | 
  22 | 
```