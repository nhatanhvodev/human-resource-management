import {
  AuditOutlined,
  BookOutlined,
  CalendarOutlined,
  CompassOutlined,
  DashboardOutlined,
  FileOutlined,
  LogoutOutlined,
  MenuOutlined,
  NotificationOutlined,
  SafetyCertificateOutlined,
  SettingOutlined,
  SolutionOutlined,
  TeamOutlined,
  ToolOutlined,
  UserOutlined,
  WalletOutlined
} from "@ant-design/icons";
import { Button, Drawer, Layout, Menu, Typography } from "antd";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Outlet, useLocation, useNavigate } from "react-router-dom";

import { LanguageSwitcher } from "../../shared/i18n/LanguageSwitcher";
import { useAccess } from "../../shared/auth/access";
import { clearDevToken } from "../../shared/config/devSettingsStore";
import { NotificationBell } from "../../shared/ui/NotificationBell";

const { Header, Content, Sider } = Layout;
const { Text } = Typography;

const navItems = [
  { key: "/dashboard", icon: <DashboardOutlined />, labelKey: "nav.dashboard", permission: "dashboard:read" },
  { key: "/departments", icon: <TeamOutlined />, labelKey: "nav.departments", permission: "department:read" },
  { key: "/employees", icon: <UserOutlined />, labelKey: "nav.employees", permission: "employee:read" },
  { key: "/recruitment", icon: <SolutionOutlined />, labelKey: "nav.recruitment", permission: "recruitment:read" },
  { key: "/leave", icon: <CalendarOutlined />, labelKey: "nav.leave", permission: "leave:read" },
  { key: "/payroll", icon: <WalletOutlined />, labelKey: "nav.payroll", permission: "payroll:read" },
  { key: "/performance", icon: <SolutionOutlined />, labelKey: "nav.performance", permission: "performance:read" },
  { key: "/documents", icon: <FileOutlined />, labelKey: "nav.documents", permission: "document:read" },
  { key: "/onboarding", icon: <CompassOutlined />, labelKey: "nav.onboarding", permission: "onboarding:read" },
  { key: "/training", icon: <BookOutlined />, labelKey: "nav.training", permission: "training:read" },
  { key: "/assets", icon: <ToolOutlined />, labelKey: "nav.assets", permission: "asset:read" },
  { key: "/announcements", icon: <NotificationOutlined />, labelKey: "nav.announcements", permission: "announcement:read" },
  { key: "/audit", icon: <AuditOutlined />, labelKey: "nav.audit", permission: "audit:read" },
  { key: "/authorization", icon: <SafetyCertificateOutlined />, labelKey: "nav.authorization", permission: "authz:read" },
  { key: "/settings", icon: <SettingOutlined />, labelKey: "nav.settings" }
];

export function AdminShell() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const access = useAccess();
  const visibleNavItems = navItems.filter((item) => !item.permission || access.hasAuthority(item.permission));
  const selectedKey = visibleNavItems.find((item) => location.pathname.startsWith(item.key))?.key ?? "";
  const menuItems = visibleNavItems.map((item) => ({ key: item.key, icon: item.icon, label: t(item.labelKey) }));

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
        <div className="app-shell__brand">{t("app.adminBrand")}</div>
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
            <Text strong>{t("app.adminWorkspace")}</Text>
          </div>
          <div className="app-shell__status">
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
        title={t("app.adminBrand")}
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
