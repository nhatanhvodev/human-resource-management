import { DeleteOutlined } from "@ant-design/icons";
import { Alert, Button, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { PageToolbar } from "../../shared/ui/PageToolbar";

type DocumentItem = {
  id: string;
  employeeId: string;
  fileName: string;
  originalName: string;
  fileType: string;
  fileSize: number;
  category: string;
  uploadedAt: string;
};

export default function DocumentsPage() {
  const { t } = useTranslation();
  const [items, setItems] = useState<DocumentItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<DocumentItem>>("/documents", {
        params: { page: 0, size: 100 }
      });
      setItems(response.data.items ?? []);
    } catch {
      setError(t("pages.documents.loadError"));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => { void load(); }, [load]);

  const handleDelete = async (id: string) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.delete(`/documents/${id}`);
      await load();
    } catch {
      setError(t("pages.documents.deleteError"));
    } finally {
      setSaving(false);
    }
  };

  const formatSize = (bytes: number) => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  };

  const columns = useMemo<ColumnsType<DocumentItem>>(() => [
    { title: t("pages.documents.originalName"), dataIndex: "originalName" },
    { title: t("pages.documents.fileType"), dataIndex: "fileType", width: 100 },
    { title: t("pages.documents.fileSize"), dataIndex: "fileSize", width: 100, render: (v: number) => formatSize(v) },
    { title: t("pages.documents.category"), dataIndex: "category", width: 120 },
    { title: t("common.employee"), dataIndex: "employeeId", width: 120, render: (v: string) => v.slice(0, 8) },
    { title: t("pages.documents.uploadedAt"), dataIndex: "uploadedAt", width: 180 },
    {
      title: "", key: "actions", width: 80,
      render: (_, row) => (
        <Button size="small" danger icon={<DeleteOutlined />} loading={saving}
          onClick={() => void handleDelete(row.id)} />
      )
    }
  ], [saving, t]);

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.documents.title")}</h1>
        <p>{t("pages.documents.subtitle")}</p>
      </div>
      <PageToolbar>
        <Space />
        <span>{t("pages.documents.count", { count: items.length })}</span>
      </PageToolbar>
      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}
      <AppTable<DocumentItem> rowKey="id" loading={loading} columns={columns} dataSource={items} pagination={false} />
    </>
  );
}
