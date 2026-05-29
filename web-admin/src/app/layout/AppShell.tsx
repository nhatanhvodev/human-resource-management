import {
  DashboardOutlined,
  SettingOutlined,
  TeamOutlined,
  UserOutlined,
  SolutionOutlined,
  CalendarOutlined,
  WalletOutlined,
  MenuOutlined
} from "@ant-design/icons";
import { Button, Drawer, Layout, Menu, Tag, Typography } from "antd";
import { useEffect, useState } from "react";
import { Outlet, useLocation, useNavigate } from "react-router-dom";

import { DEV_SETTINGS_CHANGED, loadDevSettings } from "../../shared/config/devSettingsStore";

const { Header, Content, Sider } = Layout;
const { Text } = Typography;

const navItems = [
  { key: "/dashboard", icon: <DashboardOutlined />, label: "Dashboard" },
  { key: "/departments", icon: <TeamOutlined />, label: "Departments" },
  { key: "/employees", icon: <UserOutlined />, label: "Employees" },
  { key: "/recruitment", icon: <SolutionOutlined />, label: "Recruitment" },
  { key: "/leave", icon: <CalendarOutlined />, label: "Leave" },
  { key: "/payroll", icon: <WalletOutlined />, label: "Payroll" },
  { key: "/settings", icon: <SettingOutlined />, label: "Settings" }
];

export function AppShell() {
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const [devSettings, setDevSettings] = useState(loadDevSettings);
  const selectedKey = navItems.find((item) => location.pathname.startsWith(item.key))?.key ?? "/dashboard";
  const onNavigate = (key: string) => {
    navigate(key);
    setMobileNavOpen(false);
  };

  useEffect(() => {
    const syncDevSettings = () => setDevSettings(loadDevSettings());
    window.addEventListener("storage", syncDevSettings);
    window.addEventListener(DEV_SETTINGS_CHANGED, syncDevSettings);
    window.addEventListener("focus", syncDevSettings);

    return () => {
      window.removeEventListener("storage", syncDevSettings);
      window.removeEventListener(DEV_SETTINGS_CHANGED, syncDevSettings);
      window.removeEventListener("focus", syncDevSettings);
    };
  }, []);

  return (
    <Layout className="app-shell">
      <Sider className="app-shell__sider" width={232} theme="light" breakpoint="lg" collapsedWidth={0} trigger={null}>
        <div className="app-shell__brand">HRMS Admin</div>
        <Menu
          mode="inline"
          selectedKeys={[selectedKey]}
          items={navItems}
          onClick={({ key }) => onNavigate(key)}
        />
      </Sider>
      <Layout>
        <Header className="app-shell__header">
          <div className="app-shell__header-left">
            <Button
              className="app-shell__menu-button"
              type="text"
              icon={<MenuOutlined />}
              aria-label="Open navigation"
              onClick={() => setMobileNavOpen(true)}
            />
            <Text strong>Admin workspace</Text>
          </div>
          <div className="app-shell__status">
            <Tag color={devSettings.tenantId ? "blue" : "default"}>
              Tenant: {devSettings.tenantId || "not set"}
            </Tag>
            <Tag color={devSettings.token ? "green" : "gold"}>
              Token: {devSettings.token ? "set" : "missing"}
            </Tag>
          </div>
        </Header>
        <Content className="app-shell__content">
          <Outlet />
        </Content>
      </Layout>
      <Drawer
        className="app-shell__mobile-nav"
        title="HRMS Admin"
        placement="left"
        width={260}
        open={mobileNavOpen}
        onClose={() => setMobileNavOpen(false)}
      >
        <Menu
          mode="inline"
          selectedKeys={[selectedKey]}
          items={navItems}
          onClick={({ key }) => onNavigate(key)}
        />
      </Drawer>
    </Layout>
  );
}
