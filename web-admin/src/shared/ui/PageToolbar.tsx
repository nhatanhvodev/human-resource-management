import { Space } from "antd";
import type { ReactNode } from "react";

type PageToolbarProps = {
  children: ReactNode;
};

export function PageToolbar({ children }: PageToolbarProps) {
  return (
    <Space wrap size={12} style={{ display: "flex", justifyContent: "space-between", marginBottom: 16 }}>
      {children}
    </Space>
  );
}
