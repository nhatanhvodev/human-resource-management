import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import RecruitmentPage from "./RecruitmentPage";

const mocks = vi.hoisted(() => ({
  apiGet: vi.fn(),
  apiPost: vi.fn(),
  apiPut: vi.fn()
}));

vi.mock("../../shared/api/client", () => ({
  apiClient: {
    get: mocks.apiGet,
    post: mocks.apiPost,
    put: mocks.apiPut
  }
}));

describe("RecruitmentPage", () => {
  beforeEach(() => {
    mocks.apiPost.mockReset();
    mocks.apiPost.mockResolvedValue({ data: {} });
    mocks.apiPut.mockReset();
    mocks.apiPut.mockResolvedValue({ data: {} });
    mocks.apiGet.mockReset();
    mocks.apiGet.mockImplementation((path: string) => {
      if (path === "/candidates") {
        return Promise.resolve({ data: { items: [{ id: "cand-1", fullName: "Trần Ứng Viên" }] } });
      }
      if (path === "/job-postings") {
        return Promise.resolve({ data: { items: [{ id: "job-1", title: "Kỹ sư phần mềm" }] } });
      }
      if (path === "/applications") {
        return Promise.resolve({ data: { items: [{ id: "app-1", status: "OFFER_ACCEPTED" }] } });
      }
      if (path === "/departments") {
        return Promise.resolve({ data: { items: [{ id: "dept-1", code: "ENG", name: "Kỹ thuật" }] } });
      }
      return Promise.resolve({ data: { items: [] } });
    });
  });

  it("gọi API cập nhật ứng viên khi lưu form sửa", async () => {
    render(<RecruitmentPage />);

    expect(await screen.findByText("Trần Ứng Viên")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Sửa ứng viên/i }));
    fireEvent.change(screen.getByLabelText(/Họ và tên/i), {
      target: { value: "Trần Văn Ứng Viên" }
    });
    fireEvent.click(screen.getByRole("button", { name: /Lưu thay đổi/i }));

    await waitFor(() => {
      expect(mocks.apiPut).toHaveBeenCalledWith("/candidates/cand-1", {
        fullName: "Trần Văn Ứng Viên"
      });
    });
  });

  it("gọi đúng API chuyển hồ sơ thành nhân viên", async () => {
    render(<RecruitmentPage />);

    fireEvent.click(await screen.findByRole("tab", { name: /Hồ sơ ứng tuyển/i }));
    fireEvent.click(await screen.findByRole("button", { name: /Chuyển thành nhân viên/i }));
    fireEvent.change(screen.getByLabelText(/Mã nhân viên/i), {
      target: { value: "E002" }
    });
    fireEvent.mouseDown(screen.getByLabelText(/Phòng ban/i));
    fireEvent.click(await screen.findByText("ENG - Kỹ thuật"));
    fireEvent.click(screen.getByRole("button", { name: /Chuyển đổi/i }));

    await waitFor(() => {
      expect(mocks.apiPost).toHaveBeenCalledWith("/recruitment/applications/app-1/convert", {
        employeeNo: "E002",
        departmentId: "dept-1"
      });
    });
  });
});
