import { screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import EmployeesPage from "./EmployeesPage";
import { renderWithProviders } from "../../test/utils";

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

describe("EmployeesPage error state", () => {
  beforeEach(() => {
    mocks.apiGet.mockReset();
    mocks.apiGet.mockImplementation((path: string) => {
      if (path === "/departments" || path === "/positions") {
        return Promise.resolve({
          data: {
            items: [],
            page: 0,
            size: 100,
            totalItems: 0,
            totalPages: 0
          }
        });
      }

      return Promise.reject(new Error("backend offline"));
    });
  });

  it("renders a focused error state without the default table empty copy", async () => {
    renderWithProviders(<EmployeesPage />);

    expect(await screen.findByText("Không tải được danh sách nhân viên")).toBeInTheDocument();
    expect(screen.getByText("Kiểm tra token, tenant và kết nối backend rồi tải lại trang.")).toBeInTheDocument();
    expect(screen.queryByText("No data")).not.toBeInTheDocument();
  });
});
