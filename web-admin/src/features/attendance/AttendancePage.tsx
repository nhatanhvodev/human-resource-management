import { Alert, Button, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
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

type Employee = { id: string; employeeNo: string; fullName: string };

export default function AttendancePage() {
  const { t } = useTranslation();
  const [entries, setEntries] = useState<TimeEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [activeTab, setActiveTab] = useState("all");
  const [employees, setEmployees] = useState<Employee[]>([]);

  const loadEntries = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const status = activeTab === "all" ? undefined : activeTab.toUpperCase();
      const response = await apiClient.get<PageResponse<TimeEntry>>(API.TIME_ENTRIES, {
        params: { page: 0, size: 50, ...(status ? { status } : {}) }
      });
      setEntries(response.data.items ?? []);
    } catch {
      setError(t("pages.attendance.loadError"));
    } finally {
      setLoading(false);
    }
  }, [activeTab, t]);

  const loadEmployees = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Employee>>(API.EMPLOYEES, {
        params: { page: 0, size: 200, status: "ACTIVE" }
      });
      setEmployees(response.data.items ?? []);
    } catch {
      setEmployees([]);
    }
  }, []);

  useEffect(() => { void loadEntries(); }, [loadEntries]);
  useEffect(() => { void loadEmployees(); }, [loadEmployees]);

  const employeeById = useMemo(() => new Map(employees.map((employee) => [employee.id, employee])), [employees]);

  const transition = async (id: string, action: "approve" | "reject") => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post(`${API.TIME_ENTRIES}/${id}/${action}`);
      await loadEntries();
    } catch {
      setError(action === "approve" ? t("pages.attendance.approveError") : t("pages.attendance.rejectError"));
    } finally {
      setSaving(false);
    }
  };

  const entriesColumns = useMemo<ColumnsType<TimeEntry>>(() => [
    {
      title: t("common.employee"),
      dataIndex: "employeeId",
      render: (v: string) => {
        const employee = employeeById.get(v);
        return employee ? `${employee.employeeNo} - ${employee.fullName}` : "-";
      }
    },
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
  ], [employeeById, saving, t]);

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
