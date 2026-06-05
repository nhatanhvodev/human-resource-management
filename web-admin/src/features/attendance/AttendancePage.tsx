import { Alert, Button, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { StatusTag } from "../../shared/ui/StatusTag";

type TimeEntry = {
  id: string;
  employeeId: string;
  date: string;
  clockIn: string | null;
  clockOut: string | null;
  totalMinutes: number | null;
  status: string;
};

export default function AttendancePage() {
  const { t } = useTranslation();
  const [entries, setEntries] = useState<TimeEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [activeTab, setActiveTab] = useState("all");

  const loadEntries = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const status = activeTab === "all" ? undefined : activeTab.toUpperCase();
      const response = await apiClient.get<PageResponse<TimeEntry>>("/time-entries", {
        params: { page: 0, size: 50, ...(status ? { status } : {}) }
      });
      setEntries(response.data.items ?? []);
    } catch {
      setError(t("pages.attendance.loadError"));
    } finally {
      setLoading(false);
    }
  }, [activeTab, t]);

  useEffect(() => { void loadEntries(); }, [loadEntries]);

  const transition = async (id: string, action: "approve" | "reject") => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post(`/time-entries/${id}/${action}`);
      await loadEntries();
    } catch {
      setError(action === "approve" ? t("pages.attendance.approveError") : t("pages.attendance.rejectError"));
    } finally {
      setSaving(false);
    }
  };

  const entriesColumns = useMemo<ColumnsType<TimeEntry>>(() => [
    { title: t("common.employee"), dataIndex: "employeeId", render: (v: string) => v.slice(0, 8) },
    { title: t("common.date"), dataIndex: "date", width: 120 },
    { title: t("pages.attendance.clockIn"), dataIndex: "clockIn", width: 90 },
    { title: t("pages.attendance.clockOut"), dataIndex: "clockOut", width: 90 },
    { title: t("pages.attendance.minutes"), dataIndex: "totalMinutes", width: 70 },
    {
      title: t("common.status"), dataIndex: "status", width: 140,
      render: (v: string) => <StatusTag value={v} />
    },
    {
      title: t("common.actions"), key: "actions", width: 190,
      render: (_, row) => {
        const pending = row.status === "PENDING";
        return (
          <Space>
            <Button size="small" disabled={!pending || saving}
              onClick={() => void transition(row.id, "approve")}>{t("common.approve")}</Button>
            <Button size="small" danger disabled={!pending || saving}
              onClick={() => void transition(row.id, "reject")}>{t("common.reject")}</Button>
          </Space>
        );
      }
    }
  ], [saving, t]);

  const tabItems = [
    {
      key: "all", label: t("common.all"),
      children: <AppTable<TimeEntry> rowKey="id" loading={loading} columns={entriesColumns} dataSource={entries} pagination={false} />
    },
    {
      key: "pending", label: t("status.PENDING"),
      children: <AppTable<TimeEntry> rowKey="id" loading={loading} columns={entriesColumns} dataSource={entries} pagination={false} />
    },
    {
      key: "approved", label: t("status.APPROVED"),
      children: <AppTable<TimeEntry> rowKey="id" loading={loading} columns={entriesColumns} dataSource={entries} pagination={false} />
    }
  ];

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.attendance.title")}</h1>
        <p>{t("pages.attendance.subtitle")}</p>
      </div>
      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}
      <Tabs activeKey={activeTab} onChange={setActiveTab} items={tabItems} />
    </>
  );
}
