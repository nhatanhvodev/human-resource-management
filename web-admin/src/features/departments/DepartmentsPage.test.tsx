import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import DepartmentsPage from "./DepartmentsPage";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet,
    post: vi.fn(),
    put: vi.fn(),
    delete: vi.fn()
  }
}));

describe("DepartmentsPage", () => {
  beforeEach(() => {
    mocks.apiGet.mockResolvedValue({
      data: {
        items: [{ id: "dept-1", code: "ENG", name: "Engineering" }],
        page: 0,
        size: 10,
        totalItems: 1,
        totalPages: 1
      }
    });
  });

  it("shows departments from API and opens create drawer", async () => {
    render(<DepartmentsPage />);

    expect(await screen.findByText("Engineering")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Them phong ban/i }));

    expect(screen.getByLabelText(/Ma phong ban/i)).toBeInTheDocument();
  });
});
