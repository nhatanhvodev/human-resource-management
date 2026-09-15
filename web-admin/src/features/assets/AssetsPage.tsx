import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { API } from "../../shared/api/endpoints";
import { useApiMutation, useApiQuery } from "../../shared/api/query";
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
  const { t, i18n } = useTranslation();
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [openAssign, setOpenAssign] = useState(false);
  const [selectedAssetId, setSelectedAssetId] = useState<string | null>(null);
  const [form] = Form.useForm();
  const [assignForm] = Form.useForm();

  const assetsQuery = useApiQuery<PageResponse<Asset>>(["assets"], API.ASSETS, {
    config: { params: { page: 0, size: 50 } }
  });
  const employeesQuery = useApiQuery<PageResponse<Employee>>(["employees", "active"], API.EMPLOYEES, {
    config: { params: { page: 0, size: 100, status: "ACTIVE" } }
  });

  const assets = (assetsQuery.data as PageResponse<Asset> | undefined)?.items ?? [];
  const employees = (employeesQuery.data as PageResponse<Employee> | undefined)?.items ?? [];
  const loading = assetsQuery.isLoading;
  const visibleError = error ?? (assetsQuery.isError ? t("pages.assets.loadError") : null);

  const assetsMutation = useApiMutation({ invalidateKeys: [["assets"]] });
  const saving = assetsMutation.isPending;

  const createAsset = async (values: any) => {
    setError(null);
    try {
      await assetsMutation.mutateAsync({ url: API.ASSETS, body: values });
      form.resetFields();
      setOpenCreate(false);
    } catch { setError(t("pages.assets.createError")); }
  };

  const assignAsset = async (values: { employeeId: string }) => {
    if (!selectedAssetId) return;
    try {
      await assetsMutation.mutateAsync({ url: `${API.ASSETS}/${selectedAssetId}/assign`, body: values });
      assignForm.resetFields();
      setOpenAssign(false);
    } catch { setError(t("pages.assets.assignError")); }
  };

  const unassignAsset = async (id: string) => {
    try {
      await assetsMutation.mutateAsync({ url: `${API.ASSETS}/${id}/unassign`, body: null });
    } catch { setError(t("pages.assets.unassignError")); }
  };

  const deleteAsset = async (id: string) => {
    try {
      await assetsMutation.mutateAsync({ url: `${API.ASSETS}/${id}`, method: "delete" });
    } catch { setError(t("pages.assets.deleteError")); }
  };

  const columns = useMemo<ColumnsType<Asset>>(() => [
    { title: t("common.name"), dataIndex: "name" },
    { title: t("pages.documents.category"), dataIndex: "category", width: 120 },
    { title: "S/N", dataIndex: "serialNumber", width: 120 },
    {
      title: t("common.status"), dataIndex: "status", width: 130,
      render: (v: string) => <StatusTag value={v} />
    },
    {
      title: t("pages.assets.assignTo"), dataIndex: "assignedTo", width: 120,
      render: (v: string | null) => v ? employees.find(e => e.id === v)?.fullName ?? "-" : "-"
    },
    {
      title: t("pages.assets.purchaseDate"), dataIndex: "purchaseDate", width: 110
    },
    {
      title: t("pages.assets.purchasePrice"), dataIndex: "purchasePrice", width: 120,
      render: (v: number) => v ? `${v.toLocaleString(i18n.language === "en" ? "en-US" : "vi-VN")} VND` : "-"
    },
    {
      title: t("common.actions"), key: "actions", width: 240,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => { setSelectedAssetId(row.id); setOpenAssign(true); }}>
            {t("pages.assets.assign")}
          </Button>
          <Button size="small" disabled={!row.assignedTo} loading={saving}
            onClick={() => void unassignAsset(row.id)}>{t("pages.assets.unassign")}</Button>
          <Button size="small" danger loading={saving}
            onClick={() => void deleteAsset(row.id)}>{t("common.delete")}</Button>
        </Space>
      )
    }
  ], [employees, saving, t, i18n.language]);

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.assets.title")}</h1>
        <p>{t("pages.assets.subtitle")}</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>{t("pages.assets.add")}</Button>
      </PageToolbar>

      {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Asset> rowKey="id" loading={loading} columns={columns} dataSource={assets} pagination={false} />

      <FormDrawer open={openCreate} title={t("pages.assets.add")} onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createAsset}>
          <Form.Item label={t("common.name")} name="name" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label={t("pages.documents.category")} name="category">
            <Input />
          </Form.Item>
          <Form.Item label={t("pages.assets.serialNumber")} name="serialNumber">
            <Input />
          </Form.Item>
          <Form.Item label={t("pages.assets.purchaseDate")} name="purchaseDate">
            <Input type="date" />
          </Form.Item>
          <Form.Item label={t("pages.assets.purchasePriceInput")} name="purchasePrice">
            <InputNumber min={0} style={{ width: "100%" }} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>{t("common.create")}</Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={openAssign} title={t("pages.assets.assignTitle")} onClose={() => setOpenAssign(false)}>
        <Form form={assignForm} layout="vertical" onFinish={assignAsset}>
          <Form.Item label={t("common.employee")} name="employeeId" rules={[{ required: true }]}>
            <Select placeholder={t("pages.assets.selectEmployee")}
              options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>{t("pages.assets.assign")}</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
