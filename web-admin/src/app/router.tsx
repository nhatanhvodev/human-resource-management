import { createBrowserRouter, Navigate } from "react-router-dom";

import { AppShell } from "./layout/AppShell";
import DashboardPage from "../features/dashboard/DashboardPage";
import DevSettingsPage from "../features/settings/DevSettingsPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <AppShell />,
    children: [
      {
        index: true,
        element: <Navigate to="/dashboard" replace />
      },
      {
        path: "dashboard",
        element: <DashboardPage />
      },
      {
        path: "settings",
        element: <DevSettingsPage />
      }
    ]
  }
]);
