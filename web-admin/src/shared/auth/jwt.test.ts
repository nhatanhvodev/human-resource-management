import { describe, expect, it } from "vitest";

import { getAuthorities, getEmployeeId, hasAuthority, LOCAL_DEV_TOKEN } from "./jwt";

function unsignedJwt(payload: object) {
  const encode = (value: object) => btoa(JSON.stringify(value)).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
  return `${encode({ alg: "none" })}.${encode(payload)}.`;
}

describe("jwt auth helpers", () => {
  it("grants full admin authorities for the local dev token", () => {
    localStorage.setItem("hrms.dev.token", LOCAL_DEV_TOKEN);

    expect(hasAuthority("audit:read", LOCAL_DEV_TOKEN)).toBe(true);
    expect(getEmployeeId()).toBe("");
  });

  it("reads authorities from JWT claims", () => {
    const token = unsignedJwt({
      sub: "emp-1",
      employee_id: "emp-1",
      authorities: ["dashboard:read", "employee:read"]
    });

    expect(getAuthorities(token)).toEqual(["dashboard:read", "employee:read"]);
    expect(hasAuthority("employee:read", token)).toBe(true);
    expect(hasAuthority("audit:read", token)).toBe(false);
  });
});
