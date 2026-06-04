import {
  DashboardOutlined,
  SettingOutlined,
  TeamOutlined,
  UserOutlined,
  SolutionOutlined,
  CalendarOutlined,
  WalletOutlined,
  ClockCircleOutlined,
  FileOutlined,
  CompassOutlined,
  BookOutlined,
  ToolOutlined,
  NotificationOutlined,
  AuditOutlined,
  MenuOutlined
} from "@ant-design/icons";
import { Button, Drawer, Layout, Menu, Tag, Typography } from "antd";
import { useEffect, useState } from "react";
import { Outlet, useLocation, useNavigate } from "react-router-dom";

import { DEV_SETTINGS_CHANGED, loadDevSettings } from "../../shared/config/devSettingsStore";

const { Header, Content, Sider } = Layout;
const { Text } = Typography;

const navItems = [
  { key: "/dashboard", icon: <DashboardOutlined />, label: "Tổng quan" },
  { key: "/departments", icon: <TeamOutlined />, label: "Phòng ban" },
  { key: "/employees", icon: <UserOutlined />, label: "Nhân viên" },
  { key: "/recruitment", icon: <SolutionOutlined />, label: "Tuyển dụng" },
  { key: "/leave", icon: <CalendarOutlined />, label: "Nghỉ phép" },
  { key: "/payroll", icon: <WalletOutlined />, label: "Bảng lương" },
  { key: "/performance", icon: <SolutionOutlined />, label: "Đánh giá" },
  { key: "/attendance", icon: <ClockCircleOutlined />, label: "Chấm công" },
  { key: "/documents", icon: <FileOutlined />, label: "Tài liệu" },
  { key: "/onboarding", icon: <CompassOutlined />, label: "Onboarding" },
  { key: "/training", icon: <BookOutlined />, label: "Đào tạo" },
  { key: "/assets", icon: <ToolOutlined />, label: "Tài sản" },
  { key: "/announcements", icon: <NotificationOutlined />, label: "Thông báo" },
  { key: "/audit", icon: <AuditOutlined />, label: "Nhật ký" },
  { key: "/settings", icon: <SettingOutlined />, label: "Thiết lập" }
];

export function AdminShell() {
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
        <div className="app-shell__brand">Quản trị nhân sự</div>
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
              aria-label="Mở điều hướng"
              onClick={() => setMobileNavOpen(true)}
            />
            <Text strong>Không gian quản trị</Text>
          </div>
          <div className="app-shell__status">
            <Tag className="app-shell__status-tag" color={devSettings.tenantId ? "blue" : "default"} title={`Mã đơn vị: ${devSettings.tenantId || "chưa thiết lập"}`}>
              <span className="app-shell__status-full">Mã đơn vị: {devSettings.tenantId || "chưa thiết lập"}</span>
              <span className="app-shell__status-short">Đơn vị {devSettings.tenantId || "?"}</span>
            </Tag>
            <Tag className="app-shell__status-tag" color={devSettings.token ? "green" : "gold"} title={`Token: ${devSettings.token ? "đã có" : "thiếu"}`}>
              <span className="app-shell__status-full">Token: {devSettings.token ? "đã có" : "thiếu"}</span>
              <span className="app-shell__status-short">Token {devSettings.token ? "OK" : "thiếu"}</span>
            </Tag>
          </div>
        </Header>
        <Content className="app-shell__content">
          <Outlet />
        </Content>
      </Layout>
      <Drawer
        className="app-shell__mobile-nav"
        title="Quản trị nhân sự"
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
