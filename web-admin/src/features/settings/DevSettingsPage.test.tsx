import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import DevSettingsPage from "./DevSettingsPage";

vi.mock("../../shared/auth/access", () => ({
  useAccess: () => ({
    access: { userId: "test", username: "admin", displayName: "Admin", employeeId: "test", roles: ["ADMIN"], authorities: ["authz:update"] },
    authorities: ["authz:update"],
    roles: ["ADMIN"],
    loading: false,
    error: false,
    hasAuthority: (a: string) => a === "authz:update",
    reload: vi.fn()
  })
}));

describe("DevSettingsPage", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it("lưu token và tenant khi bấm lưu thiết lập dev", () => {
    render(<DevSettingsPage />);

    fireEvent.change(screen.getByLabelText(/Token truy cập/i), {
      target: { value: "test-token" }
    });
    fireEvent.change(screen.getByLabelText(/Mã đơn vị/i), {
      target: { value: "tenant-a" }
    });
    fireEvent.click(screen.getByRole("button", { name: /Lưu/i }));

    expect(localStorage.getItem("hrms.dev.token")).toBe("test-token");
    expect(localStorage.getItem("hrms.dev.tenant")).toBe("tenant-a");
  });
});
