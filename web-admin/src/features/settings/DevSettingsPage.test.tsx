import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it } from "vitest";

import DevSettingsPage from "./DevSettingsPage";

describe("DevSettingsPage", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it("persists token and tenant when saving dev settings", () => {
    render(<DevSettingsPage />);

    fireEvent.change(screen.getByLabelText(/Token/i), {
      target: { value: "test-token" }
    });
    fireEvent.change(screen.getByLabelText(/Tenant/i), {
      target: { value: "tenant-a" }
    });
    fireEvent.click(screen.getByRole("button", { name: /Luu/i }));

    expect(localStorage.getItem("hrms.dev.token")).toBe("test-token");
    expect(localStorage.getItem("hrms.dev.tenant")).toBe("tenant-a");
  });
});
