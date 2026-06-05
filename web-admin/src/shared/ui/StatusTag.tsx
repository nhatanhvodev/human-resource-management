import { Tag } from "antd";
import { useTranslation } from "react-i18next";

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

export function StatusTag({ value }: StatusTagProps) {
  const { t } = useTranslation();
  return <Tag color={statusColors[value] ?? "default"}>{t(`status.${value}`, value)}</Tag>;
}
