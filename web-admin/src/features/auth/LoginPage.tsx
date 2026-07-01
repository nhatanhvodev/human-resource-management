import { LockOutlined, LoginOutlined, UserOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Typography } from "antd";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Navigate, useNavigate } from "react-router-dom";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import { useAccess } from "../../shared/auth/access";
import { saveDevSettings } from "../../shared/config/devSettingsStore";
import { LanguageSwitcher } from "../../shared/i18n/LanguageSwitcher";

const { Text } = Typography;

type LoginResponse = {
  token: string;
  tenantId: string;
  userId: string;
  username: string;
  displayName: string;
};

function targetPath(roles: string[]): string {
  if (roles.includes("ADMIN") || roles.includes("HR_MANAGER")) {
    return "/dashboard";
  }
  if (roles.includes("LINE_MANAGER")) {
    return "/manager/dashboard";
  }
  return "/ess/dashboard";
}

export default function LoginPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const access = useAccess();
  const [form] = Form.useForm();
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState(false);

  if (!access.loading && access.access?.userId) {
    return <Navigate to={targetPath(access.roles)} replace />;
  }

  const login = async (values: { username: string; password: string; tenantId: string }) => {
    setSubmitting(true);
    setError(false);
    try {
      const response = await apiClient.post<LoginResponse>(API.AUTH.LOGIN, values, {
        headers: { "X-Tenant-Id": values.tenantId }
      });
      saveDevSettings({
        token: response.data.token,
        tenantId: response.data.tenantId
      });
      const nextAccess = await access.reload();
      navigate(targetPath(nextAccess?.roles ?? []), { replace: true });
    } catch {
      setError(true);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-page__toolbar">
        <LanguageSwitcher />
      </div>
      <main className="login-page__panel">
        <div className="login-page__intro">
          <Text className="login-page__eyebrow">{t("auth.login.eyebrow")}</Text>
          <h1>{t("auth.login.title")}</h1>
        </div>

        <Form
          form={form}
          layout="vertical"
          initialValues={{ username: "admin", password: "password123", tenantId: "default" }}
          onFinish={login}
        >
          {error && <Alert className="login-page__alert" type="error" showIcon message={t("auth.login.error")} />}
          <Form.Item name="tenantId" label={t("auth.login.tenant")} rules={[{ required: true }]}>
            <Input autoComplete="organization" />
          </Form.Item>
          <Form.Item name="username" label={t("auth.login.username")} rules={[{ required: true }]}>
            <Input prefix={<UserOutlined />} autoComplete="username" />
          </Form.Item>
          <Form.Item name="password" label={t("auth.login.password")} rules={[{ required: true }]}>
            <Input.Password prefix={<LockOutlined />} autoComplete="current-password" />
          </Form.Item>
          <Button type="primary" htmlType="submit" block icon={<LoginOutlined />} loading={submitting}>
            {t("auth.login.submit")}
          </Button>
        </Form>

      </main>
    </div>
  );
}
