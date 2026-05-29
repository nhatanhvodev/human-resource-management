import { Typography } from "antd";
import { createBrowserRouter } from "react-router-dom";

import { AppShell } from "./layout/AppShell";

function PlaceholderDashboard() {
  return <Typography.Text>Dashboard</Typography.Text>;
}

export const router = createBrowserRouter([
  {
    path: "/",
    element: <AppShell />,
    children: [
      {
        index: true,
        element: <PlaceholderDashboard />
      }
    ]
  }
]);
