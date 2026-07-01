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
  PUBLISHED: "blue",
  OFFER_ACCEPTED: "blue",
  HIRED: "green",
  RUNNING: "gold",
  COMPLETED: "green",
  EXECUTED: "green",
  FAILED: "red",
  APPLIED: "blue",
  SCHEDULED: "gold",
  CANCELLED: "default",
  SCREEN: "cyan",
  PHONE_INTERVIEW: "geekblue",
  TECHNICAL: "purple",
  ONSITE: "orange",
  OFFER: "volcano",
  SUBMITTED: "green",
  ANNUAL: "blue",
  SICK: "red",
  UNPAID: "default",
  MATERNITY: "magenta",
  PATERNITY: "cyan",
  ENROLLED: "blue",
  IN_PROGRESS: "processing",
  NOT_STARTED: "default",
  AVAILABLE: "green",
  ASSIGNED: "blue",
  BROKEN: "red",
  RETIRED: "default",
  TODO: "default",
  DONE: "green",
  REVIEWED: "blue",
  FINALIZED: "green",
  SENT: "green",
  LOW: "default",
  NORMAL: "blue",
  HIGH: "orange",
  URGENT: "red",
  CONFIRMED: "green"
};

export function StatusTag({ value }: StatusTagProps) {
  const { t } = useTranslation();
  return <Tag color={statusColors[value] ?? "default"}>{t(`status.${value}`, value)}</Tag>;
}
