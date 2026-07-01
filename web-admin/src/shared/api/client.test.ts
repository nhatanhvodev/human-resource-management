import { describe, expect, it } from "vitest";

import { buildHeaders } from "./client";

describe("buildHeaders", () => {
  it("injects Authorization and X-Tenant-Id headers from dev settings", () => {
    const headers = buildHeaders({ token: "abc", tenantId: "tenant-a" });

    expect(headers.Authorization).toBe("Bearer abc");
    expect(headers["X-Tenant-Id"]).toBe("tenant-a");
  });

  it("does not include Authorization when token is empty", () => {
    const headers = buildHeaders({ token: "", tenantId: "tenant-a" });

    expect(headers.Authorization).toBeUndefined();
    expect(headers["X-Tenant-Id"]).toBe("tenant-a");
  });

  it("can build public login headers from the tenant submitted in the form", () => {
    const headers = buildHeaders(
      { token: "stale-token", tenantId: "stale-tenant" },
      { includeAuthorization: false, tenantId: "default" }
    );

    expect(headers.Authorization).toBeUndefined();
    expect(headers["X-Tenant-Id"]).toBe("default");
  });
});
