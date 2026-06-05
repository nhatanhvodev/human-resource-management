import { Button, DatePicker, Form, Input, Select, message } from "antd";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
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
  const { t } = useTranslation();
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
      message.success(t("pages.recruitment.interviewScheduled"));
      form.resetFields();
      onSaved();
    } catch {
      message.error(t("pages.recruitment.scheduleInterviewError"));
    } finally {
      setSaving(false);
    }
  };

  if (!open) return null;

  return (
    <div style={{ padding: "16px 0" }}>
      <Form form={form} layout="vertical" onFinish={handleSubmit}>
        <Form.Item label={t("pages.recruitment.applications")} name="applicationId" rules={[{ required: true }]}>
          <Select
            showSearch
            placeholder={t("pages.recruitment.chooseApplication")}
            options={applications.map(a => ({
              value: a.id,
              label: `${a.candidateName ?? a.id.slice(0, 8)} - ${a.jobTitle ?? t("pages.recruitment.unknown")}`
            }))}
          />
        </Form.Item>
        <Form.Item label={t("pages.recruitment.interviewer")} name="interviewerId">
          <Select
            showSearch
            allowClear
            placeholder={t("pages.recruitment.chooseInterviewer")}
            options={interviewers.map(e => ({
              value: e.id,
              label: `${e.employeeNo} - ${e.fullName}`
            }))}
          />
        </Form.Item>
        <Form.Item label={t("pages.recruitment.scheduledAt")} name="scheduledAt" rules={[{ required: true }]}>
          <DatePicker showTime style={{ width: "100%" }} />
        </Form.Item>
        <Form.Item label={t("pages.recruitment.location")} name="location">
          <Input placeholder={t("pages.recruitment.meetingRoomPlaceholder")} />
        </Form.Item>
        <Form.Item label="Link meeting" name="meetingLink">
          <Input placeholder="https://meet.google.com/..." />
        </Form.Item>
        <Button type="primary" htmlType="submit" loading={saving}>{t("pages.recruitment.schedule")}</Button>
      </Form>
    </div>
  );
}
