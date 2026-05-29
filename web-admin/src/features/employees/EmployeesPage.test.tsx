import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import EmployeesPage from "./EmployeesPage";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet,
    patch: vi.fn(),
    post: vi.fn(),
    put: vi.fn()
  }
}));

describe("EmployeesPage", () => {
  beforeEach(() => {
    mocks.apiGet.mockResolvedValue({
      data: {
        items: [
          {
            id: "emp-1",
            employeeCode: "E001",
            fullName: "Nguyen Van A",
            departmentName: "Engineering",
            employmentStatus: "ACTIVE"
          }
        ],
        page: 0,
        size: 10,
        totalItems: 1,
        totalPages: 1
      }
    });
  });

  it("filters employees by status", async () => {
    render(<EmployeesPage />);

    fireEvent.click(screen.getByText("ACTIVE"));

    expect(await screen.findByText("Nguyen Van A")).toBeInTheDocument();
    expect(mocks.apiGet).toHaveBeenLastCalledWith("/employees", {
      params: expect.objectContaining({ status: "ACTIVE" })
    });
  });
});
