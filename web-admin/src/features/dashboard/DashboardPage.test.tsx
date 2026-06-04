import { render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import DashboardPage from "./DashboardPage";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet
  }
}));

describe("DashboardPage", () => {
  beforeEach(() => {
    mocks.apiGet.mockReset();
  });

  it("renders a focused error state when the backend is offline", async () => {
    mocks.apiGet.mockRejectedValue(new Error("backend offline"));

    render(<DashboardPage />);

    expect(await screen.findByText("Không tải được dữ liệu tổng quan")).toBeInTheDocument();
    expect(screen.getByText("Kiểm tra token, tenant và kết nối backend rồi tải lại trang.")).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.queryByText("No data")).not.toBeInTheDocument();
    });
  });

  it("renders Vietnamese empty copy when there are no activities", async () => {
    mocks.apiGet.mockImplementation((path: string) => {
      if (path === "/dashboard/summary") {
        return Promise.resolve({
          data: {
            totalEmployees: 0,
            activeEmployees: 0,
            departments: 0,
            openPayrollPeriods: 0,
            pendingLeaves: 0
          }
        });
      }

      return Promise.resolve({ data: [] });
    });

    render(<DashboardPage />);

    expect(await screen.findByText("Không có hoạt động gần đây")).toBeInTheDocument();
    expect(screen.getByText("Các sự kiện vận hành mới sẽ xuất hiện tại đây.")).toBeInTheDocument();
  });
});
