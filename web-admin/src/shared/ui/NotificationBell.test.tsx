import { render } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { NotificationBell } from "./NotificationBell";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn(),
  getEmployeeId: vi.fn()
}));

vi.mock("../api/client", () => ({
  apiClient: {
    get: mocks.apiGet
  }
}));

vi.mock("../auth/jwt", () => ({
  getEmployeeId: mocks.getEmployeeId
}));

describe("NotificationBell", () => {
  it("does not call notification APIs without a valid employee id", () => {
    mocks.apiGet.mockReset();
    mocks.getEmployeeId.mockReturnValue("");

    render(<NotificationBell />);

    expect(mocks.apiGet).not.toHaveBeenCalled();
  });
});
