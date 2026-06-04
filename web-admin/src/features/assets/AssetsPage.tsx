import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type Asset = {
  id: string;
  name: string;
  category: string;
  serialNumber: string;
  status: string;
  assignedTo: string | null;
  assignedDate: string | null;
  purchaseDate: string;
  purchasePrice: number;
};

type Employee = { id: string; employeeNo: string; fullName: string };

export default function AssetsPage() {
  const [assets, setAssets] = useState<Asset[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [openAssign, setOpenAssign] = useState(false);
  const [selectedAssetId, setSelectedAssetId] = useState<string | null>(null);
  const [form] = Form.useForm();
  const [assignForm] = Form.useForm();

  const loadAssets = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<Asset>>("/assets", { params: { page: 0, size: 50 } });
      setAssets(res.data.items ?? []);
    } catch {
      setError("Không tải được danh sách tài sản.");
    } finally { setLoading(false); }
  }, []);

  const loadEmployees = useCallback(async () => {
    try {
      const res = await apiClient.get<PageResponse<Employee>>("/employees", { params: { page: 0, size: 100, status: "ACTIVE" } });
      setEmployees(res.data.items ?? []);
    } catch { setEmployees([]); }
  }, []);

  useEffect(() => { void loadAssets(); }, [loadAssets]);
  useEffect(() => { void loadEmployees(); }, [loadEmployees]);

  const createAsset = async (values: any) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post("/assets", values);
      form.resetFields();
      setOpenCreate(false);
      await loadAssets();
    } catch { setError("Không tạo được tài sản."); }
    finally { setSaving(false); }
  };

  const assignAsset = async (values: { employeeId: string }) => {
    if (!selectedAssetId) return;
    setSaving(true);
    try {
      await apiClient.post(`/assets/${selectedAssetId}/assign`, values);
      assignForm.resetFields();
      setOpenAssign(false);
      await loadAssets();
    } catch { setError("Không gán được tài sản."); }
    finally { setSaving(false); }
  };

  const unassignAsset = async (id: string) => {
    setSaving(true);
    try {
      await apiClient.post(`/assets/${id}/unassign`);
      await loadAssets();
    } catch { setError("Không thu hồi được tài sản."); }
    finally { setSaving(false); }
  };

  const deleteAsset = async (id: string) => {
    setSaving(true);
    try {
      await apiClient.delete(`/assets/${id}`);
      await loadAssets();
    } catch { setError("Không xoá được tài sản."); }
    finally { setSaving(false); }
  };

  const columns = useMemo<ColumnsType<Asset>>(() => [
    { title: "Tên", dataIndex: "name" },
    { title: "Danh mục", dataIndex: "category", width: 120 },
    { title: "S/N", dataIndex: "serialNumber", width: 120 },
    {
      title: "Trạng thái", dataIndex: "status", width: 130,
      render: (v: string) => <StatusTag value={v} />
    },
    {
      title: "Gán cho", dataIndex: "assignedTo", width: 120,
      render: (v: string | null) => v ? employees.find(e => e.id === v)?.fullName ?? v.slice(0, 8) : "-"
    },
    {
      title: "Ngày mua", dataIndex: "purchaseDate", width: 110
    },
    {
      title: "Giá", dataIndex: "purchasePrice", width: 120,
      render: (v: number) => v ? v.toLocaleString("vi-VN") + " VNĐ" : "-"
    },
    {
      title: "Thao tác", key: "actions", width: 240,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => { setSelectedAssetId(row.id); setOpenAssign(true); }}>
            Gán
          </Button>
          <Button size="small" disabled={!row.assignedTo} loading={saving}
            onClick={() => void unassignAsset(row.id)}>Thu hồi</Button>
          <Button size="small" danger loading={saving}
            onClick={() => void deleteAsset(row.id)}>Xoá</Button>
        </Space>
      )
    }
  ], [employees, saving]);

  return (
    <>
      <div className="page-header">
        <h1>Tài sản</h1>
        <p>Quản lý tài sản công ty: gán, thu hồi và theo dõi trạng thái.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>Thêm tài sản</Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Asset> rowKey="id" loading={loading} columns={columns} dataSource={assets} pagination={false} />

      <FormDrawer open={openCreate} title="Thêm tài sản" onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createAsset}>
          <Form.Item label="Tên" name="name" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="Danh mục" name="category">
            <Input />
          </Form.Item>
          <Form.Item label="Số serial" name="serialNumber">
            <Input />
          </Form.Item>
          <Form.Item label="Ngày mua" name="purchaseDate">
            <Input type="date" />
          </Form.Item>
          <Form.Item label="Giá mua" name="purchasePrice">
            <InputNumber min={0} style={{ width: "100%" }} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>Tạo</Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={openAssign} title="Gán tài sản" onClose={() => setOpenAssign(false)}>
        <Form form={assignForm} layout="vertical" onFinish={assignAsset}>
          <Form.Item label="Nhân viên" name="employeeId" rules={[{ required: true }]}>
            <Select placeholder="Chọn nhân viên"
              options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>Gán</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
