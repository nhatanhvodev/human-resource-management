import {
  BookOutlined,
  CalendarOutlined,
  DashboardOutlined,
  FileOutlined,
  LogoutOutlined,
  MenuOutlined,
  NotificationOutlined,
  TeamOutlined,
} from "@ant-design/icons";
import { Button, Drawer, Layout, Menu, Typography } from "antd";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Outlet, useLocation, useNavigate } from "react-router-dom";

import { LanguageSwitcher } from "../../shared/i18n/LanguageSwitcher";
import { NotificationBell } from "../../shared/ui/NotificationBell";
import { clearDevToken } from "../../shared/config/devSettingsStore";

const { Header, Content, Sider } = Layout;
const { Text } = Typography;

const navItems = [
  { key: "/manager/dashboard", icon: <DashboardOutlined />, labelKey: "nav.dashboard" },
  { key: "/manager/employees", icon: <TeamOutlined />, labelKey: "nav.employees" },
  { key: "/manager/leave", icon: <CalendarOutlined />, labelKey: "nav.leave" },
  { key: "/manager/documents", icon: <FileOutlined />, labelKey: "nav.documents" },
  { key: "/manager/training", icon: <BookOutlined />, labelKey: "nav.training" },
  { key: "/manager/announcements", icon: <NotificationOutlined />, labelKey: "nav.announcements" },
];

export function ManagerShell() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const selectedKey = navItems.find((item) => location.pathname.startsWith(item.key))?.key ?? "/manager/dashboard";
  const menuItems = navItems.map((item) => ({ key: item.key, icon: item.icon, label: t(item.labelKey) }));

  const onNavigate = (key: string) => {
    navigate(key);
    setMobileNavOpen(false);
  };

  const onLogout = () => {
    clearDevToken();
    navigate("/login", { replace: true });
  };

  return (
    <Layout className="app-shell">
      <Sider className="app-shell__sider" width={232} theme="light" breakpoint="lg" collapsedWidth={0} trigger={null}>
        <div className="app-shell__brand">{t("app.managerBrand")}</div>
        <Menu mode="inline" selectedKeys={[selectedKey]} items={menuItems} onClick={({ key }) => onNavigate(key)} />
      </Sider>
      <Layout>
        <Header className="app-shell__header">
          <div className="app-shell__header-left">
            <Button
              className="app-shell__menu-button"
              type="text"
              icon={<MenuOutlined />}
              aria-label={t("app.openNavigation")}
              onClick={() => setMobileNavOpen(true)}
            />
            <Text strong>{t("app.managerWorkspace")}</Text>
          </div>
          <div className="app-shell__status" style={{ display: "flex", gap: 8, alignItems: "center" }}>
            <LanguageSwitcher />
            <NotificationBell />
            <Button type="text" icon={<LogoutOutlined />} aria-label={t("auth.logout")} onClick={onLogout} />
          </div>
        </Header>
        <Content className="app-shell__content">
          <Outlet />
        </Content>
      </Layout>
      <Drawer
        className="app-shell__mobile-nav"
        title={t("app.managerBrand")}
        placement="left"
        width={260}
        open={mobileNavOpen}
        onClose={() => setMobileNavOpen(false)}
      >
        <Menu mode="inline" selectedKeys={[selectedKey]} items={menuItems} onClick={({ key }) => onNavigate(key)} />
      </Drawer>
    </Layout>
  );
}
