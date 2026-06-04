import { Button, Form, Input, InputNumber, Rate, message } from "antd";
import { useState } from "react";
import { apiClient } from "../../shared/api/client";

type Props = {
  interviewId: string | null;
  open: boolean;
  onClose: () => void;
  onSaved: () => void;
};

export default function InterviewFeedback({ interviewId, open, onClose, onSaved }: Props) {
  const [form] = Form.useForm();
  const [saving, setSaving] = useState(false);

  const handleSubmit = async (values: { feedback: string; rating: number }) => {
    if (!interviewId) return;
    setSaving(true);
    try {
      await apiClient.put(`/interviews/${interviewId}/feedback`, values);
      message.success("Đã lưu phản hồi");
      form.resetFields();
      onSaved();
    } catch {
      message.error("Không thể lưu phản hồi");
    } finally {
      setSaving(false);
    }
  };

  if (!open) return null;

  return (
    <Form form={form} layout="vertical" onFinish={handleSubmit} initialValues={{ rating: 0 }}>
      <Form.Item label="Điểm" name="rating" rules={[{ required: true, message: "Cho điểm" }]}>
        <Rate />
      </Form.Item>
      <Form.Item label="Phản hồi" name="feedback" rules={[{ required: true, message: "Nhập phản hồi" }]}>
        <Input.TextArea rows={4} placeholder="Nhận xét về buổi phỏng vấn..." />
      </Form.Item>
      <Button type="primary" htmlType="submit" loading={saving}>Lưu phản hồi</Button>
    </Form>
  );
}
