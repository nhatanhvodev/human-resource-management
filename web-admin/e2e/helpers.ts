import type { Page } from "playwright/test";

type Account = {
  username: string;
  password: string;
};

export async function loginAs(page: Page, account: Account, targetPath = "/dashboard") {
  const response = await page.request.post("/api/v1/auth/login", {
    headers: { "X-Tenant-Id": "default" },
    data: { ...account, tenantId: "default" }
  });

  if (!response.ok()) {
    throw new Error(`Login failed for ${account.username}: ${response.status()}`);
  }

  const body = await response.json();
  await page.goto("/login", { waitUntil: "domcontentloaded" });
  await page.evaluate(({ token, tenantId }) => {
    localStorage.setItem("hrms.dev.token", token);
    localStorage.setItem("hrms.dev.tenant", tenantId);
    localStorage.setItem("i18nextLng", "en");
  }, body);
  await page.goto(targetPath);
}

