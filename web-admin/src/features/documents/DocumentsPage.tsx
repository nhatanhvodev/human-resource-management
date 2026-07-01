import { DeleteOutlined, UploadOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Modal, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
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

type Employee = { id: string; employeeNo: string; fullName: string };

export default function DocumentsPage() {
  const { t } = useTranslation();
  const [items, setItems] = useState<DocumentItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [uploadOpen, setUploadOpen] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [form] = Form.useForm();

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<DocumentItem>>(API.DOCUMENTS, {
        params: { page: 0, size: 100 }
      });
      setItems(response.data.items ?? []);
    } catch {
      setError(t("pages.documents.loadError"));
    } finally {
      setLoading(false);
    }
  }, [t]);

  const loadEmployees = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Employee>>(API.EMPLOYEES, {
        params: { page: 0, size: 200, status: "ACTIVE" }
      });
      setEmployees(response.data.items ?? []);
    } catch {
      setEmployees([]);
    }
  }, []);

  useEffect(() => { void load(); }, [load]);
  useEffect(() => { void loadEmployees(); }, [loadEmployees]);

  const employeeById = useMemo(() => new Map(employees.map((employee) => [employee.id, employee])), [employees]);

  const handleDelete = async (id: string) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.delete(`${API.DOCUMENTS}/${id}`);
      await load();
    } catch {
      setError(t("pages.documents.deleteError"));
    } finally {
      setSaving(false);
    }
  };

  const handleUpload = async (values: { employeeId: string; category: string }) => {
    setUploading(true);
    setUploadError(null);
    try {
      const fileInput = document.querySelector<HTMLInputElement>("#admin-doc-file");
      const file = fileInput?.files?.[0];
      if (!file) {
        setUploadError(t("pages.documents.noFileSelected"));
        setUploading(false);
        return;
      }
      const formData = new FormData();
      formData.append("file", file);
      formData.append("employeeId", values.employeeId);
      formData.append("category", values.category);
      await apiClient.post(API.DOCUMENTS_UPLOAD, formData, {
        headers: { "Content-Type": "multipart/form-data" }
      });
      form.resetFields();
      setUploadOpen(false);
      await load();
    } catch {
      setUploadError(t("pages.documents.uploadError"));
    } finally {
      setUploading(false);
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
    {
      title: t("common.employee"),
      dataIndex: "employeeId",
      width: 200,
      render: (v: string) => {
        const employee = employeeById.get(v);
        return employee ? `${employee.employeeNo} - ${employee.fullName}` : "-";
      }
    },
    { title: t("pages.documents.uploadedAt"), dataIndex: "uploadedAt", width: 180 },
    {
      title: "", key: "actions", width: 140,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => window.open(`/api/v1/documents/${row.id}/download`, '_blank')}>
            {t("common.download")}
          </Button>
          <Button size="small" danger icon={<DeleteOutlined />} loading={saving}
            onClick={() => void handleDelete(row.id)} />
        </Space>
      )
    }
  ], [employeeById, saving, t]);

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.documents.title")}</h1>
        <p>{t("pages.documents.subtitle")}</p>
      </div>
      <PageToolbar>
        <Button type="primary" icon={<UploadOutlined />} onClick={() => setUploadOpen(true)}>
          {t("ess.upload")}
        </Button>
        <span>{t("pages.documents.count", { count: items.length })}</span>
      </PageToolbar>
      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}
      <AppTable<DocumentItem> rowKey="id" loading={loading} columns={columns} dataSource={items} pagination={false} />

      <Modal title={t("ess.upload")} open={uploadOpen} onCancel={() => { setUploadOpen(false); setUploadError(null); form.resetFields(); }}
        footer={null} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={handleUpload} initialValues={{ category: "OTHER" }}>
          {uploadError && <Alert type="error" showIcon message={uploadError} style={{ marginBottom: 16 }} />}
          <Form.Item label={t("common.employee")} name="employeeId" rules={[{ required: true, message: t("pages.leave.selectEmployee") }]}>
            <Select
              placeholder={t("pages.leave.selectEmployee")}
              options={employees.map((e) => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))}
              showSearch
              filterOption={(input, option) => (option?.label as string ?? "").toLowerCase().includes(input.toLowerCase())}
            />
          </Form.Item>
          <Form.Item label={t("pages.documents.file")} required>
            <input id="admin-doc-file" type="file" />
          </Form.Item>
          <Form.Item label={t("pages.documents.category")} name="category" rules={[{ required: true }]}>
            <Select
              options={[
                { value: "CONTRACT", label: t("docCategory.CONTRACT", "Contract") },
                { value: "CV", label: t("docCategory.CV", "CV") },
                { value: "CERTIFICATE", label: t("docCategory.CERTIFICATE", "Certificate") },
                { value: "OTHER", label: t("docCategory.OTHER", "Other") }
              ]}
            />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={uploading} block>
            {t("ess.upload")}
          </Button>
        </Form>
      </Modal>
    </>
  );
}
