import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import EmployeesPage from "./EmployeesPage";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn(),
  apiPatch: vi.fn(),
  apiPut: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet,
    patch: mocks.apiPatch,
    post: vi.fn(),
    put: mocks.apiPut
  }
}));

describe("EmployeesPage", () => {
  beforeEach(() => {
    mocks.apiPatch.mockReset();
    mocks.apiPatch.mockResolvedValue({ data: {} });
    mocks.apiPut.mockReset();
    mocks.apiPut.mockResolvedValue({ data: {} });
    mocks.apiGet.mockReset();
    mocks.apiGet.mockImplementation((path: string) => {
      if (path === "/departments") {
        return Promise.resolve({
          data: {
            items: [{ id: "dept-1", code: "ENG", name: "Kỹ thuật" }],
            page: 0,
            size: 100,
            totalItems: 1,
            totalPages: 1
          }
        });
      }

      return Promise.resolve({
        data: {
          items: [
            {
              id: "emp-1",
              employeeNo: "E001",
              fullName: "Nguyễn Văn A",
              departmentId: "dept-1",
              employmentStatus: "ACTIVE",
              hireDate: "2026-05-30"
            }
          ],
          page: 0,
          size: 10,
          totalItems: 1,
          totalPages: 1
        }
      });
    });
  });

  it("lọc nhân viên theo trạng thái", async () => {
    render(<EmployeesPage />);

    fireEvent.click(screen.getByText("Đang làm việc"));

    expect(await screen.findByText("Nguyễn Văn A")).toBeInTheDocument();
    expect(mocks.apiGet).toHaveBeenLastCalledWith("/employees", {
      params: expect.objectContaining({ status: "ACTIVE" })
    });
  });

  it("mở chi tiết nhân viên bằng dữ liệu API đang có", async () => {
    render(<EmployeesPage />);

    expect(await screen.findByText("Nguyễn Văn A")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Chi tiết/i }));

    expect(screen.getByText("Chi tiết nhân viên")).toBeInTheDocument();
    expect(screen.getAllByText("E001").length).toBeGreaterThanOrEqual(2);
    expect(screen.getAllByText("ENG - Kỹ thuật").length).toBeGreaterThanOrEqual(2);
  });

  it("gọi API cập nhật và đổi trạng thái nhân viên", async () => {
    render(<EmployeesPage />);

    expect(await screen.findByText("Nguyễn Văn A")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /^Sửa$/i }));
    fireEvent.change(screen.getByLabelText(/Họ và tên/i), {
      target: { value: "Nguyễn Văn B" }
    });
    fireEvent.click(screen.getByRole("button", { name: /Lưu thay đổi/i }));

    await waitFor(() => {
      expect(mocks.apiPut).toHaveBeenCalledWith("/employees/emp-1/profile", {
        fullName: "Nguyễn Văn B",
        departmentId: "dept-1",
        hireDate: "2026-05-30"
      });
    });

    fireEvent.click(screen.getByRole("button", { name: /Ngừng hoạt động/i }));

    await waitFor(() => {
      expect(mocks.apiPatch).toHaveBeenCalledWith("/employees/emp-1/status", {
        employmentStatus: "INACTIVE"
      });
    });
  });
});
