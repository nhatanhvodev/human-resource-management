import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Space } from "antd";
import type { ColumnsType, TablePaginationConfig } from "antd/es/table";
import { useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";

type Department = {
  id: string;
  code: string;
  name: string;
};

const emptyPage: PageResponse<Department> = {
  items: [],
  page: 0,
  size: 10,
  totalItems: 0,
  totalPages: 0
};

export default function DepartmentsPage() {
  const [keyword, setKeyword] = useState("");
  const [page, setPage] = useState(0);
  const [data, setData] = useState<PageResponse<Department>>(emptyPage);
  const [loading, setLoading] = useState(false);
  const [openCreate, setOpenCreate] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    async function loadDepartments() {
      setLoading(true);
      setError(null);
      try {
        const response = await apiClient.get<PageResponse<Department>>("/departments", {
          params: { page, size: 10, q: keyword || undefined }
        });
        if (mounted) {
          setData({ ...emptyPage, ...response.data, items: response.data.items ?? [] });
        }
      } catch {
        if (mounted) {
          setError("Unable to load departments. Check token, tenant, and backend connectivity.");
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    void loadDepartments();

    return () => {
      mounted = false;
    };
  }, [keyword, page]);

  const columns = useMemo<ColumnsType<Department>>(
    () => [
      { title: "Ma phong ban", dataIndex: "code", width: 180 },
      { title: "Ten phong ban", dataIndex: "name" },
      {
        title: "Thao tac",
        key: "actions",
        width: 160,
        render: () => (
          <Space>
            <Button size="small">Sua</Button>
            <Button size="small" danger>
              Xoa
            </Button>
          </Space>
        )
      }
    ],
    []
  );

  const pagination: TablePaginationConfig = {
    current: data.page + 1,
    pageSize: data.size,
    total: data.totalItems,
    onChange: (nextPage) => setPage(nextPage - 1)
  };

  return (
    <>
      <div className="page-header">
        <h1>Departments</h1>
        <p>Manage department codes, names, and organization structure.</p>
      </div>

      <PageToolbar>
        <Input.Search
          allowClear
          placeholder="Tim theo ma hoac ten"
          style={{ width: 280 }}
          onSearch={(value) => {
            setPage(0);
            setKeyword(value.trim());
          }}
        />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
          Them phong ban
        </Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Department>
        rowKey="id"
        loading={loading}
        dataSource={data.items}
        columns={columns}
        pagination={pagination}
      />

      <FormDrawer open={openCreate} title="Them phong ban" onClose={() => setOpenCreate(false)}>
        <Form layout="vertical">
          <Form.Item label="Ma phong ban" htmlFor="department-code">
            <Input id="department-code" />
          </Form.Item>
          <Form.Item label="Ten phong ban" htmlFor="department-name">
            <Input id="department-name" />
          </Form.Item>
          <Button type="primary">Tao moi</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
