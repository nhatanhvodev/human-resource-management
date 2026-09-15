import { UploadOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Modal, Select, Table, Typography } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import { useApiQuery } from "../../shared/api/query";
import type { PageResponse } from "../../shared/api/types";
import { useAccess } from "../../shared/auth/access";

const { Title } = Typography;

type DocumentItem = {
  id: string; originalName: string; fileType: string;
  fileSize: number; category: string; uploadedAt: string;
};

export default function MyDocumentsPage() {
  const { t } = useTranslation();
  const { access } = useAccess();
  // Backend /documents/mine returns a PageResponse (not a raw array).
  const { data, isLoading, refetch } = useApiQuery<PageResponse<DocumentItem>>(
    ['self', 'documents'],
    API.DOCUMENTS_MINE,
    { config: { params: { page: 0, size: 20 } } }
  );
  const [uploadOpen, setUploadOpen] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [form] = Form.useForm();

  const handleUpload = async (values: { category: string }) => {
    setUploading(true);
    setUploadError(null);
    try {
      const fileInput = document.querySelector<HTMLInputElement>("#ess-doc-file");
      const file = fileInput?.files?.[0];
      if (!file) {
        setUploadError(t("pages.documents.noFileSelected"));
        setUploading(false);
        return;
      }
      const formData = new FormData();
      formData.append("file", file);
      // DB-truth employee id (not a spoofable header).
      formData.append("employeeId", access?.employeeId ?? "");
      formData.append("category", values.category);
      await apiClient.post(API.DOCUMENTS_UPLOAD, formData, {
        headers: { "Content-Type": "multipart/form-data" }
      });
      form.resetFields();
      setUploadOpen(false);
      await refetch();
    } catch {
      setUploadError(t("pages.documents.uploadError"));
    } finally {
      setUploading(false);
    }
  };

  const cols: ColumnsType<DocumentItem> = [
    { title: t("pages.documents.originalName"), dataIndex: "originalName" },
    { title: t("pages.documents.fileType"), dataIndex: "fileType" },
    { title: t("pages.documents.fileSize"), dataIndex: "fileSize", render: (v: number) => `${(v / 1024).toFixed(1)} KB` },
    { title: t("pages.documents.category"), dataIndex: "category" },
    { title: t("pages.documents.uploadedAt"), dataIndex: "uploadedAt" }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t("nav.documents")}</Title></div>
      <Button type="primary" icon={<UploadOutlined />} style={{ marginBottom: 16 }} onClick={() => setUploadOpen(true)}>
        {t("ess.upload")}
      </Button>
      <Table rowKey="id" loading={isLoading} dataSource={data?.items ?? []} columns={cols} />

      <Modal title={t("ess.upload")} open={uploadOpen} onCancel={() => { setUploadOpen(false); setUploadError(null); form.resetFields(); }}
        footer={null} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={handleUpload} initialValues={{ category: "OTHER" }}>
          {uploadError && <Alert type="error" showIcon message={uploadError} style={{ marginBottom: 16 }} />}
          <Form.Item label={t("pages.documents.file")} required>
            <input id="ess-doc-file" type="file" />
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
    </div>
  );
}
