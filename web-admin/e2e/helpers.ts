import type { Page } from "playwright/test";

type Account = {
  username: string;
  password: string;
};

/**
 * P3: auth is cookie-based now (httpOnly refresh + in-memory access token).
 * Logging in via page.request stores the refresh cookie in the browser
 * context; the app silently refreshes on boot — no localStorage writes.
 */
export async function loginAs(page: Page, account: Account, targetPath = "/dashboard") {
  const response = await page.request.post("/api/v1/auth/login", {
    headers: { "X-Tenant-Id": "default" },
    data: { ...account, tenantId: "default" }
  });

  if (!response.ok()) {
    throw new Error(`Login failed for ${account.username}: ${response.status()}`);
  }

  await page.goto("/login", { waitUntil: "domcontentloaded" });
  await page.evaluate(() => {
    localStorage.setItem("i18nextLng", "en");
  });
  await page.goto(targetPath);
}
