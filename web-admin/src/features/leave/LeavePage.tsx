import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Select, Space } from "antd";
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

export default function LeavePage() {
  const [items, setItems] = useState<LeaveRequest[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [form] = Form.useForm<{ employeeId: string; fromDate: string; toDate: string }>();

  const loadLeaveRequests = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<LeaveRequest>>("/leave-requests", {
        params: { page: 0, size: 10 }
      });
      setItems(response.data.items ?? []);
    } catch {
      setError("Unable to load leave requests. Check token, tenant, and backend connectivity.");
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

  useEffect(() => {
    void loadLeaveRequests();
  }, [loadLeaveRequests]);

  useEffect(() => {
    void loadEmployees();
  }, [loadEmployees]);

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
      setError("Unable to create leave request. Check employee and date range.");
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
      setError(`Unable to ${action} leave request.`);
    } finally {
      setSaving(false);
    }
  };

  const columns = useMemo<ColumnsType<LeaveRequest>>(
    () => [
      {
        title: "Employee",
        dataIndex: "employeeName",
        render: (value: string | undefined, row) => {
          const employee = row.employeeId ? employeeById.get(row.employeeId) : undefined;
          return value ?? employee?.fullName ?? (row.employeeId ? row.employeeId.slice(0, 8) : "");
        }
      },
      {
        title: "Type",
        dataIndex: "leaveType",
        width: 160,
        render: (value?: string) => value ?? "Annual"
      },
      {
        title: "Start",
        dataIndex: "fromDate",
        width: 150,
        render: (value: string | undefined, row) => value ?? row.startDate
      },
      {
        title: "End",
        dataIndex: "toDate",
        width: 150,
        render: (value: string | undefined, row) => value ?? row.endDate
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
                Approve
              </Button>
              <Button
                size="small"
                danger
                disabled={!isPending || saving}
                onClick={() => void transitionLeaveRequest(row.id, "reject")}
              >
                Reject
              </Button>
            </Space>
          );
        }
      }
    ],
    [employeeById, saving]
  );

  return (
    <>
      <div className="page-header">
        <h1>Leave</h1>
        <p>Review leave requests and manage approval decisions.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
          Create leave request
        </Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<LeaveRequest>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={items}
        pagination={false}
      />

      <FormDrawer open={openCreate} title="Create leave request" onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createLeaveRequest}>
          <Form.Item label="Employee" name="employeeId" htmlFor="leave-employee" rules={[{ required: true, message: "Select employee" }]}>
            <Select
              id="leave-employee"
              placeholder="Select employee"
              options={employees.map((employee) => ({
                value: employee.id,
                label: `${employee.employeeNo} - ${employee.fullName}`
              }))}
            />
          </Form.Item>
          <Form.Item label="Start date" name="fromDate" htmlFor="leave-start" rules={[{ required: true, message: "Select start date" }]}>
            <Input id="leave-start" type="date" />
          </Form.Item>
          <Form.Item label="End date" name="toDate" htmlFor="leave-end" rules={[{ required: true, message: "Select end date" }]}>
            <Input id="leave-end" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!employees.length}>
            Save request
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
