import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space } from "antd";
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
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [openEnroll, setOpenEnroll] = useState(false);
  const [selectedCourseId, setSelectedCourseId] = useState<string | null>(null);
  const [form] = Form.useForm();
  const [enrollForm] = Form.useForm();

  const coursesQuery = useApiQuery<PageResponse<Course>>(["training", "courses"], API.TRAINING.COURSES, {
    config: { params: { page: 0, size: 50 } }
  }) as UseQueryResult<PageResponse<Course>, unknown>;
  const employeesQuery = useApiQuery<PageResponse<Employee>>(["training", "employees"], API.EMPLOYEES, {
    config: { params: { page: 0, size: 100, status: "ACTIVE" } }
  }) as UseQueryResult<PageResponse<Employee>, unknown>;

  const courses = coursesQuery.data?.items ?? [];
  const loading = coursesQuery.isLoading;
  const loadError = coursesQuery.isError ? t("pages.training.loadError") : null;
  const visibleError = error ?? loadError;
  const employees = employeesQuery.data?.items ?? [];

  const createCourseMutation = useApiMutation<Course, any>({
    invalidateKeys: [["training", "courses"]]
  });
  const enrollMutation = useApiMutation<unknown, { courseId: string; employeeId: string }>();
  const saving = createCourseMutation.isPending || enrollMutation.isPending;

  const createCourse = async (values: any) => {
    setError(null);
    try {
      await createCourseMutation.mutateAsync({ url: API.TRAINING.COURSES, body: values });
      form.resetFields();
      setOpenCreate(false);
    } catch { setError(t("pages.training.createError")); }
  };

  const enroll = async (values: { employeeId: string }) => {
    if (!selectedCourseId) return;
    setError(null);
    try {
      await enrollMutation.mutateAsync({ url: API.TRAINING.ENROLL, body: { courseId: selectedCourseId, employeeId: values.employeeId } });
      enrollForm.resetFields();
      setOpenEnroll(false);
    } catch { setError(t("pages.training.enrollError")); }
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

      {visibleError ? <Alert type="warning" showIcon message={visibleError} style={{ marginBottom: 16 }} /> : null}

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
