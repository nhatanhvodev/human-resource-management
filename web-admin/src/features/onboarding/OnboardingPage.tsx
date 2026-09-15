import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import type { UseQueryResult } from "@tanstack/react-query";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
// NOTE: `as UseQueryResult<...>` restores useApiQuery's documented return type, which currently
// degrades under the installed @tanstack/react-query 5.102.8 (overload error inside query.ts).
// The cast is type-only and has zero runtime effect.
import { queryClient, useApiMutation, useApiQuery } from "../../shared/api/query";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";
import OnboardingBoard from "./OnboardingBoard";

type Template = { id: string; name: string; description: string };
type TemplateTask = { id: string; templateId: string; title: string; description: string; orderIndex: number };
type Employee = { id: string; employeeNo: string; fullName: string };

export default function OnboardingPage() {
  const { t } = useTranslation();
  const [templateTasks, setTemplateTasks] = useState<Record<string, TemplateTask[]>>({});
  const [error, setError] = useState<string | null>(null);
  const [openCreateTemplate, setOpenCreateTemplate] = useState(false);
  const [openStart, setOpenStart] = useState(false);
  const [activeTab, setActiveTab] = useState("templates");
  const [form] = Form.useForm();

  const templatesQuery = useApiQuery<Template[]>(["onboarding", "templates"], API.ONBOARDING.TEMPLATES) as UseQueryResult<Template[], unknown>;
  const employeesQuery = useApiQuery<PageResponse<Employee>>(["onboarding", "employees"], API.EMPLOYEES, {
    config: { params: { page: 0, size: 100, status: "ACTIVE" } }
  }) as UseQueryResult<PageResponse<Employee>, unknown>;

  const templates = templatesQuery.data ?? [];
  const loading = templatesQuery.isLoading;
  const loadError = templatesQuery.isError ? t("pages.onboarding.loadError") : null;
  const visibleError = error ?? loadError;
  const employees = employeesQuery.data?.items ?? [];

  const createTemplateMutation = useApiMutation<Template, { name: string; description: string }>({
    invalidateKeys: [["onboarding", "templates"]]
  });
  const deleteTemplateMutation = useApiMutation({
    invalidateKeys: [["onboarding", "templates"]]
  });
  const startOnboardingMutation = useApiMutation();
  const saving = createTemplateMutation.isPending || deleteTemplateMutation.isPending || startOnboardingMutation.isPending;

  // On-demand per-template expansion; fetched through the shared queryClient
  // so repeat expansions are served from cache instead of refetching.
  const loadTemplateTasks = async (id: string) => {
    try {
      const tasks = await queryClient.fetchQuery({
        queryKey: ["onboarding", "template-tasks", id],
        queryFn: async () => (await apiClient.get<TemplateTask[]>(`${API.ONBOARDING.TEMPLATES}/${id}/tasks`)).data
      });
      setTemplateTasks(prev => ({ ...prev, [id]: tasks }));
    } catch {}
  };

  const createTemplate = async (values: { name: string; description: string }) => {
    setError(null);
    try {
      await createTemplateMutation.mutateAsync({ url: API.ONBOARDING.TEMPLATES, body: values });
      form.resetFields();
      setOpenCreateTemplate(false);
    } catch { setError(t("pages.onboarding.createError")); }
  };

  const deleteTemplate = async (id: string) => {
    setError(null);
    try {
      await deleteTemplateMutation.mutateAsync({ url: `${API.ONBOARDING.TEMPLATES}/${id}`, method: "delete" });
    }
    catch { setError(t("pages.onboarding.deleteError")); }
  };

  const startOnboarding = async (values: { employeeId: string; templateId: string }) => {
    setError(null);
    try {
      await startOnboardingMutation.mutateAsync({ url: API.ONBOARDING.START, body: values });
      form.resetFields();
      setOpenStart(false);
    } catch { setError(t("pages.onboarding.startError")); }
  };

  const templateColumns = useMemo<ColumnsType<Template>>(() => [
    { title: t("common.name"), dataIndex: "name" },
    { title: t("common.description"), dataIndex: "description", render: (v: string) => v ?? "-" },
    {
      title: t("pages.onboarding.taskCount"), key: "count", width: 100,
      render: (_, row) => templateTasks[row.id]?.length ?? 0
    },
    {
      title: t("common.actions"), key: "actions", width: 200,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => void loadTemplateTasks(row.id)}>{t("pages.onboarding.viewTasks")}</Button>
          <Button size="small" danger loading={saving}
            onClick={() => void deleteTemplate(row.id)}>{t("common.delete")}</Button>
        </Space>
      )
    }
  ], [templateTasks, saving, t]);

  return (
    <>
      <div className="page-header">
        <h1>Onboarding</h1>
        <p>{t("pages.onboarding.subtitle")}</p>
      </div>

      <Tabs activeKey={activeTab} onChange={setActiveTab} items={[
        {
          key: "templates", label: t("pages.onboarding.templates"),
          children: (
            <>
              <PageToolbar>
                <Space />
                <Button type="primary" icon={<PlusOutlined />}
                  onClick={() => setOpenCreateTemplate(true)}>{t("pages.onboarding.createTemplate")}</Button>
              </PageToolbar>
              {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}
              <AppTable<Template> rowKey="id" loading={loading} columns={templateColumns} dataSource={templates} pagination={false} />
              {Object.entries(templateTasks).map(([id, tasks]) => (
                <div key={id} style={{ marginTop: 16 }}>
                  <h4>{t("pages.onboarding.tasksForTemplate", { name: templates.find(t => t.id === id)?.name ?? "-" })}</h4>
                  <AppTable<TemplateTask> rowKey="id" loading={false}
                    columns={[
                      { title: t("pages.onboarding.order"), dataIndex: "orderIndex", width: 80 },
                      { title: t("pages.announcements.announcementTitle"), dataIndex: "title" },
                      { title: t("common.description"), dataIndex: "description" }
                    ]}
                    dataSource={tasks} pagination={false} />
                </div>
              ))}
            </>
          )
        },
        {
          key: "start", label: t("pages.onboarding.start"),
          children: (
            <div style={{ padding: 24, maxWidth: 480 }}>
              <Form form={form} layout="vertical" onFinish={startOnboarding}>
                <Form.Item label={t("common.employee")} name="employeeId" rules={[{ required: true }]}>
                  <Select placeholder={t("pages.onboarding.selectEmployee")} options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))} />
                </Form.Item>
                <Form.Item label="Template" name="templateId" rules={[{ required: true }]}>
                  <Select placeholder={t("pages.onboarding.selectTemplate")} options={templates.map(t => ({ value: t.id, label: t.name }))} />
                </Form.Item>
                <Button type="primary" htmlType="submit" loading={saving}>{t("pages.onboarding.startOnboarding")}</Button>
              </Form>
            </div>
          )
        },
        {
          key: "board", label: t("pages.onboarding.board"),
          children: <OnboardingBoard />
        }
      ]} />

      <FormDrawer open={openCreateTemplate} title={t("pages.onboarding.createTemplate")} onClose={() => setOpenCreateTemplate(false)}>
        <Form form={form} layout="vertical" onFinish={createTemplate}>
          <Form.Item label={t("common.name")} name="name" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label={t("common.description")} name="description">
            <Input.TextArea rows={3} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>{t("common.create")}</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
