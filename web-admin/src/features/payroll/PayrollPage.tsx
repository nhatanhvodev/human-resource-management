import { Alert, Button, Descriptions, Drawer, Form, Input, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useState } from "react";
import { useTranslation } from "react-i18next";

import { API } from "../../shared/api/endpoints";
import { useApiMutation, useApiQuery } from "../../shared/api/query";
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
  const { t, i18n } = useTranslation();
  const [openRuns, setOpenRuns] = useState(false);
  const [activePeriodId, setActivePeriodId] = useState<string | null>(null);
  const [openPeriod, setOpenPeriod] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form] = Form.useForm<{ fromDate: string; toDate: string }>();

  const [openPayslips, setOpenPayslips] = useState(false);
  const [activeRunId, setActiveRunId] = useState<string | null>(null);
  const [selectedPayslip, setSelectedPayslip] = useState<Payslip | null>(null);
  const [currentRunId, setCurrentRunId] = useState<string>("");

  const periodsQuery = useApiQuery<PageResponse<PayrollPeriod>>(
    ['payroll', 'periods'],
    API.PAYROLL_PERIODS,
    { config: { params: { page: 0, size: 10 } } }
  );
  const periods = periodsQuery.data?.items ?? [];
  const loading = periodsQuery.isLoading;

  const runsQuery = useApiQuery<PageResponse<PayrollRun>>(
    ['payroll', 'runs', activePeriodId],
    API.PAYROLL_RUNS,
    { enabled: openRuns && Boolean(activePeriodId), config: { params: { periodId: activePeriodId, page: 0, size: 10 } } }
  );
  const runs = runsQuery.data?.items ?? [];

  const payslipsQuery = useApiQuery<Payslip[] | PageResponse<Payslip>>(
    ['payroll', 'payslips', activeRunId],
    `${API.PAYROLL_RUNS}/${activeRunId}/payslips`,
    { enabled: openPayslips && Boolean(activeRunId), config: { params: { page: 0, size: 200 } } }
  );
  const payslipsData = payslipsQuery.data;
  const payslips: Payslip[] = Array.isArray(payslipsData) ? payslipsData : (payslipsData?.items ?? []);

  const periodMutation = useApiMutation({ invalidateKeys: [['payroll', 'periods']] });
  const runMutation = useApiMutation({ invalidateKeys: [['payroll', 'runs']] });
  const saving = periodMutation.isPending;

  const createPeriod = async (values: { fromDate: string; toDate: string }) => {
    setError(null);
    try {
      await periodMutation.mutateAsync({ url: API.PAYROLL_PERIODS, body: values });
      form.resetFields();
      setOpenPeriod(false);
    } catch {
      setError(t("pages.payroll.createError"));
    }
  };

  const openRunsDrawer = (periodId: string) => {
    setActivePeriodId(periodId);
    setOpenRuns(true);
  };

  const openPayslipsDrawer = (runId: string, runLabel: string) => {
    setCurrentRunId(runLabel);
    setActiveRunId(runId);
    setOpenPayslips(true);
  };

  const executePeriod = async (periodId: string) => {
    setError(null);
    try {
      await runMutation.mutateAsync({ url: `${API.PAYROLL_RUNS}/${periodId}/execute`, body: null });
      openRunsDrawer(periodId);
    } catch {
      setError(t("pages.payroll.executeError"));
    }
  };

  const closePeriod = async (periodId: string) => {
    setError(null);
    try {
      await periodMutation.mutateAsync({ url: `${API.PAYROLL_PERIODS}/${periodId}/close`, body: null });
    } catch {
      setError(t("pages.payroll.closeError"));
    }
  };

  const money = (value?: number) => value?.toLocaleString(i18n.language === "en" ? "en-US" : "vi-VN");
  const visibleError = error ?? (periodsQuery.isError ? t("pages.payroll.loadError") : null);

  const periodColumns: ColumnsType<PayrollPeriod> = [
    {
      title: t("pages.payroll.period"),
      dataIndex: "id",
      render: (value: string, row) => (
        row.periodFrom && row.periodTo ? `${row.periodFrom} - ${row.periodTo}` : "-"
      )
    },
    {
      title: t("common.status"),
      dataIndex: "status",
      width: 160,
      render: (value: string) => <StatusTag value={value} />
    },
    {
      title: t("common.actions"),
      key: "actions",
      width: 260,
      render: (_, row) => {
        const isClosed = row.status === "CLOSED";

        return (
          <Space>
            <Button size="small" onClick={() => void openRunsDrawer(row.id)}>
              {t("pages.payroll.runs")}
            </Button>
            <Button size="small" disabled={isClosed} onClick={() => void executePeriod(row.id)}>
              {t("pages.payroll.runPayroll")}
            </Button>
            <Button size="small" disabled={isClosed} onClick={() => void closePeriod(row.id)}>
              {t("pages.payroll.closePeriod")}
            </Button>
          </Space>
        );
      }
    }
  ];

  const runColumns: ColumnsType<PayrollRun> = [
    { title: t("pages.payroll.run"), dataIndex: "id", render: (_: string, __, index) => `RUN${String(index + 1).padStart(4, "0")}` },
    {
      title: t("common.status"),
      dataIndex: "status",
      width: 160,
      render: (value?: string) => (value ? <StatusTag value={value} /> : null)
    },
    { title: t("pages.payroll.executedAt"), dataIndex: "executedAt", width: 220 },
    {
      title: t("common.actions"),
      key: "actions",
      width: 120,
      render: (_, row, index) => (
        <Button size="small" onClick={() => void openPayslipsDrawer(row.id, `RUN${String(index + 1).padStart(4, "0")}`)}>
          {t("pages.payroll.payslips")}
        </Button>
      )
    }
  ];

  const payslipColumns: ColumnsType<Payslip> = [
    { title: t("pages.payroll.payslipId"), dataIndex: "id", render: (_: string, __, index) => `PS${String(index + 1).padStart(4, "0")}` },
    { title: t("pages.payroll.basicSalary"), dataIndex: "basicSalary", render: (v: number) => money(v) },
    { title: t("pages.payroll.allowance"), dataIndex: "allowance", render: (v: number) => money(v) },
    { title: t("pages.payroll.deduction"), dataIndex: "deduction", render: (v: number) => money(v) },
    { title: t("pages.payroll.overtimePay"), dataIndex: "overtimePay", render: (v: number) => money(v) },
    { title: t("pages.payroll.netPay"), dataIndex: "netPay", render: (v: number) => <strong>{money(v)}</strong> },
    {
      title: "",
      key: "detail",
      width: 80,
      render: (_, row) => (
        <Button size="small" type="link" onClick={() => setSelectedPayslip(row)}>
          {t("common.detail")}
        </Button>
      )
    }
  ];

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.payroll.title")}</h1>
        <p>{t("pages.payroll.subtitle")}</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" onClick={() => setOpenPeriod(true)}>
          {t("pages.payroll.createPeriod")}
        </Button>
      </PageToolbar>

      {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}

      <AppTable<PayrollPeriod>
        rowKey="id"
        loading={loading}
        columns={periodColumns}
        dataSource={periods}
        pagination={false}
      />

      <Drawer title={t("pages.payroll.runs")} width="min(520px, calc(100vw - 32px))" open={openRuns} onClose={() => setOpenRuns(false)}>
        <AppTable<PayrollRun> rowKey="id" columns={runColumns} dataSource={runs} pagination={false} />
      </Drawer>

      <Drawer
        title={t("pages.payroll.payslipsForRun", { runId: currentRunId })}
        width="min(800px, calc(100vw - 32px))"
        open={openPayslips}
        onClose={() => { setOpenPayslips(false); setActiveRunId(null); }}
      >
        <AppTable<Payslip> rowKey="id" columns={payslipColumns} dataSource={payslips} pagination={false} />
      </Drawer>

      <Drawer
        title={t("pages.payroll.payslipDetail")}
        width="min(480px, calc(100vw - 32px))"
        open={!!selectedPayslip}
        onClose={() => setSelectedPayslip(null)}
      >
        {selectedPayslip && (
          <Descriptions bordered column={1} size="middle">
            <Descriptions.Item label={t("pages.payroll.basicSalary")}>
              {money(selectedPayslip.basicSalary)} VND
            </Descriptions.Item>
            <Descriptions.Item label={t("pages.payroll.allowance")}>
              {money(selectedPayslip.allowance)} VND
            </Descriptions.Item>
            <Descriptions.Item label={t("pages.payroll.socialInsuranceDeduction")}>
              -{money(selectedPayslip.deduction)} VND
            </Descriptions.Item>
            <Descriptions.Item label={t("pages.payroll.overtimePay")}>
              {money(selectedPayslip.overtimePay)} VND
            </Descriptions.Item>
            <Descriptions.Item label={t("pages.payroll.netPay")}>
              <strong>{money(selectedPayslip.netPay)} VND</strong>
            </Descriptions.Item>
            <Descriptions.Item label={t("pages.payroll.issuedAt")}>
              {selectedPayslip.issuedAt ?? t("pages.payroll.notIssued")}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>

      <FormDrawer open={openPeriod} title={t("pages.payroll.createPeriod")} onClose={() => setOpenPeriod(false)}>
        <Form form={form} layout="vertical" onFinish={createPeriod}>
          <Form.Item label={t("common.fromDate")} name="fromDate" htmlFor="payroll-start" rules={[{ required: true, message: t("pages.payroll.selectStartDate") }]}>
            <Input id="payroll-start" type="date" />
          </Form.Item>
          <Form.Item label={t("common.toDate")} name="toDate" htmlFor="payroll-end" rules={[{ required: true, message: t("pages.payroll.selectEndDate") }]}>
            <Input id="payroll-end" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            {t("pages.payroll.createPeriodShort")}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
