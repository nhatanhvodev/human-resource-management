# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: admin-smoke.spec.ts >> runs a basic admin create-and-navigate flow
- Location: e2e\admin-smoke.spec.ts:5:1

# Error details

```
Test timeout of 30000ms exceeded.
```

```
Error: locator.click: Test timeout of 30000ms exceeded.
Call log:
  - waiting for getByRole('button', { name: 'Add department' })

```

# Page snapshot

```yaml
- generic [ref=e3]:
  - generic [ref=e5] [cursor=pointer]:
    - generic [ref=e7]:
      - combobox [ref=e9]
      - generic "EN" [ref=e10]
    - generic:
      - img:
        - img
  - main [ref=e11]:
    - generic [ref=e12]:
      - text: HRMS
      - heading "Sign in" [level=1] [ref=e13]
    - generic [ref=e14]:
      - generic [ref=e16]:
        - generic "Tenant ID" [ref=e18]: "* Tenant ID"
        - textbox [ref=e22]: default
      - generic [ref=e24]:
        - generic "Username" [ref=e26]: "* Username"
        - generic [ref=e30]:
          - img "user" [ref=e32]:
            - img [ref=e33]
          - textbox [ref=e35]: admin
      - generic [ref=e37]:
        - generic "Password" [ref=e39]: "* Password"
        - generic [ref=e43]:
          - img "lock" [ref=e45]:
            - img [ref=e46]
          - textbox [ref=e48]: admin123
          - img "eye-invisible" [ref=e50] [cursor=pointer]:
            - img [ref=e51]
      - button "login Sign in" [ref=e54] [cursor=pointer]:
        - img "login" [ref=e56]:
          - img [ref=e57]
        - generic [ref=e59]: Sign in
```

# Test source

```ts
  1  | import { expect, test } from "playwright/test";
  2  | 
  3  | import { loginAs } from "./helpers";
  4  | 
  5  | test("runs a basic admin create-and-navigate flow", async ({ page }) => {
  6  |   await loginAs(page, { username: "admin", password: "admin123" }, "/departments");
  7  | 
  8  |   const suffix = Date.now().toString().slice(-6);
  9  |   const departmentCode = `E2E-${suffix}`;
  10 |   const departmentName = `E2E Operations ${suffix}`;
  11 |   const employeeNo = `NV-E2E-${suffix}`;
  12 | 
> 13 |   await page.getByRole("button", { name: "Add department" }).click();
     |                                                              ^ Error: locator.click: Test timeout of 30000ms exceeded.
  14 |   await page.getByLabel("Department code").fill(departmentCode);
  15 |   await page.getByLabel("Department name").fill(departmentName);
  16 |   await page.getByRole("button", { name: "Create new" }).click();
  17 |   await expect(page.getByRole("button", { name: "Add department" })).toBeVisible();
  18 | 
  19 |   await page.goto("/employees");
  20 |   await page.getByRole("button", { name: "Add employee" }).click();
  21 |   await page.getByLabel("Employee ID").fill(employeeNo);
  22 |   await page.getByLabel("Full name").fill(`E2E Employee ${suffix}`);
  23 |   await page.getByLabel("Department").click();
  24 |   await page.locator(".ant-select-item-option").first().click();
  25 |   await page.getByLabel("Hire date").fill("2026-06-01");
  26 |   await page.getByRole("button", { name: "Save employee" }).click();
  27 |   await expect(page.getByRole("button", { name: "Add employee" })).toBeVisible();
  28 | 
  29 |   await page.goto("/payroll");
  30 |   await expect(page.getByRole("heading", { name: "Payroll" })).toBeVisible();
  31 | });
  32 | 
```