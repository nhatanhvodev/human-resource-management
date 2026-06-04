import { Button, DatePicker, Form, Input, Select, message } from "antd";
import { useEffect, useState } from "react";
import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";

type Employee = { id: string; employeeNo: string; fullName: string };
type Application = { id: string; candidateName?: string; jobTitle?: string; status: string };

type Props = {
  open: boolean;
  applications: Application[];
  onClose: () => void;
  onSaved: () => void;
};

export default function InterviewScheduler({ open, applications, onClose, onSaved }: Props) {
  const [form] = Form.useForm();
  const [saving, setSaving] = useState(false);
  const [interviewers, setInterviewers] = useState<Employee[]>([]);

  useEffect(() => {
    if (open) {
      apiClient.get<PageResponse<Employee>>("/employees", { params: { page: 0, size: 100, status: "ACTIVE" } })
        .then(r => setInterviewers(r.data.items ?? []))
        .catch(() => setInterviewers([]));
    }
  }, [open]);

  const handleSubmit = async (values: any) => {
    setSaving(true);
    try {
      await apiClient.post("/interviews", {
        applicationId: values.applicationId,
        interviewerId: values.interviewerId || null,
        scheduledAt: values.scheduledAt?.toISOString(),
        location: values.location || null,
        meetingLink: values.meetingLink || null
      });
      message.success("Đã lên lịch phỏng vấn");
      form.resetFields();
      onSaved();
    } catch {
      message.error("Không thể lên lịch phỏng vấn");
    } finally {
      setSaving(false);
    }
  };

  if (!open) return null;

  return (
    <div style={{ padding: "16px 0" }}>
      <Form form={form} layout="vertical" onFinish={handleSubmit}>
        <Form.Item label="Hồ sơ ứng tuyển" name="applicationId" rules={[{ required: true }]}>
          <Select
            showSearch
            placeholder="Chọn hồ sơ"
            options={applications.map(a => ({
              value: a.id,
              label: `${a.candidateName ?? a.id.slice(0, 8)} - ${a.jobTitle ?? "Chưa rõ"}`
            }))}
          />
        </Form.Item>
        <Form.Item label="Người phỏng vấn" name="interviewerId">
          <Select
            showSearch
            allowClear
            placeholder="Chọn người phỏng vấn"
            options={interviewers.map(e => ({
              value: e.id,
              label: `${e.employeeNo} - ${e.fullName}`
            }))}
          />
        </Form.Item>
        <Form.Item label="Thời gian" name="scheduledAt" rules={[{ required: true }]}>
          <DatePicker showTime style={{ width: "100%" }} />
        </Form.Item>
        <Form.Item label="Địa điểm" name="location">
          <Input placeholder="Phòng họp..." />
        </Form.Item>
        <Form.Item label="Link meeting" name="meetingLink">
          <Input placeholder="https://meet.google.com/..." />
        </Form.Item>
        <Button type="primary" htmlType="submit" loading={saving}>Lên lịch</Button>
      </Form>
    </div>
  );
}
