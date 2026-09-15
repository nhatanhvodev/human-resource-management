import { DeleteOutlined, UploadOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Modal, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import type { UseQueryResult } from "@tanstack/react-query";

import { API } from "../../shared/api/endpoints";
// NOTE: `as UseQueryResult<...>` restores useApiQuery's documented return type, which currently
// degrades under the installed @tanstack/react-query 5.102.8 (overload error inside query.ts).
// The cast is type-only and has zero runtime effect.
import { useApiMutation, useApiQuery } from "../../shared/api/query";
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
  const [error, setError] = useState<string | null>(null);
  const [uploadOpen, setUploadOpen] = useState(false);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [form] = Form.useForm();

  const documentsQuery = useApiQuery<PageResponse<DocumentItem>>(["documents", "list"], API.DOCUMENTS, {
    config: { params: { page: 0, size: 100 } }
  }) as UseQueryResult<PageResponse<DocumentItem>, unknown>;
  const employeesQuery = useApiQuery<PageResponse<Employee>>(["documents", "employees"], API.EMPLOYEES, {
    config: { params: { page: 0, size: 200, status: "ACTIVE" } }
  }) as UseQueryResult<PageResponse<Employee>, unknown>;

  const items = documentsQuery.data?.items ?? [];
  const loading = documentsQuery.isLoading;
  const loadError = documentsQuery.isError ? t("pages.documents.loadError") : null;
  const visibleError = error ?? loadError;
  const employees = employeesQuery.data?.items ?? [];

  const deleteMutation = useApiMutation({
    invalidateKeys: [["documents", "list"]]
  });
  const uploadMutation = useApiMutation<unknown, FormData>({
    invalidateKeys: [["documents", "list"]]
  });
  const saving = deleteMutation.isPending;
  const uploading = uploadMutation.isPending;

  const employeeById = useMemo(() => new Map(employees.map((employee) => [employee.id, employee])), [employees]);

  const handleDelete = async (id: string) => {
    setError(null);
    try {
      await deleteMutation.mutateAsync({ url: `${API.DOCUMENTS}/${id}`, method: "delete" });
    } catch {
      setError(t("pages.documents.deleteError"));
    }
  };

  const handleUpload = async (values: { employeeId: string; category: string }) => {
    setUploadError(null);
    try {
      const fileInput = document.querySelector<HTMLInputElement>("#admin-doc-file");
      const file = fileInput?.files?.[0];
      if (!file) {
        setUploadError(t("pages.documents.noFileSelected"));
        return;
      }
      const formData = new FormData();
      formData.append("file", file);
      formData.append("employeeId", values.employeeId);
      formData.append("category", values.category);
      await uploadMutation.mutateAsync({
        url: API.DOCUMENTS_UPLOAD,
        body: formData,
        config: {
          headers: { "Content-Type": "multipart/form-data" }
        }
      });
      form.resetFields();
      setUploadOpen(false);
    } catch {
      setUploadError(t("pages.documents.uploadError"));
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
      {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}
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
