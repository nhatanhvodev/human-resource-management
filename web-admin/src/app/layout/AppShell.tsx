import { Layout, Typography } from "antd";
import { Outlet } from "react-router-dom";

const { Header, Content } = Layout;
const { Title } = Typography;

export function AppShell() {
  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Header style={{ display: "flex", alignItems: "center" }}>
        <Title level={4} style={{ color: "#ffffff", margin: 0 }}>
          HRMS Admin
        </Title>
      </Header>
      <Content style={{ padding: 24 }}>
        <Outlet />
      </Content>
    </Layout>
  );
}
