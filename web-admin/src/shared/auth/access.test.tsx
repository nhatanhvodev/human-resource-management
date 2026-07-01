import { render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AccessProvider, useAccess } from "./access";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn()
}));

vi.mock("../api/client", () => ({
  apiClient: {
    get: mocks.apiGet
  }
}));

function Probe() {
  const access = useAccess();
  if (access.loading) {
    return <span>loading</span>;
  }
  return <span>{access.hasAuthority("employee:read") ? "allowed" : "denied"}</span>;
}

describe("AccessProvider", () => {
  beforeEach(() => {
    localStorage.clear();
    mocks.apiGet.mockReset();
    mocks.apiGet.mockResolvedValue({
      data: {
        userId: "user-1",
        username: "nv000002",
        displayName: "Employee",
        employeeId: "emp-2",
        roles: ["EMPLOYEE"],
        authorities: ["self:access"]
      }
    });
  });

  it("uses server authorities instead of token-derived authorities", async () => {
    localStorage.setItem("hrms.dev.token", "token-with-employee-read-claim");

    render(
      <AccessProvider>
        <Probe />
      </AccessProvider>
    );

    expect(await screen.findByText("denied")).toBeInTheDocument();
    expect(mocks.apiGet).toHaveBeenCalledWith("/authz/me");
  });
});
