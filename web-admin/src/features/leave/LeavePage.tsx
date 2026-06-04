import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

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
      setError("Không tải được danh sách nghỉ phép. Kiểm tra token, tenant và kết nối backend.");
    } finally {
      setLoading(false);
    }
  }, []);

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
      setError("Không tạo được đơn nghỉ phép. Kiểm tra nhân viên và khoảng ngày.");
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
      setError(action === "approve" ? "Không duyệt được đơn nghỉ phép." : "Không từ chối được đơn nghỉ phép.");
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
      setError(action === "approve" ? "Không duyệt được đơn tăng ca." : "Không từ chối được đơn tăng ca.");
    } finally {
      setSaving(false);
    }
  };

  const requestColumns = useMemo<ColumnsType<LeaveRequest>>(
    () => [
      {
        title: "Nhân viên",
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: "Loại nghỉ",
        dataIndex: "leaveType",
        width: 160,
        render: (value?: string) => value ?? "Chưa có dữ liệu từ API"
      },
      {
        title: "Từ ngày",
        dataIndex: "fromDate",
        width: 150,
        render: (value: string | undefined, row) => value ?? row.startDate
      },
      {
        title: "Đến ngày",
        dataIndex: "toDate",
        width: 150,
        render: (value: string | undefined, row) => value ?? row.endDate
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
                Duyệt
              </Button>
              <Button
                size="small"
                danger
                disabled={!isPending || saving}
                onClick={() => void transitionLeaveRequest(row.id, "reject")}
              >
                Từ chối
              </Button>
            </Space>
          );
        }
      }
    ],
    [employeeById, saving]
  );

  const balanceColumns = useMemo<ColumnsType<LeaveBalance>>(
    () => [
      {
        title: "Nhân viên",
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: "Loại phép",
        dataIndex: "leaveType",
        width: 160
      },
      {
        title: "Năm",
        dataIndex: "year",
        width: 80
      },
      {
        title: "Tổng số ngày",
        dataIndex: "totalDays",
        width: 130
      },
      {
        title: "Đã dùng",
        dataIndex: "usedDays",
        width: 100
      },
      {
        title: "Chờ duyệt",
        dataIndex: "pendingDays",
        width: 110
      }
    ],
    [employeeById]
  );

  const holidayColumns = useMemo<ColumnsType<Holiday>>(
    () => [
      {
        title: "Tên ngày lễ",
        dataIndex: "name",
        width: 220
      },
      {
        title: "Ngày",
        dataIndex: "date",
        width: 150
      },
      {
        title: "Mô tả",
        dataIndex: "description",
        render: (value?: string) => value ?? "-"
      },
      {
        title: "Lặp lại hàng năm",
        dataIndex: "isRecurringYearly",
        width: 160,
        render: (value: boolean) => (value ? "Có" : "Không")
      }
    ],
    []
  );

  const overtimeColumns = useMemo<ColumnsType<OvertimeRecord>>(
    () => [
      {
        title: "Nhân viên",
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: "Ngày",
        dataIndex: "date",
        width: 150
      },
      {
        title: "Số giờ",
        dataIndex: "hours",
        width: 100
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
                Duyệt
              </Button>
              <Button
                size="small"
                danger
                disabled={!isPending || saving}
                onClick={() => void transitionOvertime(row.id, "reject")}
              >
                Từ chối
              </Button>
            </Space>
          );
        }
      }
    ],
    [employeeById, saving]
  );

  const tabItems = [
    {
      key: "requests",
      label: "Đơn nghỉ phép",
      children: (
        <>
          <PageToolbar>
            <Space />
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
              Tạo đơn nghỉ phép
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
      label: "Số dư phép",
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
      label: "Ngày lễ",
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
      label: "Tăng ca",
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
        <h1>Nghỉ phép</h1>
        <p>Rà soát đơn nghỉ phép và xử lý quyết định duyệt hoặc từ chối.</p>
      </div>

      <Tabs activeKey={activeTab} onChange={setActiveTab} items={tabItems} />

      <FormDrawer open={openCreate} title="Tạo đơn nghỉ phép" onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createLeaveRequest}>
          <Form.Item label="Nhân viên" name="employeeId" htmlFor="leave-employee" rules={[{ required: true, message: "Chọn nhân viên" }]}>
            <Select
              id="leave-employee"
              placeholder="Chọn nhân viên"
              options={employees.map((employee) => ({
                value: employee.id,
                label: `${employee.employeeNo} - ${employee.fullName}`
              }))}
            />
          </Form.Item>
          <Form.Item label="Từ ngày" name="fromDate" htmlFor="leave-start" rules={[{ required: true, message: "Chọn ngày bắt đầu" }]}>
            <Input id="leave-start" type="date" />
          </Form.Item>
          <Form.Item label="Đến ngày" name="toDate" htmlFor="leave-end" rules={[{ required: true, message: "Chọn ngày kết thúc" }]}>
            <Input id="leave-end" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!employees.length}>
            Lưu đơn
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
