import { zodResolver } from "@hookform/resolvers/zod";
import { LockOutlined, LoginOutlined, UserOutlined } from "@ant-design/icons";
import { Alert, Button, Form, Input, Typography } from "antd";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import { Navigate, useNavigate } from "react-router-dom";
import { z } from "zod";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import { useAccess } from "../../shared/auth/access";
import { saveSessionToken } from "../../shared/config/devSettingsStore";
import { LanguageSwitcher } from "../../shared/i18n/LanguageSwitcher";

const { Text } = Typography;

// P2: schema-validated login — trims + length-limits before anything hits the API.
const loginSchema = z.object({
  tenantId: z.string().trim().min(1).max(64).regex(/^[a-z0-9][a-z0-9_-]*$/i),
  username: z.string().trim().min(1).max(128),
  password: z.string().min(1).max(256),
});

type LoginForm = z.infer<typeof loginSchema>;

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
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState(false);

  // P0: never ship demo credentials in production builds.
  const defaults: LoginForm = import.meta.env.DEV
    ? { username: "admin", password: "admin123", tenantId: "default" }
    : { username: "", password: "", tenantId: "default" };

  const { control, handleSubmit } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
    defaultValues: defaults,
  });

  if (!access.loading && access.access?.userId) {
    return <Navigate to={targetPath(access.roles)} replace />;
  }

  const login = async (values: LoginForm) => {
    setSubmitting(true);
    setError(false);
    try {
      const response = await apiClient.post<LoginResponse>(API.AUTH.LOGIN, values, {
        headers: { "X-Tenant-Id": values.tenantId }
      });
      // P3: session token lives in memory; reload persistence via refresh cookie.
      saveSessionToken(response.data.token, response.data.tenantId);
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
          layout="vertical"
          onFinish={() => void handleSubmit(login)()}
        >
          {error && <Alert className="login-page__alert" type="error" showIcon message={t("auth.login.error")} />}
          <Form.Item label={t("auth.login.tenant")} required>
            <Controller
              name="tenantId"
              control={control}
              render={({ field, fieldState }) => (
                <>
                  <Input id="tenant" {...field} autoComplete="organization" status={fieldState.error ? "error" : undefined} />
                  {fieldState.error && <Text type="danger">{t("auth.login.invalid")}</Text>}
                </>
              )}
            />
          </Form.Item>
          <Form.Item label={t("auth.login.username")} required>
            <Controller
              name="username"
              control={control}
              render={({ field, fieldState }) => (
                <Input id="username" {...field} prefix={<UserOutlined />} autoComplete="username" status={fieldState.error ? "error" : undefined} />
              )}
            />
          </Form.Item>
          <Form.Item label={t("auth.login.password")} required>
            <Controller
              name="password"
              control={control}
              render={({ field, fieldState }) => (
                <Input.Password id="password" {...field} prefix={<LockOutlined />} autoComplete="current-password" status={fieldState.error ? "error" : undefined} />
              )}
            />
          </Form.Item>
          <Button type="primary" htmlType="submit" block icon={<LoginOutlined />} loading={submitting}>
            {t("auth.login.submit")}
          </Button>
        </Form>

      </main>
    </div>
  );
}
