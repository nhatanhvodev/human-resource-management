import { Alert, Button, Drawer, Form, Input, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type PayrollPeriod = {
  id: string;
  startDate?: string;
  endDate?: string;
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
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    async function loadPeriods() {
      setLoading(true);
      setError(null);
      try {
        const response = await apiClient.get<PageResponse<PayrollPeriod>>("/payroll-periods", {
          params: { page: 0, size: 10 }
        });
        if (mounted) {
          setPeriods(response.data.items ?? []);
        }
      } catch {
        if (mounted) {
          setError("Unable to load payroll periods. Check token, tenant, and backend connectivity.");
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    void loadPeriods();

    return () => {
      mounted = false;
    };
  }, []);

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

  const periodColumns: ColumnsType<PayrollPeriod> = [
    { title: "Start", dataIndex: "startDate", width: 170 },
    { title: "End", dataIndex: "endDate", width: 170 },
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
          <Button size="small">Execute</Button>
          <Button size="small">Close</Button>
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

      <Drawer title="Payroll runs" width={520} open={openRuns} onClose={() => setOpenRuns(false)}>
        <AppTable<PayrollRun> rowKey="id" columns={runColumns} dataSource={runs} pagination={false} />
      </Drawer>

      <FormDrawer open={openPeriod} title="Create payroll period" onClose={() => setOpenPeriod(false)}>
        <Form layout="vertical">
          <Form.Item label="Tu ngay" htmlFor="payroll-start">
            <Input id="payroll-start" type="date" />
          </Form.Item>
          <Form.Item label="Den ngay" htmlFor="payroll-end">
            <Input id="payroll-end" type="date" />
          </Form.Item>
          <Button type="primary" onClick={() => setOpenPeriod(false)}>
            Tao ky
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
