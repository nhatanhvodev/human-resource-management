import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, InputNumber, Select, Space, Table } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

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
      setError("Không tải được danh sách khoá học.");
    } finally { setLoading(false); }
  }, []);

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
    } catch { setError("Không tạo được khoá học."); }
    finally { setSaving(false); }
  };

  const enroll = async (values: { employeeId: string }) => {
    if (!selectedCourseId) return;
    setSaving(true);
    try {
      await apiClient.post("/training/enroll", { courseId: selectedCourseId, employeeId: values.employeeId });
      enrollForm.resetFields();
      setOpenEnroll(false);
    } catch { setError("Không ghi danh được."); }
    finally { setSaving(false); }
  };

  const coursesColumns = useMemo<ColumnsType<Course>>(() => [
    { title: "Tên khoá", dataIndex: "title" },
    { title: "Danh mục", dataIndex: "category", width: 120 },
    { title: "Giờ", dataIndex: "durationHours", width: 60 },
    { title: "Giảng viên", dataIndex: "instructorName", width: 150 },
    { title: "Từ ngày", dataIndex: "startDate", width: 110 },
    { title: "Đến ngày", dataIndex: "endDate", width: 110 },
    {
      title: "", key: "actions", width: 100,
      render: (_, row) => (
        <Button size="small" onClick={() => { setSelectedCourseId(row.id); setOpenEnroll(true); }}>
          Ghi danh
        </Button>
      )
    }
  ], []);

  return (
    <>
      <div className="page-header">
        <h1>Đào tạo</h1>
        <p>Quản lý khoá học và ghi danh nhân viên.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>Tạo khoá học</Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<Course> rowKey="id" loading={loading} columns={coursesColumns} dataSource={courses} pagination={false} />

      <FormDrawer open={openCreate} title="Tạo khoá học" onClose={() => setOpenCreate(false)}>
        <Form form={form} layout="vertical" onFinish={createCourse}>
          <Form.Item label="Tên khoá" name="title" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item label="Mô tả" name="description">
            <Input.TextArea rows={3} />
          </Form.Item>
          <Form.Item label="Danh mục" name="category">
            <Input />
          </Form.Item>
          <Form.Item label="Số giờ" name="durationHours">
            <InputNumber min={1} style={{ width: "100%" }} />
          </Form.Item>
          <Form.Item label="Giảng viên" name="instructorName">
            <Input />
          </Form.Item>
          <Form.Item label="Ngày bắt đầu" name="startDate">
            <Input type="date" />
          </Form.Item>
          <Form.Item label="Ngày kết thúc" name="endDate">
            <Input type="date" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>Tạo</Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={openEnroll} title="Ghi danh nhân viên" onClose={() => setOpenEnroll(false)}>
        <Form form={enrollForm} layout="vertical" onFinish={enroll}>
          <Form.Item label="Nhân viên" name="employeeId" rules={[{ required: true }]}>
            <Select placeholder="Chọn nhân viên"
              options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))} />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>Ghi danh</Button>
        </Form>
      </FormDrawer>
    </>
  );
}
