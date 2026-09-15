import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Popconfirm, Space, Tabs } from "antd";
import type { ColumnsType, TablePaginationConfig } from "antd/es/table";
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { API } from "../../shared/api/endpoints";
import { useApiMutation, useApiQuery } from "../../shared/api/query";
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
  const [openCreate, setOpenCreate] = useState(false);
  const [editingDepartment, setEditingDepartment] = useState<Department | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [form] = Form.useForm<{ code: string; name: string }>();

  const { data, isLoading, isError } = useApiQuery<PageResponse<Department>>(
    ['departments', page, pageSize, keyword],
    API.DEPARTMENTS,
    { config: { params: { page, size: pageSize, q: keyword || undefined } } }
  );
  const rows: PageResponse<Department> = { ...emptyPage, ...data, items: data?.items ?? [] };

  const saveMutation = useApiMutation<Department, { code: string; name: string }>({
    invalidateKeys: [['departments']],
  });
  const deleteMutation = useApiMutation({
    invalidateKeys: [['departments']],
  });
  const saving = saveMutation.isPending || deleteMutation.isPending;
  const visibleError = error ?? (isError ? t("pages.departments.loadError") : null);

  const submitDepartment = async (values: { code: string; name: string }) => {
    setError(null);
    try {
      const payload = {
        code: values.code.trim(),
        name: values.name.trim()
      };
      if (editingDepartment) {
        await saveMutation.mutateAsync({
          url: `${API.DEPARTMENTS}/${editingDepartment.id}`,
          method: "put",
          body: payload,
        });
      } else {
        await saveMutation.mutateAsync({ url: API.DEPARTMENTS, body: payload });
      }
      form.resetFields();
      setOpenCreate(false);
      setEditingDepartment(null);
    } catch {
      setError(
        editingDepartment
          ? t("pages.departments.updateError")
          : t("pages.departments.createError")
      );
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
    setError(null);
    try {
      await deleteMutation.mutateAsync({
        url: `${API.DEPARTMENTS}/${department.id}`,
        method: "delete",
      });
    } catch {
      setError(t("pages.departments.deleteError"));
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
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [saving, t]
  );

  const pagination: TablePaginationConfig = {
    current: rows.page + 1,
    pageSize,
    total: rows.totalItems,
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

              {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}

              <AppTable<Department>
                rowKey="id"
                loading={isLoading}
                dataSource={rows.items}
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
