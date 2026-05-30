import { Tag } from "antd";

type StatusTagProps = {
  value: string;
};

const statusColors: Record<string, string> = {
  ACTIVE: "green",
  INACTIVE: "default",
  PENDING: "gold",
  APPROVED: "blue",
  REJECTED: "red"
};

export function StatusTag({ value }: StatusTagProps) {
  return <Tag color={statusColors[value] ?? "default"}>{value}</Tag>;
}
