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

type Announcement = {
  id: string;
  authorId: string;
  title: string;
  content: string;
  publishAt: string;
  expireAt: string;
  priority: string;
  createdAt: string;
};

const PRIORITY_LABELS: Record<string, string> = {
  LOW: "Thấp", NORMAL: "Bình thường", HIGH: "Cao", URGENT: "Khẩn"
};

export default function AnnouncementsPage() {
  const [items, setItems] = useState<Announcement[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [form] = Form.useForm();

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<Announcement>>("/announcements", { params: { page: 0, size: 50 } });
      setItems(res.data.items ?? []);
    } catch {
      setError("Không tải được danh sách thông báo.");
    } finally { setLoading(false); }
  }, []);

  useEffect(() => { void load(); }, [load]);

  const create = async (values: any) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post("/announcements", values);
      form.resetFields();
      setOpenCreate(false);
      await load();
    } catch { setError("Không tạo được thông báo."); }
    finally { setSaving(false); }
  };

  const deleteAnnouncement = async (id: string) => {
    setSaving(true);
    try {
      await apiClient.delete(`/announcements/${id}`);
      await load();
    } catch { setError("Không xoá được thông báo."); }
    finally { setSaving(false); }
  };

  const columns = useMemo<ColumnsType<Announcement>>(() => [
    { title: "Tiêu đề", dataIndex: "title" },
    {
      title: "Ưu tiên", dataIndex: "priority", width: 120,
      render: (v: string) => (
        <span style={{ color: v === "URGENT" ? "red" : v === "HIGH" ? "orange" : "inherit", fontWeight: v === "URGENT" ? "bold" : "normal" }}>
          {PRIORITY_LABELS[v] ?? v}
        </span>
      )
    },
    { title: "Ngày đăng", dataIndex: "publishAt", width: 180 },
    { title: "Hết hạn", dataIndex: "expireAt", width: 180 },
    { title: "Người đăng", dataIndex: "authorId", width: 120, render: (v: string) => v.slice(0, 8) },
    {
      title: "", key: "actions", width: 80,
      render: (_, row) => (
        <Button size="small" danger loading={saving}
          onClick={() => void deleteAnnouncement(row.id)}>Xoá</Button>
      )
    }
  ], [saving]);

  return (
    <>
      <div className="page-header">
        <h1>Thông báo</h1>
        <p>Quản lý thông báo nội bộ gửi đến toàn thể nhân viên.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>Tạo thông báo</Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Announcement> rowKey="id" loading={loading} columns={columns} dataSource={items} pagination={false} />

      <FormDrawer open={openCreate} title="Tạo thông báo" onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={create}>
          <Form.Item label="Tiêu đề" name="title" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="Nội dung" name="content" rules={[{ required: true }]}>
            <Input.TextArea rows={4} />
          </Form.Item>
          <Form.Item label="Người đăng" name="authorId" rules={[{ required: true }]}>
            <Input placeholder="UUID của người đăng" />
          </Form.Item>
          <Form.Item label="Ngày đăng" name="publishAt">
            <Input placeholder="ISO 8601 (2026-06-04T00:00:00Z)" />
          </Form.Item>
          <Form.Item label="Ngày hết hạn" name="expireAt">
            <Input placeholder="ISO 8601" />
          </Form.Item>
          <Form.Item label="Ưu tiên" name="priority" initialValue="NORMAL">
            <Select options={[
              { value: "LOW", label: "Thấp" },
              { value: "NORMAL", label: "Bình thường" },
              { value: "HIGH", label: "Cao" },
              { value: "URGENT", label: "Khẩn" }
            ]} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>Tạo</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
