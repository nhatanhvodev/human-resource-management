import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import DepartmentsPage from "./DepartmentsPage";

const mocks = vi.hoisted(() => ({
  apiDelete: vi.fn(),
  apiGet: vi.fn(),
  apiPut: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet,
    post: vi.fn(),
    put: mocks.apiPut,
    delete: mocks.apiDelete
  }
}));

describe("DepartmentsPage", () => {
  beforeEach(() => {
    mocks.apiDelete.mockReset();
    mocks.apiGet.mockResolvedValue({
      data: {
        items: [{ id: "dept-1", code: "ENG", name: "Kỹ thuật" }],
        page: 0,
        size: 10,
        totalItems: 1,
        totalPages: 1
      }
    });
    mocks.apiPut.mockReset();
    mocks.apiPut.mockResolvedValue({ data: { id: "dept-1", code: "ENG", name: "Kỹ thuật nền tảng" } });
  });

  it("hiển thị phòng ban từ API và mở form tạo mới", async () => {
    render(<DepartmentsPage />);

    expect(await screen.findByText("Kỹ thuật")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Thêm phòng ban/i }));

    expect(screen.getByLabelText(/Mã phòng ban/i)).toBeInTheDocument();
  });

  it("gọi API cập nhật khi lưu form sửa phòng ban", async () => {
    render(<DepartmentsPage />);

    expect(await screen.findByText("Kỹ thuật")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Sửa/i }));
    fireEvent.change(screen.getByLabelText(/Tên phòng ban/i), {
      target: { value: "Kỹ thuật nền tảng" }
    });
    fireEvent.click(screen.getByRole("button", { name: /Lưu thay đổi/i }));

    await waitFor(() => {
      expect(mocks.apiPut).toHaveBeenCalledWith("/departments/dept-1", {
        code: "ENG",
        name: "Kỹ thuật nền tảng"
      });
    });
  });

  it("gọi API xóa sau khi xác nhận xóa phòng ban", async () => {
    mocks.apiDelete.mockResolvedValue({ data: undefined });
    render(<DepartmentsPage />);

    expect(await screen.findByText("Kỹ thuật")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Xóa/i }));
    fireEvent.click(await screen.findByRole("button", { name: /Xóa phòng ban/i }));

    await waitFor(() => {
      expect(mocks.apiDelete).toHaveBeenCalledWith("/departments/dept-1");
    });
  });
});
