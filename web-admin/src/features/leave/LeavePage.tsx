import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type LeaveRequest = {
  id: string;
  employeeId?: string;
  employeeName?: string;
  leaveType?: string;
  fromDate?: string;
  toDate?: string;
  startDate?: string;
  endDate?: string;
  status: string;
};

type Employee = {
  id: string;
  employeeNo: string;
  fullName: string;
};

type LeaveBalance = {
  id: string;
  employeeId: string;
  employeeName?: string;
  leaveType: string;
  year: number;
  totalDays: number;
  usedDays: number;
  pendingDays: number;
};

type Holiday = {
  id: string;
  name: string;
  date: string;
  description?: string;
  isRecurringYearly: boolean;
};

type OvertimeRecord = {
  id: string;
  employeeId: string;
  employeeName?: string;
  date: string;
  hours: number;
  status: string;
};

export default function LeavePage() {
  const { t } = useTranslation();
  const [items, setItems] = useState<LeaveRequest[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [activeTab, setActiveTab] = useState("requests");
  const [form] = Form.useForm<{ employeeId: string; fromDate: string; toDate: string }>();

  // --- Leave balances state ---
  const [balances, setBalances] = useState<LeaveBalance[]>([]);
  const [balancesLoading, setBalancesLoading] = useState(false);

  // --- Holidays state ---
  const [holidays, setHolidays] = useState<Holiday[]>([]);
  const [holidaysLoading, setHolidaysLoading] = useState(false);

  // --- Overtime state ---
  const [overtimeItems, setOvertimeItems] = useState<OvertimeRecord[]>([]);
  const [overtimeLoading, setOvertimeLoading] = useState(false);

  const loadLeaveRequests = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<LeaveRequest>>("/leave-requests", {
        params: { page: 0, size: 10 }
      });
      setItems(response.data.items ?? []);
    } catch {
      setError(t("pages.leave.loadError"));
    } finally {
      setLoading(false);
    }
  }, [t]);

  const loadEmployees = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Employee>>("/employees", {
        params: { page: 0, size: 100, status: "ACTIVE" }
      });
      setEmployees(response.data.items ?? []);
    } catch {
      setEmployees([]);
    }
  }, []);

  const loadLeaveBalances = useCallback(async () => {
    setBalancesLoading(true);
    try {
      const response = await apiClient.get<PageResponse<LeaveBalance>>("/leave-balances", {
        params: { page: 0, size: 50 }
      });
      setBalances(response.data.items ?? []);
    } catch {
      setBalances([]);
    } finally {
      setBalancesLoading(false);
    }
  }, []);

  const loadHolidays = useCallback(async () => {
    setHolidaysLoading(true);
    try {
      const response = await apiClient.get<PageResponse<Holiday>>("/holidays", {
        params: { page: 0, size: 20 }
      });
      setHolidays(response.data.items ?? []);
    } catch {
      setHolidays([]);
    } finally {
      setHolidaysLoading(false);
    }
  }, []);

  const loadOvertime = useCallback(async () => {
    setOvertimeLoading(true);
    try {
      const response = await apiClient.get<PageResponse<OvertimeRecord>>("/overtime", {
        params: { page: 0, size: 50 }
      });
      setOvertimeItems(response.data.items ?? []);
    } catch {
      setOvertimeItems([]);
    } finally {
      setOvertimeLoading(false);
    }
  }, []);

  useEffect(() => {
    void loadLeaveRequests();
  }, [loadLeaveRequests]);

  useEffect(() => {
    void loadEmployees();
  }, [loadEmployees]);

  useEffect(() => {
    void loadLeaveBalances();
  }, [loadLeaveBalances]);

  useEffect(() => {
    void loadHolidays();
  }, [loadHolidays]);

  useEffect(() => {
    void loadOvertime();
  }, [loadOvertime]);

  const employeeById = useMemo(() => new Map(employees.map((employee) => [employee.id, employee])), [employees]);

  const createLeaveRequest = async (values: { employeeId: string; fromDate: string; toDate: string }) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post("/leave-requests", values);
      form.resetFields();
      setOpenCreate(false);
      await loadLeaveRequests();
    } catch {
      setError(t("pages.leave.createError"));
    } finally {
      setSaving(false);
    }
  };

  const transitionLeaveRequest = async (id: string, action: "approve" | "reject") => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post(`/leave-requests/${id}/${action}`);
      await loadLeaveRequests();
    } catch {
      setError(action === "approve" ? t("pages.leave.approveError") : t("pages.leave.rejectError"));
    } finally {
      setSaving(false);
    }
  };

  const transitionOvertime = async (id: string, action: "approve" | "reject") => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post(`/overtime/${id}/${action}`);
      await loadOvertime();
    } catch {
      setError(action === "approve" ? t("pages.leave.overtimeApproveError") : t("pages.leave.overtimeRejectError"));
    } finally {
      setSaving(false);
    }
  };

  const requestColumns = useMemo<ColumnsType<LeaveRequest>>(
    () => [
      {
        title: t("common.employee"),
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: t("pages.leave.requestType"),
        dataIndex: "leaveType",
        width: 160,
        render: (value?: string) => value ?? t("pages.leave.missingApiData")
      },
      {
        title: t("common.fromDate"),
        dataIndex: "fromDate",
        width: 150,
        render: (value: string | undefined, row) => value ?? row.startDate
      },
      {
        title: t("common.toDate"),
        dataIndex: "toDate",
        width: 150,
        render: (value: string | undefined, row) => value ?? row.endDate
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
        width: 190,
        render: (_, row) => {
          const isPending = row.status === "PENDING";
          return (
            <Space>
              <Button
                size="small"
                disabled={!isPending || saving}
                onClick={() => void transitionLeaveRequest(row.id, "approve")}
              >
                {t("common.approve")}
              </Button>
              <Button
                size="small"
                danger
                disabled={!isPending || saving}
                onClick={() => void transitionLeaveRequest(row.id, "reject")}
              >
                {t("common.reject")}
              </Button>
            </Space>
          );
        }
      }
    ],
    [employeeById, saving, t]
  );

  const balanceColumns = useMemo<ColumnsType<LeaveBalance>>(
    () => [
      {
        title: t("common.employee"),
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: t("pages.leave.balanceType"),
        dataIndex: "leaveType",
        width: 160
      },
      {
        title: t("pages.leave.year"),
        dataIndex: "year",
        width: 80
      },
      {
        title: t("pages.leave.totalDays"),
        dataIndex: "totalDays",
        width: 130
      },
      {
        title: t("pages.leave.usedDays"),
        dataIndex: "usedDays",
        width: 100
      },
      {
        title: t("pages.leave.pendingDays"),
        dataIndex: "pendingDays",
        width: 110
      }
    ],
    [employeeById, t]
  );

  const holidayColumns = useMemo<ColumnsType<Holiday>>(
    () => [
      {
        title: t("pages.leave.holidayName"),
        dataIndex: "name",
        width: 220
      },
      {
        title: t("common.date"),
        dataIndex: "date",
        width: 150
      },
      {
        title: t("common.description"),
        dataIndex: "description",
        render: (value?: string) => value ?? "-"
      },
      {
        title: t("pages.leave.recurringYearly"),
        dataIndex: "isRecurringYearly",
        width: 160,
        render: (value: boolean) => (value ? t("pages.leave.yes") : t("pages.leave.no"))
      }
    ],
    [t]
  );

  const overtimeColumns = useMemo<ColumnsType<OvertimeRecord>>(
    () => [
      {
        title: t("common.employee"),
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: t("common.date"),
        dataIndex: "date",
        width: 150
      },
      {
        title: t("pages.leave.hours"),
        dataIndex: "hours",
        width: 100
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
        width: 190,
        render: (_, row) => {
          const isPending = row.status === "PENDING";
          return (
            <Space>
              <Button
                size="small"
                disabled={!isPending || saving}
                onClick={() => void transitionOvertime(row.id, "approve")}
              >
                {t("common.approve")}
              </Button>
              <Button
                size="small"
                danger
                disabled={!isPending || saving}
                onClick={() => void transitionOvertime(row.id, "reject")}
              >
                {t("common.reject")}
              </Button>
            </Space>
          );
        }
      }
    ],
    [employeeById, saving, t]
  );

  const tabItems = [
    {
      key: "requests",
      label: t("pages.leave.requests"),
      children: (
        <>
          <PageToolbar>
            <Space />
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
              {t("pages.leave.createRequest")}
            </Button>
          </PageToolbar>

          {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

          <AppTable<LeaveRequest>
            rowKey="id"
            loading={loading}
            columns={requestColumns}
            dataSource={items}
            pagination={false}
          />
        </>
      )
    },
    {
      key: "balances",
      label: t("pages.leave.balances"),
      children: (
        <AppTable<LeaveBalance>
          rowKey="id"
          loading={balancesLoading}
          columns={balanceColumns}
          dataSource={balances}
          pagination={false}
        />
      )
    },
    {
      key: "holidays",
      label: t("pages.leave.holidays"),
      children: (
        <AppTable<Holiday>
          rowKey="id"
          loading={holidaysLoading}
          columns={holidayColumns}
          dataSource={holidays}
          pagination={false}
        />
      )
    },
    {
      key: "overtime",
      label: t("pages.leave.overtime"),
      children: (
        <>
          {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

          <AppTable<OvertimeRecord>
            rowKey="id"
            loading={overtimeLoading}
            columns={overtimeColumns}
            dataSource={overtimeItems}
            pagination={false}
          />
        </>
      )
    }
  ];

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.leave.title")}</h1>
        <p>{t("pages.leave.subtitle")}</p>
      </div>

      <Tabs activeKey={activeTab} onChange={setActiveTab} items={tabItems} />

      <FormDrawer open={openCreate} title={t("pages.leave.createRequest")} onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createLeaveRequest}>
          <Form.Item label={t("common.employee")} name="employeeId" htmlFor="leave-employee" rules={[{ required: true, message: t("pages.leave.selectEmployee") }]}>
            <Select
              id="leave-employee"
              placeholder={t("pages.leave.selectEmployee")}
              options={employees.map((employee) => ({
                value: employee.id,
                label: `${employee.employeeNo} - ${employee.fullName}`
              }))}
            />
          </Form.Item>
          <Form.Item label={t("common.fromDate")} name="fromDate" htmlFor="leave-start" rules={[{ required: true, message: t("pages.leave.selectStartDate") }]}>
            <Input id="leave-start" type="date" />
          </Form.Item>
          <Form.Item label={t("common.toDate")} name="toDate" htmlFor="leave-end" rules={[{ required: true, message: t("pages.leave.selectEndDate") }]}>
            <Input id="leave-end" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!employees.length}>
            {t("pages.leave.saveRequest")}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
