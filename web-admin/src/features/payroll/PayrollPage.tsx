import { Alert, Button, Drawer, Form, Input, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type PayrollPeriod = {
  id: string;
  status: string;
};

type PayrollRun = {
  id: string;
  status?: string;
  executedAt?: string;
};

export default function PayrollPage() {
  const [periods, setPeriods] = useState<PayrollPeriod[]>([]);
  const [runs, setRuns] = useState<PayrollRun[]>([]);
  const [openRuns, setOpenRuns] = useState(false);
  const [openPeriod, setOpenPeriod] = useState(false);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form] = Form.useForm<{ fromDate: string; toDate: string }>();

  const loadPeriods = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<PayrollPeriod>>("/payroll-periods", {
        params: { page: 0, size: 10 }
      });
      setPeriods(response.data.items ?? []);
    } catch {
      setError("Unable to load payroll periods. Check token, tenant, and backend connectivity.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void loadPeriods();
  }, [loadPeriods]);

  const createPeriod = async (values: { fromDate: string; toDate: string }) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post("/payroll-periods", values);
      form.resetFields();
      setOpenPeriod(false);
      await loadPeriods();
    } catch {
      setError("Unable to create payroll period. Check date range and duplicate periods.");
    } finally {
      setSaving(false);
    }
  };

  const openRunsDrawer = async (periodId: string) => {
    setOpenRuns(true);
    try {
      const response = await apiClient.get<PageResponse<PayrollRun>>("/payroll-runs", {
        params: { periodId, page: 0, size: 10 }
      });
      setRuns(response.data.items ?? []);
    } catch {
      setRuns([]);
    }
  };

  const executePeriod = async (periodId: string) => {
    setError(null);
    try {
      await apiClient.post(`/payroll-runs/${periodId}/execute`);
      await openRunsDrawer(periodId);
    } catch {
      setError("Unable to execute payroll run for this period.");
    }
  };

  const closePeriod = async (periodId: string) => {
    setError(null);
    try {
      await apiClient.post(`/payroll-periods/${periodId}/close`);
      await loadPeriods();
    } catch {
      setError("Unable to close payroll period.");
    }
  };

  const periodColumns: ColumnsType<PayrollPeriod> = [
    {
      title: "Period",
      dataIndex: "id",
      render: (value: string) => value.slice(0, 8)
    },
    {
      title: "Status",
      dataIndex: "status",
      width: 160,
      render: (value: string) => <StatusTag value={value} />
    },
    {
      title: "Actions",
      key: "actions",
      width: 260,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => void openRunsDrawer(row.id)}>
            Runs
          </Button>
          <Button size="small" onClick={() => void executePeriod(row.id)}>
            Execute
          </Button>
          <Button size="small" onClick={() => void closePeriod(row.id)}>
            Close
          </Button>
        </Space>
      )
    }
  ];

  const runColumns: ColumnsType<PayrollRun> = [
    { title: "Run", dataIndex: "id" },
    {
      title: "Status",
      dataIndex: "status",
      width: 160,
      render: (value?: string) => (value ? <StatusTag value={value} /> : null)
    },
    { title: "Executed", dataIndex: "executedAt", width: 220 }
  ];

  return (
    <>
      <div className="page-header">
        <h1>Payroll</h1>
        <p>Manage payroll periods, execution runs, and close operations.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" onClick={() => setOpenPeriod(true)}>
          Create payroll period
        </Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<PayrollPeriod>
        rowKey="id"
        loading={loading}
        columns={periodColumns}
        dataSource={periods}
        pagination={false}
      />

      <Drawer title="Payroll runs" width="min(520px, calc(100vw - 32px))" open={openRuns} onClose={() => setOpenRuns(false)}>
        <AppTable<PayrollRun> rowKey="id" columns={runColumns} dataSource={runs} pagination={false} />
      </Drawer>

      <FormDrawer open={openPeriod} title="Create payroll period" onClose={() => setOpenPeriod(false)}>
        <Form form={form} layout="vertical" onFinish={createPeriod}>
          <Form.Item label="Tu ngay" name="fromDate" htmlFor="payroll-start" rules={[{ required: true, message: "Chon ngay bat dau" }]}>
            <Input id="payroll-start" type="date" />
          </Form.Item>
          <Form.Item label="Den ngay" name="toDate" htmlFor="payroll-end" rules={[{ required: true, message: "Chon ngay ket thuc" }]}>
            <Input id="payroll-end" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            Tao ky
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
