import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Popconfirm, Space } from "antd";
import type { ColumnsType, TablePaginationConfig } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

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
  const [saving, setSaving] = useState(false);
  const [openCreate, setOpenCreate] = useState(false);
  const [editingDepartment, setEditingDepartment] = useState<Department | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [form] = Form.useForm<{ code: string; name: string }>();

  const loadDepartments = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<Department>>("/departments", {
        params: { page, size: 10, q: keyword || undefined }
      });
      setData({ ...emptyPage, ...response.data, items: response.data.items ?? [] });
    } catch {
      setError("Không tải được danh sách phòng ban. Kiểm tra token, tenant và kết nối backend.");
    } finally {
      setLoading(false);
    }
  }, [keyword, page]);

  useEffect(() => {
    void loadDepartments();
  }, [loadDepartments]);

  const submitDepartment = async (values: { code: string; name: string }) => {
    setSaving(true);
    setError(null);
    try {
      const payload = {
        code: values.code.trim(),
        name: values.name.trim()
      };
      if (editingDepartment) {
        await apiClient.put(`/departments/${editingDepartment.id}`, payload);
      } else {
        await apiClient.post("/departments", payload);
      }
      form.resetFields();
      setOpenCreate(false);
      setEditingDepartment(null);
      await loadDepartments();
    } catch {
      setError(
        editingDepartment
          ? "Không cập nhật được phòng ban. Kiểm tra dữ liệu bắt buộc hoặc mã phòng ban bị trùng."
          : "Không tạo được phòng ban. Kiểm tra dữ liệu bắt buộc hoặc mã phòng ban bị trùng."
      );
    } finally {
      setSaving(false);
    }
  };

  const openEdit = (department: Department) => {
    setEditingDepartment(department);
    form.setFieldsValue({ code: department.code, name: department.name });
    setOpenCreate(true);
  };

  const closeDrawer = () => {
    form.resetFields();
    setEditingDepartment(null);
    setOpenCreate(false);
  };

  const deleteDepartment = async (department: Department) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.delete(`/departments/${department.id}`);
      await loadDepartments();
    } catch {
      setError("Không xóa được phòng ban. Có thể phòng ban vẫn còn nhân viên hoặc bạn thiếu quyền xóa.");
    } finally {
      setSaving(false);
    }
  };

  const columns = useMemo<ColumnsType<Department>>(
    () => [
      { title: "Mã phòng ban", dataIndex: "code", width: 180 },
      { title: "Tên phòng ban", dataIndex: "name" },
      {
        title: "Thao tác",
        key: "actions",
        width: 160,
        render: (_, row) => (
          <Space>
            <Button size="small" onClick={() => openEdit(row)}>
              Sửa
            </Button>
            <Popconfirm
              title="Xóa phòng ban?"
              description="Thao tác này gọi API xóa thật và có thể bị từ chối nếu phòng ban còn dữ liệu liên quan."
              okText="Xóa phòng ban"
              cancelText="Hủy"
              okButtonProps={{ danger: true, loading: saving }}
              onConfirm={() => void deleteDepartment(row)}
            >
              <Button size="small" danger disabled={saving}>
                Xóa
              </Button>
            </Popconfirm>
          </Space>
        )
      }
    ],
    [saving]
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
        <h1>Phòng ban</h1>
        <p>Quản lý mã, tên và cấu trúc phòng ban trong tổ chức.</p>
      </div>

      <PageToolbar>
        <Input.Search
          allowClear
          placeholder="Tìm theo mã hoặc tên"
          style={{ width: 280 }}
          onSearch={(value) => {
            setPage(0);
            setKeyword(value.trim());
          }}
        />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
          Thêm phòng ban
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

      <FormDrawer open={openCreate} title={editingDepartment ? "Cập nhật phòng ban" : "Thêm phòng ban"} onClose={closeDrawer}>
        <Form form={form} layout="vertical" onFinish={submitDepartment}>
          <Form.Item label="Mã phòng ban" name="code" htmlFor="department-code" rules={[{ required: true, message: "Nhập mã phòng ban" }]}>
            <Input id="department-code" />
          </Form.Item>
          <Form.Item label="Tên phòng ban" name="name" htmlFor="department-name" rules={[{ required: true, message: "Nhập tên phòng ban" }]}>
            <Input id="department-name" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            {editingDepartment ? "Lưu thay đổi" : "Tạo mới"}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
