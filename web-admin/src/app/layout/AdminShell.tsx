import {
  AuditOutlined,
  BookOutlined,
  CalendarOutlined,
  ClockCircleOutlined,
  CompassOutlined,
  DashboardOutlined,
  FileOutlined,
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
import { Button, Drawer, Layout, Menu, Tag, Typography } from "antd";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { Outlet, useLocation, useNavigate } from "react-router-dom";

import { LanguageSwitcher } from "../../shared/i18n/LanguageSwitcher";
import { getAuthorities } from "../../shared/auth/jwt";
import { DEV_SETTINGS_CHANGED, loadDevSettings } from "../../shared/config/devSettingsStore";
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
  { key: "/attendance", icon: <ClockCircleOutlined />, labelKey: "nav.attendance", permission: "attendance:read" },
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
  const [devSettings, setDevSettings] = useState(loadDevSettings);
  const authorities = getAuthorities(devSettings.token);
  const visibleNavItems = navItems.filter((item) => !item.permission || authorities.includes(item.permission));
  const selectedKey = visibleNavItems.find((item) => location.pathname.startsWith(item.key))?.key ?? "/settings";
  const menuItems = visibleNavItems.map((item) => ({ key: item.key, icon: item.icon, label: t(item.labelKey) }));

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
            <Tag
              className="app-shell__status-tag"
              color={devSettings.tenantId ? "blue" : "default"}
              title={`${t("app.tenantId")}: ${devSettings.tenantId || t("app.notSet")}`}
            >
              <span className="app-shell__status-full">
                {t("app.tenantId")}: {devSettings.tenantId || t("app.notSet")}
              </span>
              <span className="app-shell__status-short">
                {t("app.tenantShort")} {devSettings.tenantId || "?"}
              </span>
            </Tag>
            <Tag
              className="app-shell__status-tag"
              color={devSettings.token ? "green" : "gold"}
              title={`Token: ${devSettings.token ? t("app.tokenReady") : t("app.tokenMissing")}`}
            >
              <span className="app-shell__status-full">
                Token: {devSettings.token ? t("app.tokenReady") : t("app.tokenMissing")}
              </span>
              <span className="app-shell__status-short">
                Token {devSettings.token ? "OK" : t("app.tokenMissing")}
              </span>
            </Tag>
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
