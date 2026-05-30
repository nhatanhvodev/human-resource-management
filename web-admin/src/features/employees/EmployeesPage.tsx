import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Segmented, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type Employee = {
  id: string;
  employeeCode: string;
  fullName: string;
  departmentName?: string;
  employmentStatus: string;
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
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);

  useEffect(() => {
    let mounted = true;

    async function loadEmployees() {
      setLoading(true);
      setError(null);
      try {
        const response = await apiClient.get<PageResponse<Employee>>("/employees", {
          params: { page: 0, size: 10, status: status === "ALL" ? undefined : status }
        });
        if (mounted) {
          setData({ ...emptyPage, ...response.data, items: response.data.items ?? [] });
        }
      } catch {
        if (mounted) {
          setError("Unable to load employees. Check token, tenant, and backend connectivity.");
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    void loadEmployees();

    return () => {
      mounted = false;
    };
  }, [status]);

  const columns = useMemo<ColumnsType<Employee>>(
    () => [
      { title: "Ma nhan vien", dataIndex: "employeeCode", width: 160 },
      { title: "Ho va ten", dataIndex: "fullName" },
      { title: "Phong ban", dataIndex: "departmentName", width: 220 },
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
    []
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
        <Form layout="vertical">
          <Form.Item label="Ma nhan vien" htmlFor="employee-code">
            <Input id="employee-code" />
          </Form.Item>
          <Form.Item label="Ho va ten" htmlFor="employee-name">
            <Input id="employee-name" />
          </Form.Item>
          <Form.Item label="Phong ban" htmlFor="employee-department">
            <Input id="employee-department" />
          </Form.Item>
          <Button type="primary" onClick={() => setOpenCreate(false)}>
            Luu nhan vien
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
