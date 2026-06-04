import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { AppTable } from "./AppTable";

describe("AppTable", () => {
  it("renders the empty state in Vietnamese", () => {
    render(<AppTable rowKey="id" dataSource={[]} columns={[{ title: "Tên", dataIndex: "name" }]} />);

    expect(screen.getByText("Không có dữ liệu")).toBeInTheDocument();
    expect(screen.getByText("Chưa có bản ghi phù hợp với bộ lọc hiện tại.")).toBeInTheDocument();
  });
});
