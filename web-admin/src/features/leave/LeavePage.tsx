import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { useQuery, type UseQueryResult } from "@tanstack/react-query";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
// NOTE: `as UseQueryResult<...>` restores useApiQuery's documented return type, which currently
// degrades under the installed @tanstack/react-query 5.102.8 (overload error inside query.ts).
// The cast is type-only and has zero runtime effect.
import { useApiMutation, useApiQuery } from "../../shared/api/query";
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



export default function LeavePage() {
  const { t } = useTranslation();
  const [openCreate, setOpenCreate] = useState(false);
  const [activeTab, setActiveTab] = useState("requests");
  const [error, setError] = useState<string | null>(null);
  const [form] = Form.useForm<{ employeeId: string; fromDate: string; toDate: string; leaveType: string; reason: string }>();

  const leaveRequestsQuery = useApiQuery<PageResponse<LeaveRequest>>(["leave", "requests"], API.LEAVE_REQUESTS, {
    config: { params: { page: 0, size: 10 } }
  }) as UseQueryResult<PageResponse<LeaveRequest>, unknown>;
  const employeesQuery = useApiQuery<PageResponse<Employee>>(["leave", "employees"], API.EMPLOYEES, {
    config: { params: { page: 0, size: 100, status: "ACTIVE" } }
  }) as UseQueryResult<PageResponse<Employee>, unknown>;
  const holidaysQuery = useApiQuery<Holiday[]>(["leave", "holidays"], API.HOLIDAYS) as UseQueryResult<Holiday[], unknown>;

  const items = leaveRequestsQuery.data?.items ?? [];
  const loading = leaveRequestsQuery.isLoading;
  const loadError = leaveRequestsQuery.isError ? t("pages.leave.loadError") : null;
  const visibleError = error ?? loadError;
  const employees = employeesQuery.data?.items ?? [];
  const holidays = holidaysQuery.data ?? [];
  const holidaysLoading = holidaysQuery.isLoading;

  // Per-employee fan-out can't be expressed as a single GET for useApiQuery,
  // so this composite query uses useQuery directly (still via apiClient).
  const employeeIdsKey = employees.map((employee) => employee.id).join(",");
  const balancesQuery = useQuery<LeaveBalance[]>({
    queryKey: ["leave", "balances", employeeIdsKey],
    enabled: employees.length > 0,
    queryFn: async () => {
      const responses = await Promise.all(
        employees.slice(0, 50).map(async (employee) => {
          const response = await apiClient.get<LeaveBalance[]>(API.LEAVE_BALANCES, {
            params: { employeeId: employee.id }
          });
          return response.data.map((balance) => ({
            ...balance,
            employeeName: employee.fullName
          }));
        })
      );
      return responses.flat();
    }
  });
  const balances = balancesQuery.data ?? [];
  const balancesLoading = balancesQuery.isLoading;

  const createMutation = useApiMutation<LeaveRequest, { employeeId: string; fromDate: string; toDate: string; leaveType: string; reason: string }>({
    invalidateKeys: [["leave", "requests"]]
  });
  const transitionMutation = useApiMutation({
    invalidateKeys: [["leave", "requests"], ["leave", "employees"], ["leave", "balances"]]
  });
  const saving = createMutation.isPending || transitionMutation.isPending;

  const employeeById = useMemo(() => new Map(employees.map((employee) => [employee.id, employee])), [employees]);

  const createLeaveRequest = async (values: { employeeId: string; fromDate: string; toDate: string; leaveType: string; reason: string }) => {
    setError(null);
    try {
      await createMutation.mutateAsync({ url: API.LEAVE_REQUESTS, body: values });
      form.resetFields();
      setOpenCreate(false);
    } catch {
      setError(t("pages.leave.createError"));
    }
  };

  const transitionLeaveRequest = async (id: string, action: "approve" | "reject") => {
    setError(null);
    try {
      await transitionMutation.mutateAsync({ url: `${API.LEAVE_REQUESTS}/${id}/${action}`, body: null });
    } catch {
      setError(action === "approve" ? t("pages.leave.approveError") : t("pages.leave.rejectError"));
    }
  };

  const requestColumns = useMemo<ColumnsType<LeaveRequest>>(
    () => [
      {
        title: t("common.employee"),
        dataIndex: "employeeName",
        render: (value: string | undefined) => value ?? "-"
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
    [saving, t]
  );

  const balanceColumns = useMemo<ColumnsType<LeaveBalance>>(
    () => [
      {
        title: t("common.employee"),
        dataIndex: "employeeName",
        render: (value: string | undefined) => value ?? "-"
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
    [t]
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

          {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}

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
          <Form.Item label={t("pages.leave.requestType")} name="leaveType" htmlFor="leave-type" rules={[{ required: true, message: t("pages.leave.selectLeaveType") }]}>
            <Select
              id="leave-type"
              placeholder={t("pages.leave.selectLeaveType")}
              options={[
                { value: "ANNUAL", label: t("leaveType.ANNUAL", "Annual") },
                { value: "SICK", label: t("leaveType.SICK", "Sick") },
                { value: "UNPAID", label: t("leaveType.UNPAID", "Unpaid") },
                { value: "MATERNITY", label: t("leaveType.MATERNITY", "Maternity") },
                { value: "PATERNITY", label: t("leaveType.PATERNITY", "Paternity") }
              ]}
            />
          </Form.Item>
          <Form.Item label={t("common.reason")} name="reason" htmlFor="leave-reason">
            <Input.TextArea id="leave-reason" rows={3} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!employees.length}>
            {t("pages.leave.saveRequest")}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
