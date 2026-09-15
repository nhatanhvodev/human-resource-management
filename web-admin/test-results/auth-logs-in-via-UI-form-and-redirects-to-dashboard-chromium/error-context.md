# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: auth.spec.ts >> logs in via UI form and redirects to dashboard
- Location: e2e\auth.spec.ts:3:1

# Error details

```
Test timeout of 30000ms exceeded.
```

```
Error: page.waitForURL: Test timeout of 30000ms exceeded.
=========================== logs ===========================
waiting for navigation to "/dashboard" until "load"
============================================================
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
      - alert [ref=e15]:
        - img "close-circle" [ref=e16]:
          - img [ref=e17]
        - generic [ref=e20]: Invalid username or password.
      - generic [ref=e22]:
        - generic "Tenant ID" [ref=e24]: "* Tenant ID"
        - textbox [ref=e28]: default
      - generic [ref=e30]:
        - generic "Username" [ref=e32]: "* Username"
        - generic [ref=e36]:
          - img "user" [ref=e38]:
            - img [ref=e39]
          - textbox [ref=e41]: admin
      - generic [ref=e43]:
        - generic "Password" [ref=e45]: "* Password"
        - generic [ref=e49]:
          - img "lock" [ref=e51]:
            - img [ref=e52]
          - textbox [ref=e54]: admin123
          - img "eye-invisible" [ref=e56] [cursor=pointer]:
            - img [ref=e57]
      - button "login Sign in" [active] [ref=e60] [cursor=pointer]:
        - img "login" [ref=e62]:
          - img [ref=e63]
        - generic [ref=e65]: Sign in
```

# Test source

```ts
  1  | import { expect, test } from "playwright/test";
  2  | 
  3  | test("logs in via UI form and redirects to dashboard", async ({ page }) => {
  4  |   await page.goto("/login");
  5  | 
  6  |   // Set English locale so we can use English text for assertions
  7  |   await page.evaluate(() => {
  8  |     localStorage.setItem("i18nextLng", "en");
  9  |   });
  10 |   await page.reload();
  11 | 
  12 |   // The form has initial values { username: "admin", password: "admin123" }
  13 |   // Use CSS selectors to target Ant Design form inputs reliably
  14 |   const usernameInput = page.locator("#username");
  15 |   const passwordInput = page.locator("#password");
  16 | 
  17 |   await usernameInput.clear();
  18 |   await usernameInput.fill("admin");
  19 |   await passwordInput.clear();
  20 |   await passwordInput.fill("admin123");
  21 | 
  22 |   // Submit the login form
  23 |   await page.getByRole("button", { name: "Sign in" }).click();
  24 | 
  25 |   // Wait for successful login redirect to admin dashboard
> 26 |   await page.waitForURL("/dashboard", { timeout: 15000 });
     |              ^ Error: page.waitForURL: Test timeout of 30000ms exceeded.
  27 | 
  28 |   // Assert key admin navigation items are visible
  29 |   await expect(page.getByRole("menuitem", { name: "Recruitment" })).toBeVisible();
  30 |   await expect(page.getByRole("menuitem", { name: "Leave" })).toBeVisible();
  31 |   await expect(page.getByRole("menuitem", { name: "Payroll" })).toBeVisible();
  32 | });
  33 | 
  34 | test("shows error for invalid credentials", async ({ page }) => {
  35 |   await page.goto("/login");
  36 | 
  37 |   // Set English locale so we can use English text for assertions
  38 |   await page.evaluate(() => {
  39 |     localStorage.setItem("i18nextLng", "en");
  40 |   });
  41 |   await page.reload();
  42 | 
  43 |   // Fill wrong credentials using CSS selectors
  44 |   const usernameInput = page.locator("#username");
  45 |   const passwordInput = page.locator("#password");
  46 | 
  47 |   await usernameInput.clear();
  48 |   await usernameInput.fill("admin");
  49 |   await passwordInput.clear();
  50 |   await passwordInput.fill("wrong-password-123");
  51 | 
  52 |   // Submit the login form
  53 |   await page.getByRole("button", { name: "Sign in" }).click();
  54 | 
  55 |   // Assert error alert is visible
  56 |   await expect(page.locator(".login-page__alert")).toBeVisible({ timeout: 10000 });
  57 | 
  58 |   // Assert still on login page (not redirected)
  59 |   await expect(page).toHaveURL("/login");
  60 | });
  61 | 
```