import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";

type Course = {
  id: string;
  title: string;
  description: string;
  category: string;
  durationHours: number;
  instructorName: string;
  startDate: string;
  endDate: string;
};

type Employee = { id: string; employeeNo: string; fullName: string };

export default function TrainingPage() {
  const { t } = useTranslation();
  const [courses, setCourses] = useState<Course[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [openEnroll, setOpenEnroll] = useState(false);
  const [selectedCourseId, setSelectedCourseId] = useState<string | null>(null);
  const [form] = Form.useForm();
  const [enrollForm] = Form.useForm();

  const loadCourses = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<Course>>("/training/courses", { params: { page: 0, size: 50 } });
      setCourses(res.data.items ?? []);
    } catch {
      setError(t("pages.training.loadError"));
    } finally { setLoading(false); }
  }, [t]);

  const loadEmployees = useCallback(async () => {
    try {
      const res = await apiClient.get<PageResponse<Employee>>("/employees", { params: { page: 0, size: 100, status: "ACTIVE" } });
      setEmployees(res.data.items ?? []);
    } catch { setEmployees([]); }
  }, []);

  useEffect(() => { void loadCourses(); }, [loadCourses]);
  useEffect(() => { void loadEmployees(); }, [loadEmployees]);

  const createCourse = async (values: any) => {
    setSaving(true);
    setError(null);
    try {
      await apiClient.post("/training/courses", values);
      form.resetFields();
      setOpenCreate(false);
      await loadCourses();
    } catch { setError(t("pages.training.createError")); }
    finally { setSaving(false); }
  };

  const enroll = async (values: { employeeId: string }) => {
    if (!selectedCourseId) return;
    setSaving(true);
    try {
      await apiClient.post("/training/enroll", { courseId: selectedCourseId, employeeId: values.employeeId });
      enrollForm.resetFields();
      setOpenEnroll(false);
    } catch { setError(t("pages.training.enrollError")); }
    finally { setSaving(false); }
  };

  const coursesColumns = useMemo<ColumnsType<Course>>(() => [
    { title: t("pages.training.courseTitle"), dataIndex: "title" },
    { title: t("pages.training.category"), dataIndex: "category", width: 120 },
    { title: t("pages.training.hours"), dataIndex: "durationHours", width: 60 },
    { title: t("pages.training.instructor"), dataIndex: "instructorName", width: 150 },
    { title: t("common.fromDate"), dataIndex: "startDate", width: 110 },
    { title: t("common.toDate"), dataIndex: "endDate", width: 110 },
    {
      title: "", key: "actions", width: 100,
      render: (_, row) => (
        <Button size="small" onClick={() => { setSelectedCourseId(row.id); setOpenEnroll(true); }}>
          {t("pages.training.enrollEmployee")}
        </Button>
      )
    }
  ], [t]);

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.training.title")}</h1>
        <p>{t("pages.training.subtitle")}</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>{t("pages.training.createCourse")}</Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Course> rowKey="id" loading={loading} columns={coursesColumns} dataSource={courses} pagination={false} />

      <FormDrawer open={openCreate} title={t("pages.training.createCourse")} onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createCourse}>
          <Form.Item label={t("pages.training.courseTitle")} name="title" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label={t("common.description")} name="description">
            <Input.TextArea rows={3} />
          </Form.Item>
          <Form.Item label={t("pages.training.category")} name="category">
            <Input />
          </Form.Item>
          <Form.Item label={t("pages.training.durationHours")} name="durationHours">
            <InputNumber min={1} style={{ width: "100%" }} />
          </Form.Item>
          <Form.Item label={t("pages.training.instructor")} name="instructorName">
            <Input />
          </Form.Item>
          <Form.Item label={t("pages.training.startDate")} name="startDate">
            <Input type="date" />
          </Form.Item>
          <Form.Item label={t("pages.training.endDate")} name="endDate">
            <Input type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>{t("common.create")}</Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={openEnroll} title={t("pages.training.enrollEmployee")} onClose={() => setOpenEnroll(false)}>
        <Form form={enrollForm} layout="vertical" onFinish={enroll}>
          <Form.Item label={t("common.employee")} name="employeeId" rules={[{ required: true }]}>
            <Select placeholder={t("pages.training.selectEmployee")}
              options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>{t("pages.training.enrollEmployee")}</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
