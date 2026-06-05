import { SaveOutlined } from "@ant-design/icons";
import { Button, Form, Input } from "antd";
import { useState } from "react";
import { useTranslation } from "react-i18next";

import { loadDevSettings, saveDevSettings } from "../../shared/config/devSettingsStore";

export default function DevSettingsPage() {
  const { t } = useTranslation();
  const initialSettings = loadDevSettings();
  const [token, setToken] = useState(initialSettings.token);
  const [tenantId, setTenantId] = useState(initialSettings.tenantId);

  const onSave = () => {
    saveDevSettings({
      token: token.trim(),
      tenantId: tenantId.trim()
    });
  };

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.settings.title")}</h1>
        <p>{t("pages.settings.subtitle")}</p>
      </div>

      <div className="settings-panel">
        <Form layout="vertical">
          <Form.Item label={t("pages.settings.token")} htmlFor="dev-token">
            <Input.Password
              id="dev-token"
              value={token}
              autoComplete="off"
              onChange={(event) => setToken(event.target.value)}
            />
          </Form.Item>
          <Form.Item label={t("pages.settings.tenant")} htmlFor="dev-tenant">
            <Input
              id="dev-tenant"
              value={tenantId}
              autoComplete="off"
              onChange={(event) => setTenantId(event.target.value)}
            />
          </Form.Item>
          <Button type="primary" htmlType="button" icon={<SaveOutlined />} onClick={onSave}>
            {t("common.save")}
          </Button>
        </Form>
      </div>
    </>
  );
}
