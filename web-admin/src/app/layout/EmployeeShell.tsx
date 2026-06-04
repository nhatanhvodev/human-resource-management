import {
  HomeOutlined, UserOutlined, WalletOutlined, CalendarOutlined,
  ClockCircleOutlined, FileOutlined, CompassOutlined, BookOutlined, MenuOutlined
} from '@ant-design/icons';
import { Button, Drawer, Layout, Menu, Typography } from 'antd';
import { useState } from 'react';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';

import { NotificationBell } from '../../shared/ui/NotificationBell';
import { LanguageSwitcher } from '../../shared/i18n/LanguageSwitcher';

const { Header, Content, Sider } = Layout;
const { Text } = Typography;

const navItems = [
  { key: '/ess/dashboard', icon: <HomeOutlined />, label: 'Tổng quan' },
  { key: '/ess/profile', icon: <UserOutlined />, label: 'Hồ sơ' },
  { key: '/ess/payslips', icon: <WalletOutlined />, label: 'Phiếu lương' },
  { key: '/ess/leave', icon: <CalendarOutlined />, label: 'Nghỉ phép' },
  { key: '/ess/attendance', icon: <ClockCircleOutlined />, label: 'Chấm công' },
  { key: '/ess/documents', icon: <FileOutlined />, label: 'Tài liệu' },
  { key: '/ess/onboarding', icon: <CompassOutlined />, label: 'Onboarding' },
  { key: '/ess/training', icon: <BookOutlined />, label: 'Đào tạo' }
];

export function EmployeeShell() {
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const selectedKey = navItems.find((item) => location.pathname.startsWith(item.key))?.key ?? '/ess/dashboard';
  const onNavigate = (key: string) => {
    navigate(key);
    setMobileNavOpen(false);
  };

  return (
    <Layout className="app-shell">
      <Sider className="app-shell__sider" width={232} theme="light" breakpoint="lg" collapsedWidth={0} trigger={null}>
        <div className="app-shell__brand">Nhân viên</div>
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
            <Text strong>Cổng nhân viên</Text>
          </div>
          <div className="app-shell__status" style={{ display: "flex", gap: 8, alignItems: "center" }}>
            <LanguageSwitcher />
            <NotificationBell />
          </div>
        </Header>
        <Content className="app-shell__content">
          <Outlet />
        </Content>
      </Layout>
      <Drawer
        className="app-shell__mobile-nav"
        title="Cổng nhân viên"
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
