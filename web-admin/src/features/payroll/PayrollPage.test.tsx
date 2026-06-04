import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import PayrollPage from "./PayrollPage";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn(),
  apiPost: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet,
    post: mocks.apiPost
  }
}));

describe("PayrollPage", () => {
  beforeEach(() => {
    mocks.apiGet.mockReset();
    mocks.apiPost.mockReset();
    mocks.apiGet.mockImplementation((path: string) => {
      if (path === "/payroll-periods") {
        return Promise.resolve({
          data: {
            items: [{ id: "period-1", periodFrom: "2024-01-01", periodTo: "2024-01-31", status: "CLOSED" }],
            page: 0,
            size: 10,
            totalItems: 1,
            totalPages: 1
          }
        });
      }

      if (path === "/payroll-runs") {
        return Promise.resolve({
          data: {
            items: [{ id: "run-1", status: "EXECUTED" }],
            page: 0,
            size: 10,
            totalItems: 1,
            totalPages: 1
          }
        });
      }

      if (path === "/payroll-runs/run-1/payslips") {
        return Promise.resolve({
          data: [
            {
              id: "payslip-1",
              payrollRunId: "run-1",
              employeeId: "employee-1",
              basicSalary: 15000000,
              allowance: 2000000,
              deduction: 1000000,
              overtimePay: 500000,
              netPay: 16500000
            }
          ]
        });
      }

      return Promise.reject(new Error(`Unexpected path ${path}`));
    });
  });

  it("renders seeded periods and payslips returned as an array", async () => {
    render(<PayrollPage />);

    expect(await screen.findByText("2024-01-01 - 2024-01-31")).toBeInTheDocument();

    fireEvent.click(screen.getAllByRole("button")[1]);
    await waitFor(() => {
      expect(mocks.apiGet).toHaveBeenCalledWith("/payroll-runs", {
        params: { periodId: "period-1", page: 0, size: 10 }
      });
    });

    fireEvent.click(await screen.findByRole("button", { name: /Phi/i }));
    expect(await screen.findByText("16.500.000")).toBeInTheDocument();
  });
});
