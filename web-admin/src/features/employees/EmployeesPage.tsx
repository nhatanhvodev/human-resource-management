import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Segmented, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type Employee = {
  id: string;
  employeeNo: string;
  fullName: string;
  departmentId: string;
  employmentStatus: string;
  hireDate: string;
};

type Department = {
  id: string;
  code: string;
  name: string;
};

const emptyPage: PageResponse<Employee> = {
  items: [],
  page: 0,
  size: 10,
  totalItems: 0,
  totalPages: 0
};

export default function EmployeesPage() {
  const [status, setStatus] = useState<string>("ALL");
  const [data, setData] = useState<PageResponse<Employee>>(emptyPage);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [form] = Form.useForm<{ employeeNo: string; fullName: string; departmentId: string; hireDate: string }>();

  const loadEmployees = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<Employee>>("/employees", {
        params: { page: 0, size: 10, status: status === "ALL" ? undefined : status }
      });
      setData({ ...emptyPage, ...response.data, items: response.data.items ?? [] });
    } catch {
      setError("Unable to load employees. Check token, tenant, and backend connectivity.");
    } finally {
      setLoading(false);
    }
  }, [status]);

  const loadDepartments = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Department>>("/departments", {
        params: { page: 0, size: 100 }
      });
      setDepartments(response.data.items ?? []);
    } catch {
      setDepartments([]);
    }
  }, []);

  useEffect(() => {
    void loadEmployees();
  }, [loadEmployees]);

  useEffect(() => {
    void loadDepartments();
  }, [loadDepartments]);

  const departmentById = useMemo(() => new Map(departments.map((department) => [department.id, department])), [departments]);

  const createEmployee = async (values: { employeeNo: string; fullName: string; departmentId: string; hireDate: string }) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post("/employees", {
        employeeNo: values.employeeNo.trim(),
        fullName: values.fullName.trim(),
        departmentId: values.departmentId,
        hireDate: values.hireDate
      });
      form.resetFields();
      setOpenCreate(false);
      await loadEmployees();
    } catch {
      setError("Unable to create employee. Check required fields, employee code, and department.");
    } finally {
      setSaving(false);
    }
  };

  const columns = useMemo<ColumnsType<Employee>>(
    () => [
      { title: "Ma nhan vien", dataIndex: "employeeNo", width: 160 },
      { title: "Ho va ten", dataIndex: "fullName" },
      {
        title: "Phong ban",
        dataIndex: "departmentId",
        width: 220,
        render: (value: string) => {
          const department = departmentById.get(value);
          return department ? `${department.code} - ${department.name}` : value;
        }
      },
      { title: "Ngay vao", dataIndex: "hireDate", width: 140 },
      {
        title: "Trang thai",
        dataIndex: "employmentStatus",
        width: 160,
        render: (value: string) => <StatusTag value={value} />
      },
      {
        title: "Thao tac",
        key: "actions",
        width: 160,
        render: () => (
          <Space>
            <Button size="small">Sua</Button>
            <Button size="small">Chi tiet</Button>
          </Space>
        )
      }
    ],
    [departmentById]
  );

  return (
    <>
      <div className="page-header">
        <h1>Employees</h1>
        <p>Search employees, review departments, and manage employment status.</p>
      </div>

      <PageToolbar>
        <Segmented
          value={status}
          options={["ALL", "ACTIVE", "INACTIVE"]}
          onChange={(value) => setStatus(String(value))}
        />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
          Them nhan vien
        </Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Employee>
        rowKey="id"
        loading={loading}
        dataSource={data.items}
        columns={columns}
        pagination={{ current: data.page + 1, pageSize: data.size, total: data.totalItems }}
      />

      <FormDrawer open={openCreate} title="Them nhan vien" onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createEmployee}>
          <Form.Item label="Ma nhan vien" name="employeeNo" htmlFor="employee-code" rules={[{ required: true, message: "Nhap ma nhan vien" }]}>
            <Input id="employee-code" />
          </Form.Item>
          <Form.Item label="Ho va ten" name="fullName" htmlFor="employee-name" rules={[{ required: true, message: "Nhap ho va ten" }]}>
            <Input id="employee-name" />
          </Form.Item>
          <Form.Item label="Phong ban" name="departmentId" htmlFor="employee-department" rules={[{ required: true, message: "Chon phong ban" }]}>
            <Select
              id="employee-department"
              placeholder="Chon phong ban"
              options={departments.map((department) => ({
                value: department.id,
                label: `${department.code} - ${department.name}`
              }))}
            />
          </Form.Item>
          <Form.Item label="Ngay vao lam" name="hireDate" htmlFor="employee-hire-date" rules={[{ required: true, message: "Chon ngay vao lam" }]}>
            <Input id="employee-hire-date" type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!departments.length}>
            Luu nhan vien
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
