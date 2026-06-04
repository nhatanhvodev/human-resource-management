import { Alert, Button, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

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
      setError("Không tải được danh sách chấm công.");
    } finally {
      setLoading(false);
    }
  }, [activeTab]);

  useEffect(() => { void loadEntries(); }, [loadEntries]);

  const transition = async (id: string, action: "approve" | "reject") => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post(`/time-entries/${id}/${action}`);
      await loadEntries();
    } catch {
      setError(action === "approve" ? "Không duyệt được bản ghi." : "Không từ chối được bản ghi.");
    } finally {
      setSaving(false);
    }
  };

  const entriesColumns = useMemo<ColumnsType<TimeEntry>>(() => [
    { title: "Nhân viên", dataIndex: "employeeId", render: (v: string) => v.slice(0, 8) },
    { title: "Ngày", dataIndex: "date", width: 120 },
    { title: "Vào", dataIndex: "clockIn", width: 90 },
    { title: "Ra", dataIndex: "clockOut", width: 90 },
    { title: "Phút", dataIndex: "totalMinutes", width: 70 },
    {
      title: "Trạng thái", dataIndex: "status", width: 140,
      render: (v: string) => <StatusTag value={v} />
    },
    {
      title: "Thao tác", key: "actions", width: 190,
      render: (_, row) => {
        const pending = row.status === "PENDING";
        return (
          <Space>
            <Button size="small" disabled={!pending || saving}
              onClick={() => void transition(row.id, "approve")}>Duyệt</Button>
            <Button size="small" danger disabled={!pending || saving}
              onClick={() => void transition(row.id, "reject")}>Từ chối</Button>
          </Space>
        );
      }
    }
  ], [saving]);

  const tabItems = [
    {
      key: "all", label: "Tất cả",
      children: <AppTable<TimeEntry> rowKey="id" loading={loading} columns={entriesColumns} dataSource={entries} pagination={false} />
    },
    {
      key: "pending", label: "Chờ duyệt",
      children: <AppTable<TimeEntry> rowKey="id" loading={loading} columns={entriesColumns} dataSource={entries} pagination={false} />
    },
    {
      key: "approved", label: "Đã duyệt",
      children: <AppTable<TimeEntry> rowKey="id" loading={loading} columns={entriesColumns} dataSource={entries} pagination={false} />
    }
  ];

  return (
    <>
      <div className="page-header">
        <h1>Chấm công</h1>
        <p>Quản lý bản ghi chấm công và duyệt đơn.</p>
      </div>
      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}
      <Tabs activeKey={activeTab} onChange={setActiveTab} items={tabItems} />
    </>
  );
}
