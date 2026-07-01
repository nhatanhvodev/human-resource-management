import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space, Tabs } from "antd";
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
import OnboardingBoard from "./OnboardingBoard";

type Template = { id: string; name: string; description: string };
type TemplateTask = { id: string; templateId: string; title: string; description: string; orderIndex: number };
type Employee = { id: string; employeeNo: string; fullName: string };

export default function OnboardingPage() {
  const { t } = useTranslation();
  const [templates, setTemplates] = useState<Template[]>([]);
  const [templateTasks, setTemplateTasks] = useState<Record<string, TemplateTask[]>>({});
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreateTemplate, setOpenCreateTemplate] = useState(false);
  const [openStart, setOpenStart] = useState(false);
  const [activeTab, setActiveTab] = useState("templates");
  const [form] = Form.useForm();

  const loadTemplates = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<Template[]>(API.ONBOARDING.TEMPLATES);
      setTemplates(res.data);
    } catch {
      setError(t("pages.onboarding.loadError"));
    } finally {
      setLoading(false);
    }
  }, [t]);

  const loadEmployees = useCallback(async () => {
    try {
      const res = await apiClient.get<PageResponse<Employee>>(API.EMPLOYEES, { params: { page: 0, size: 100, status: "ACTIVE" } });
      setEmployees(res.data.items ?? []);
    } catch { setEmployees([]); }
  }, []);

  const loadTemplateTasks = async (id: string) => {
    try {
      const res = await apiClient.get<TemplateTask[]>(`${API.ONBOARDING.TEMPLATES}/${id}/tasks`);
      setTemplateTasks(prev => ({ ...prev, [id]: res.data }));
    } catch {}
  };

  useEffect(() => { void loadTemplates(); }, [loadTemplates]);
  useEffect(() => { void loadEmployees(); }, [loadEmployees]);

  const createTemplate = async (values: { name: string; description: string }) => {
    setSaving(true);
    try {
      await apiClient.post(API.ONBOARDING.TEMPLATES, values);
      form.resetFields();
      setOpenCreateTemplate(false);
      await loadTemplates();
    } catch { setError(t("pages.onboarding.createError")); }
    finally { setSaving(false); }
  };

  const deleteTemplate = async (id: string) => {
    setSaving(true);
    try { await apiClient.delete(`${API.ONBOARDING.TEMPLATES}/${id}`); await loadTemplates(); }
    catch { setError(t("pages.onboarding.deleteError")); }
    finally { setSaving(false); }
  };

  const startOnboarding = async (values: { employeeId: string; templateId: string }) => {
    setSaving(true);
    try {
      await apiClient.post(API.ONBOARDING.START, values);
      form.resetFields();
      setOpenStart(false);
    } catch { setError(t("pages.onboarding.startError")); }
    finally { setSaving(false); }
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
              {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}
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
