import { Alert, Button, Descriptions, Drawer, Form, Input, Space } from "antd";
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
  periodFrom?: string;
  periodTo?: string;
  status: string;
};

type PayrollRun = {
  id: string;
  status?: string;
  executedAt?: string;
};

type Payslip = {
  id: string;
  payrollRunId?: string;
  employeeId?: string;
  employeeName?: string;
  basicSalary: number;
  allowance: number;
  deduction: number;
  overtimePay: number;
  netPay: number;
  issuedAt?: string;
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

  const [payslips, setPayslips] = useState<Payslip[]>([]);
  const [openPayslips, setOpenPayslips] = useState(false);
  const [selectedPayslip, setSelectedPayslip] = useState<Payslip | null>(null);
  const [currentRunId, setCurrentRunId] = useState<string>("");

  const loadPeriods = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<PayrollPeriod>>("/payroll-periods", {
        params: { page: 0, size: 10 }
      });
      setPeriods(response.data.items ?? []);
    } catch {
      setError("Không tải được danh sách kỳ lương. Kiểm tra token, tenant và kết nối backend.");
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
      setError("Không tạo được kỳ lương. Kiểm tra khoảng ngày hoặc kỳ bị trùng.");
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

  const openPayslipsDrawer = async (runId: string) => {
    setCurrentRunId(runId);
    setOpenPayslips(true);
    try {
      const response = await apiClient.get<Payslip[] | PageResponse<Payslip>>(`/payroll-runs/${runId}/payslips`, {
        params: { page: 0, size: 200 }
      });
      setPayslips(Array.isArray(response.data) ? response.data : response.data.items ?? []);
    } catch {
      setPayslips([]);
    }
  };

  const executePeriod = async (periodId: string) => {
    setError(null);
    try {
      await apiClient.post(`/payroll-runs/${periodId}/execute`);
      await openRunsDrawer(periodId);
    } catch {
      setError("Không chạy được bảng lương cho kỳ này.");
    }
  };

  const closePeriod = async (periodId: string) => {
    setError(null);
    try {
      await apiClient.post(`/payroll-periods/${periodId}/close`);
      await loadPeriods();
    } catch {
      setError("Không đóng được kỳ lương.");
    }
  };

  const periodColumns: ColumnsType<PayrollPeriod> = [
    {
      title: "Kỳ lương",
      dataIndex: "id",
      render: (value: string, row) => (
        row.periodFrom && row.periodTo ? `${row.periodFrom} - ${row.periodTo}` : value.slice(0, 8)
      )
    },
    {
      title: "Trạng thái",
      dataIndex: "status",
      width: 160,
      render: (value: string) => <StatusTag value={value} />
    },
    {
      title: "Thao tác",
      key: "actions",
      width: 260,
      render: (_, row) => {
        const isClosed = row.status === "CLOSED";

        return (
          <Space>
            <Button size="small" onClick={() => void openRunsDrawer(row.id)}>
              Lần chạy
            </Button>
            <Button size="small" disabled={isClosed} onClick={() => void executePeriod(row.id)}>
              Chạy lương
            </Button>
            <Button size="small" disabled={isClosed} onClick={() => void closePeriod(row.id)}>
              Đóng kỳ
            </Button>
          </Space>
        );
      }
    }
  ];

  const runColumns: ColumnsType<PayrollRun> = [
    { title: "Lần chạy", dataIndex: "id" },
    {
      title: "Trạng thái",
      dataIndex: "status",
      width: 160,
      render: (value?: string) => (value ? <StatusTag value={value} /> : null)
    },
    { title: "Thời điểm chạy", dataIndex: "executedAt", width: 220 },
    {
      title: "Thao tác",
      key: "actions",
      width: 120,
      render: (_, row) => (
        <Button size="small" onClick={() => void openPayslipsDrawer(row.id)}>
          Phiếu lương
        </Button>
      )
    }
  ];

  const payslipColumns: ColumnsType<Payslip> = [
    { title: "Mã phiếu", dataIndex: "id", render: (v: string) => v.slice(0, 8) },
    { title: "Lương cơ bản", dataIndex: "basicSalary", render: (v: number) => v?.toLocaleString('vi-VN') },
    { title: "Phụ cấp", dataIndex: "allowance", render: (v: number) => v?.toLocaleString('vi-VN') },
    { title: "Khấu trừ", dataIndex: "deduction", render: (v: number) => v?.toLocaleString('vi-VN') },
    { title: "Tăng ca", dataIndex: "overtimePay", render: (v: number) => v?.toLocaleString('vi-VN') },
    { title: "Thực lãnh", dataIndex: "netPay", render: (v: number) => <strong>{v?.toLocaleString('vi-VN')}</strong> },
    {
      title: "",
      key: "detail",
      width: 80,
      render: (_, row) => (
        <Button size="small" type="link" onClick={() => setSelectedPayslip(row)}>
          Chi tiết
        </Button>
      )
    }
  ];

  return (
    <>
      <div className="page-header">
        <h1>Bảng lương</h1>
        <p>Quản lý kỳ lương, các lần chạy tính lương và thao tác đóng kỳ.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" onClick={() => setOpenPeriod(true)}>
          Tạo kỳ lương
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

      <Drawer title="Các lần chạy lương" width="min(520px, calc(100vw - 32px))" open={openRuns} onClose={() => setOpenRuns(false)}>
        <AppTable<PayrollRun> rowKey="id" columns={runColumns} dataSource={runs} pagination={false} />
      </Drawer>

      <Drawer
        title={`Phiếu lương — Lần chạy ${currentRunId.slice(0, 8)}`}
        width="min(800px, calc(100vw - 32px))"
        open={openPayslips}
        onClose={() => { setOpenPayslips(false); setPayslips([]); }}
      >
        <AppTable<Payslip> rowKey="id" columns={payslipColumns} dataSource={payslips} pagination={false} />
      </Drawer>

      <Drawer
        title="Chi tiết phiếu lương"
        width="min(480px, calc(100vw - 32px))"
        open={!!selectedPayslip}
        onClose={() => setSelectedPayslip(null)}
      >
        {selectedPayslip && (
          <Descriptions bordered column={1} size="middle">
            <Descriptions.Item label="Lương cơ bản">
              {selectedPayslip.basicSalary?.toLocaleString('vi-VN')} VNĐ
            </Descriptions.Item>
            <Descriptions.Item label="Phụ cấp">
              {selectedPayslip.allowance?.toLocaleString('vi-VN')} VNĐ
            </Descriptions.Item>
            <Descriptions.Item label="Khấu trừ (BHXH+BHYT+BHTN)">
              -{selectedPayslip.deduction?.toLocaleString('vi-VN')} VNĐ
            </Descriptions.Item>
            <Descriptions.Item label="Lương tăng ca">
              {selectedPayslip.overtimePay?.toLocaleString('vi-VN')} VNĐ
            </Descriptions.Item>
            <Descriptions.Item label="Thực lãnh">
              <strong>{selectedPayslip.netPay?.toLocaleString('vi-VN')} VNĐ</strong>
            </Descriptions.Item>
            <Descriptions.Item label="Ngày phát hành">
              {selectedPayslip.issuedAt ?? "Chưa phát hành"}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>

      <FormDrawer open={openPeriod} title="Tạo kỳ lương" onClose={() => setOpenPeriod(false)}>
        <Form form={form} layout="vertical" onFinish={createPeriod}>
          <Form.Item label="Từ ngày" name="fromDate" htmlFor="payroll-start" rules={[{ required: true, message: "Chọn ngày bắt đầu" }]}>
            <Input id="payroll-start" type="date" />
          </Form.Item>
          <Form.Item label="Đến ngày" name="toDate" htmlFor="payroll-end" rules={[{ required: true, message: "Chọn ngày kết thúc" }]}>
            <Input id="payroll-end" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            Tạo kỳ
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
