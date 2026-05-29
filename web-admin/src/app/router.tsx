import { createBrowserRouter, Navigate } from "react-router-dom";

import { AppShell } from "./layout/AppShell";
import DashboardPage from "../features/dashboard/DashboardPage";
import DepartmentsPage from "../features/departments/DepartmentsPage";
import EmployeesPage from "../features/employees/EmployeesPage";
import LeavePage from "../features/leave/LeavePage";
import PayrollPage from "../features/payroll/PayrollPage";
import RecruitmentPage from "../features/recruitment/RecruitmentPage";
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
        path: "departments",
        element: <DepartmentsPage />
      },
      {
        path: "employees",
        element: <EmployeesPage />
      },
      {
        path: "recruitment",
        element: <RecruitmentPage />
      },
      {
        path: "leave",
        element: <LeavePage />
      },
      {
        path: "payroll",
        element: <PayrollPage />
      },
      {
        path: "settings",
        element: <DevSettingsPage />
      }
    ]
  }
]);
