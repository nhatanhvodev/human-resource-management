import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Popconfirm, Space, Tabs } from "antd";
import type { ColumnsType, TablePaginationConfig } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import OrgChart from "./OrgChart";

type Department = {
  id: string;
  code: string;
  name: string;
};

const emptyPage: PageResponse<Department> = {
  items: [],
  page: 0,
  size: 20,
  totalItems: 0,
  totalPages: 0
};

export default function DepartmentsPage() {
  const { t } = useTranslation();
  const [keyword, setKeyword] = useState("");
  const [page, setPage] = useState(0);
  const [pageSize, setPageSize] = useState(20);
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
      const response = await apiClient.get<PageResponse<Department>>(API.DEPARTMENTS, {
        params: { page, size: pageSize, q: keyword || undefined }
      });
      setData({ ...emptyPage, ...response.data, items: response.data.items ?? [] });
    } catch {
      setError(t("pages.departments.loadError"));
    } finally {
      setLoading(false);
    }
  }, [keyword, page, pageSize, t]);

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
        await apiClient.put(`${API.DEPARTMENTS}/${editingDepartment.id}`, payload);
      } else {
        await apiClient.post(API.DEPARTMENTS, payload);
      }
      form.resetFields();
      setOpenCreate(false);
      setEditingDepartment(null);
      await loadDepartments();
    } catch {
      setError(
        editingDepartment
          ? t("pages.departments.updateError")
          : t("pages.departments.createError")
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
      await apiClient.delete(`${API.DEPARTMENTS}/${department.id}`);
      await loadDepartments();
    } catch {
      setError(t("pages.departments.deleteError"));
    } finally {
      setSaving(false);
    }
  };

  const columns = useMemo<ColumnsType<Department>>(
    () => [
      { title: t("pages.departments.code"), dataIndex: "code", width: 180 },
      { title: t("pages.departments.name"), dataIndex: "name" },
      {
        title: t("common.actions"),
        key: "actions",
        width: 160,
        render: (_, row) => (
          <Space>
            <Button size="small" onClick={() => openEdit(row)}>
              {t("common.edit")}
            </Button>
            <Popconfirm
              title={t("pages.departments.deleteTitle")}
              description={t("pages.departments.deleteDescription")}
              okText={t("pages.departments.deleteConfirm")}
              cancelText={t("common.cancel")}
              okButtonProps={{ danger: true, loading: saving }}
              onConfirm={() => void deleteDepartment(row)}
            >
              <Button size="small" danger disabled={saving}>
                {t("common.delete")}
              </Button>
            </Popconfirm>
          </Space>
        )
      }
    ],
    [saving, t]
  );

  const pagination: TablePaginationConfig = {
    current: data.page + 1,
    pageSize,
    total: data.totalItems,
    onChange: (nextPage, nextPageSize) => {
      if (nextPageSize !== pageSize) {
        setPage(0);
        setPageSize(nextPageSize);
        return;
      }
      setPage(nextPage - 1);
    }
  };

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.departments.title")}</h1>
        <p>{t("pages.departments.subtitle")}</p>
      </div>

      <Tabs items={[
        {
          key: "list", label: t("pages.departments.list"),
          children: (
            <>
              <PageToolbar>
                <Input.Search
                  allowClear
                  placeholder={t("pages.departments.searchPlaceholder")}
                  style={{ width: 280 }}
                  onSearch={(value) => {
                    setPage(0);
                    setKeyword(value.trim());
                  }}
                />
                <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
                  {t("pages.departments.add")}
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
            </>
          )
        },
        {
          key: "chart", label: t("pages.departments.orgChart"),
          children: <OrgChart />
        }
      ]} />

      <FormDrawer open={openCreate} title={editingDepartment ? t("pages.departments.update") : t("pages.departments.add")} onClose={closeDrawer}>
        <Form form={form} layout="vertical" onFinish={submitDepartment}>
          <Form.Item label={t("pages.departments.code")} name="code" htmlFor="department-code" rules={[{ required: true, message: t("pages.departments.enterCode") }]}>
            <Input id="department-code" />
          </Form.Item>
          <Form.Item label={t("pages.departments.name")} name="name" htmlFor="department-name" rules={[{ required: true, message: t("pages.departments.enterName") }]}>
            <Input id="department-name" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            {editingDepartment ? t("pages.employees.saveChanges") : t("common.createNew")}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
