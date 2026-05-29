import { SaveOutlined } from "@ant-design/icons";
import { Button, Form, Input } from "antd";
import { useState } from "react";

import { loadDevSettings, saveDevSettings } from "../../shared/config/devSettingsStore";

export default function DevSettingsPage() {
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
        <h1>Dev Settings</h1>
        <p>Configure request headers used by the admin UI during development.</p>
      </div>

      <div className="settings-panel">
        <Form layout="vertical">
          <Form.Item label="Token" htmlFor="dev-token">
            <Input.Password
              id="dev-token"
              value={token}
              autoComplete="off"
              onChange={(event) => setToken(event.target.value)}
            />
          </Form.Item>
          <Form.Item label="Tenant" htmlFor="dev-tenant">
            <Input
              id="dev-tenant"
              value={tenantId}
              autoComplete="off"
              onChange={(event) => setTenantId(event.target.value)}
            />
          </Form.Item>
          <Button type="primary" htmlType="button" icon={<SaveOutlined />} onClick={onSave}>
            Luu
          </Button>
        </Form>
      </div>
    </>
  );
}
