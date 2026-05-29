import {
  DashboardOutlined,
  SettingOutlined,
  TeamOutlined,
  UserOutlined,
  SolutionOutlined,
  CalendarOutlined,
  WalletOutlined
} from "@ant-design/icons";
import { Layout, Menu, Typography } from "antd";
import { Outlet, useLocation, useNavigate } from "react-router-dom";

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
  const selectedKey = navItems.find((item) => location.pathname.startsWith(item.key))?.key ?? "/dashboard";

  return (
    <Layout className="app-shell">
      <Sider className="app-shell__sider" width={232} theme="light" breakpoint="lg" collapsedWidth={0}>
        <div className="app-shell__brand">HRMS Admin</div>
        <Menu
          mode="inline"
          selectedKeys={[selectedKey]}
          items={navItems}
          onClick={({ key }) => navigate(key)}
        />
      </Sider>
      <Layout>
        <Header className="app-shell__header">
          <Text strong>Admin workspace</Text>
          <Text type="secondary">Dev tenant mode</Text>
        </Header>
        <Content className="app-shell__content">
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
