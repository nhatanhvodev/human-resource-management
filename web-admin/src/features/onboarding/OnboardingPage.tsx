import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type Template = { id: string; name: string; description: string };
type TemplateTask = { id: string; templateId: string; title: string; description: string; orderIndex: number };
type Employee = { id: string; employeeNo: string; fullName: string };

export default function OnboardingPage() {
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
      const res = await apiClient.get<Template[]>("/onboarding/templates");
      setTemplates(res.data);
    } catch {
      setError("Không tải được danh sách template.");
    } finally {
      setLoading(false);
    }
  }, []);

  const loadEmployees = useCallback(async () => {
    try {
      const res = await apiClient.get<PageResponse<Employee>>("/employees", { params: { page: 0, size: 100, status: "ACTIVE" } });
      setEmployees(res.data.items ?? []);
    } catch { setEmployees([]); }
  }, []);

  const loadTemplateTasks = async (id: string) => {
    try {
      const res = await apiClient.get<TemplateTask[]>(`/onboarding/templates/${id}/tasks`);
      setTemplateTasks(prev => ({ ...prev, [id]: res.data }));
    } catch {}
  };

  useEffect(() => { void loadTemplates(); }, [loadTemplates]);
  useEffect(() => { void loadEmployees(); }, [loadEmployees]);

  const createTemplate = async (values: { name: string; description: string }) => {
    setSaving(true);
    try {
      await apiClient.post("/onboarding/templates", values);
      form.resetFields();
      setOpenCreateTemplate(false);
      await loadTemplates();
    } catch { setError("Không tạo được template."); }
    finally { setSaving(false); }
  };

  const deleteTemplate = async (id: string) => {
    setSaving(true);
    try { await apiClient.delete(`/onboarding/templates/${id}`); await loadTemplates(); }
    catch { setError("Không xoá được template."); }
    finally { setSaving(false); }
  };

  const startOnboarding = async (values: { employeeId: string; templateId: string }) => {
    setSaving(true);
    try {
      await apiClient.post("/onboarding/start", values);
      form.resetFields();
      setOpenStart(false);
    } catch { setError("Không khởi tạo được onboarding."); }
    finally { setSaving(false); }
  };

  const templateColumns = useMemo<ColumnsType<Template>>(() => [
    { title: "Tên", dataIndex: "name" },
    { title: "Mô tả", dataIndex: "description", render: (v: string) => v ?? "-" },
    {
      title: "Số task", key: "count", width: 100,
      render: (_, row) => templateTasks[row.id]?.length ?? 0
    },
    {
      title: "Thao tác", key: "actions", width: 200,
      render: (_, row) => (
        <Space>
          <Button size="small" onClick={() => void loadTemplateTasks(row.id)}>Xem task</Button>
          <Button size="small" danger loading={saving}
            onClick={() => void deleteTemplate(row.id)}>Xoá</Button>
        </Space>
      )
    }
  ], [templateTasks, saving]);

  return (
    <>
      <div className="page-header">
        <h1>Onboarding</h1>
        <p>Quản lý template onboarding và khởi tạo quy trình cho nhân viên mới.</p>
      </div>

      <Tabs activeKey={activeTab} onChange={setActiveTab} items={[
        {
          key: "templates", label: "Templates",
          children: (
            <>
              <PageToolbar>
                <Space />
                <Button type="primary" icon={<PlusOutlined />}
                  onClick={() => setOpenCreateTemplate(true)}>Tạo template</Button>
              </PageToolbar>
              {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}
              <AppTable<Template> rowKey="id" loading={loading} columns={templateColumns} dataSource={templates} pagination={false} />
              {Object.entries(templateTasks).map(([id, tasks]) => (
                <div key={id} style={{ marginTop: 16 }}>
                  <h4>Tasks của template {templates.find(t => t.id === id)?.name ?? id.slice(0, 8)}</h4>
                  <AppTable<TemplateTask> rowKey="id" loading={false}
                    columns={[
                      { title: "Thứ tự", dataIndex: "orderIndex", width: 80 },
                      { title: "Tiêu đề", dataIndex: "title" },
                      { title: "Mô tả", dataIndex: "description" }
                    ]}
                    dataSource={tasks} pagination={false} />
                </div>
              ))}
            </>
          )
        },
        {
          key: "start", label: "Khởi tạo",
          children: (
            <div style={{ padding: 24, maxWidth: 480 }}>
              <Form form={form} layout="vertical" onFinish={startOnboarding}>
                <Form.Item label="Nhân viên" name="employeeId" rules={[{ required: true }]}>
                  <Select placeholder="Chọn nhân viên" options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))} />
                </Form.Item>
                <Form.Item label="Template" name="templateId" rules={[{ required: true }]}>
                  <Select placeholder="Chọn template" options={templates.map(t => ({ value: t.id, label: t.name }))} />
                </Form.Item>
                <Button type="primary" htmlType="submit" loading={saving}>Khởi tạo</Button>
              </Form>
            </div>
          )
        }
      ]} />

      <FormDrawer open={openCreateTemplate} title="Tạo template" onClose={() => setOpenCreateTemplate(false)}>
        <Form form={form} layout="vertical" onFinish={createTemplate}>
          <Form.Item label="Tên" name="name" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="Mô tả" name="description">
            <Input.TextArea rows={3} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>Tạo</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
