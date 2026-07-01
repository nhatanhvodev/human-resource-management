import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Drawer, Form, Input, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type Announcement = {
  id: string;
  authorId: string;
  authorName?: string;
  title: string;
  content: string;
  publishAt: string;
  expireAt: string;
  priority: string;
  createdAt: string;
};

export default function AnnouncementsPage() {
  const { t } = useTranslation();
  const [items, setItems] = useState<Announcement[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [detailItem, setDetailItem] = useState<Announcement | null>(null);
  const [form] = Form.useForm();

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<Announcement>>(API.ANNOUNCEMENTS, { params: { page: 0, size: 50 } });
      setItems(res.data.items ?? []);
    } catch {
      setError(t("pages.announcements.loadError"));
    } finally { setLoading(false); }
  }, [t]);

  useEffect(() => { void load(); }, [load]);

  const create = async (values: any) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post(API.ANNOUNCEMENTS, values);
      form.resetFields();
      setOpenCreate(false);
      await load();
    } catch { setError(t("pages.announcements.createError")); }
    finally { setSaving(false); }
  };

  const deleteAnnouncement = async (id: string) => {
    setSaving(true);
    try {
      await apiClient.delete(`${API.ANNOUNCEMENTS}/${id}`);
      await load();
    } catch { setError(t("pages.announcements.deleteError")); }
    finally { setSaving(false); }
  };

  const columns = useMemo<ColumnsType<Announcement>>(() => [
    { title: t("pages.announcements.announcementTitle"), dataIndex: "title" },
    {
      title: t("pages.announcements.priority"), dataIndex: "priority", width: 120,
      render: (v: string) => (
        <span style={{ color: v === "URGENT" ? "red" : v === "HIGH" ? "orange" : "inherit", fontWeight: v === "URGENT" ? "bold" : "normal" }}>
          {t(`priority.${v}`, v)}
        </span>
      )
    },
    { title: t("pages.announcements.publishAt"), dataIndex: "publishAt", width: 180 },
    { title: t("pages.announcements.expireAt"), dataIndex: "expireAt", width: 180 },
    { title: t("pages.announcements.author"), dataIndex: "authorName", width: 180, render: (v: string) => v || "-" },
    {
      title: "", key: "actions", width: 160,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => setDetailItem(row)}>{t("common.viewDetail")}</Button>
          <Button size="small" danger loading={saving}
            onClick={() => void deleteAnnouncement(row.id)}>{t("common.delete")}</Button>
        </Space>
      )
    }
  ], [saving, t]);

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.announcements.title")}</h1>
        <p>{t("pages.announcements.subtitle")}</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>{t("pages.announcements.create")}</Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Announcement> rowKey="id" loading={loading} columns={columns} dataSource={items} pagination={false} />

      <FormDrawer open={openCreate} title={t("pages.announcements.create")} onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={create}>
          <Form.Item label={t("pages.announcements.announcementTitle")} name="title" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label={t("common.content")} name="content" rules={[{ required: true }]}>
            <Input.TextArea rows={4} />
          </Form.Item>
          <Form.Item label={t("pages.announcements.publishAt")} name="publishAt">
            <Input placeholder="ISO 8601 (2026-06-04T00:00:00Z)" />
          </Form.Item>
          <Form.Item label={t("pages.announcements.expireAt")} name="expireAt">
            <Input placeholder="ISO 8601" />
          </Form.Item>
          <Form.Item label={t("pages.announcements.priority")} name="priority" initialValue="NORMAL">
            <Select options={[
              { value: "LOW", label: t("priority.LOW") },
              { value: "NORMAL", label: t("priority.NORMAL") },
              { value: "HIGH", label: t("priority.HIGH") },
              { value: "URGENT", label: t("priority.URGENT") }
            ]} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>{t("common.create")}</Button>
        </Form>
      </FormDrawer>

      <Drawer title={t("pages.announcements.announcementDetail")} width="min(520px, calc(100vw - 32px))" open={!!detailItem} onClose={() => setDetailItem(null)}>
        {detailItem && (
          <div>
            <h2>{detailItem.title}</h2>
            <p style={{ color: '#888', marginBottom: 16 }}>
              {detailItem.authorName ? `${t("pages.announcements.author")}: ${detailItem.authorName}  |  ` : ''}
              {t("pages.announcements.publishAt")}: {detailItem.publishAt}  |  {t("pages.announcements.priority")}: {t(`priority.${detailItem.priority}`, detailItem.priority)}
            </p>
            <div style={{ whiteSpace: 'pre-wrap' }}>{detailItem.content}</div>
          </div>
        )}
      </Drawer>
    </>
  );
}
