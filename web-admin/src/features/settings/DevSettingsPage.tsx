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
        <h1>Thiết lập dev</h1>
        <p>Cấu hình header request dùng cho giao diện quản trị trong môi trường phát triển.</p>
      </div>

      <div className="settings-panel">
        <Form layout="vertical">
          <Form.Item label="Token truy cập" htmlFor="dev-token">
            <Input.Password
              id="dev-token"
              value={token}
              autoComplete="off"
              onChange={(event) => setToken(event.target.value)}
            />
          </Form.Item>
          <Form.Item label="Mã đơn vị" htmlFor="dev-tenant">
            <Input
              id="dev-tenant"
              value={tenantId}
              autoComplete="off"
              onChange={(event) => setTenantId(event.target.value)}
            />
          </Form.Item>
          <Button type="primary" htmlType="button" icon={<SaveOutlined />} onClick={onSave}>
            Lưu
          </Button>
        </Form>
      </div>
    </>
  );
}
