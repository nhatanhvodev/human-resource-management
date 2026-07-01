import { Button, Form, Input, InputNumber, Rate, message } from "antd";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";

type Props = {
  interviewId: string | null;
  open: boolean;
  onClose: () => void;
  onSaved: () => void;
};

export default function InterviewFeedback({ interviewId, open, onClose, onSaved }: Props) {
  const { t } = useTranslation();
  const [form] = Form.useForm();
  const [saving, setSaving] = useState(false);

  const handleSubmit = async (values: { feedback: string; rating: number }) => {
    if (!interviewId) return;
    setSaving(true);
    try {
      await apiClient.put(`/interviews/${interviewId}/feedback`, values);
      message.success(t("pages.recruitment.savedFeedback"));
      form.resetFields();
      onSaved();
    } catch {
      message.error(t("pages.recruitment.saveFeedbackError"));
    } finally {
      setSaving(false);
    }
  };

  if (!open) return null;

  return (
    <Form form={form} layout="vertical" onFinish={handleSubmit} initialValues={{ rating: 0 }}>
      <Form.Item label={t("pages.recruitment.rating")} name="rating" rules={[{ required: true, message: t("pages.recruitment.giveRating") }]}>
        <Rate />
      </Form.Item>
      <Form.Item label={t("pages.recruitment.feedback")} name="feedback" rules={[{ required: true, message: t("pages.recruitment.enterFeedback") }]}>
        <Input.TextArea rows={4} placeholder={t("pages.recruitment.feedbackPlaceholder")} />
      </Form.Item>
      <Button type="primary" htmlType="submit" loading={saving}>{t("pages.recruitment.saveFeedback")}</Button>
    </Form>
  );
}
