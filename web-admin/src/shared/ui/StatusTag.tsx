import { Tag } from "antd";

type StatusTagProps = {
  value: string;
};

const statusColors: Record<string, string> = {
  ACTIVE: "green",
  INACTIVE: "default",
  PENDING: "gold",
  APPROVED: "blue",
  REJECTED: "red",
  OPEN: "green",
  CLOSED: "default",
  DRAFT: "default",
  OFFER_ACCEPTED: "blue",
  HIRED: "green",
  RUNNING: "gold",
  COMPLETED: "green",
  EXECUTED: "green",
  FAILED: "red"
};

const statusLabels: Record<string, string> = {
  ACTIVE: "Đang làm việc",
  INACTIVE: "Ngừng hoạt động",
  PENDING: "Chờ duyệt",
  APPROVED: "Đã duyệt",
  REJECTED: "Từ chối",
  OPEN: "Đang mở",
  CLOSED: "Đã đóng",
  DRAFT: "Bản nháp",
  OFFER_ACCEPTED: "Đã nhận đề nghị",
  HIRED: "Đã tuyển",
  RUNNING: "Đang chạy",
  COMPLETED: "Hoàn tất",
  EXECUTED: "Đã chạy",
  FAILED: "Thất bại"
};

export function StatusTag({ value }: StatusTagProps) {
  return <Tag color={statusColors[value] ?? "default"}>{statusLabels[value] ?? value}</Tag>;
}
