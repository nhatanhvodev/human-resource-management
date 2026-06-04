import { createBrowserRouter, Navigate } from "react-router-dom";

import ErrorPage from "./ErrorPage";
import { AdminShell } from "./layout/AdminShell";
import { EmployeeShell } from "./layout/EmployeeShell";
import DashboardPage from "../features/dashboard/DashboardPage";
import DepartmentsPage from "../features/departments/DepartmentsPage";
import EmployeesPage from "../features/employees/EmployeesPage";
import LeavePage from "../features/leave/LeavePage";
import PayrollPage from "../features/payroll/PayrollPage";
import PerformancePage from "../features/performance/PerformancePage";
import RecruitmentPage from "../features/recruitment/RecruitmentPage";
import DevSettingsPage from "../features/settings/DevSettingsPage";

const PlaceholderPage = ({ title }: { title: string }) => (
  <div style={{ padding: 24 }}><h2>{title}</h2><p>Coming soon</p></div>
);

export const router = createBrowserRouter([
  {
    path: "/",
    element: <AdminShell />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/dashboard" replace /> },
      { path: "dashboard", element: <DashboardPage /> },
      { path: "departments", element: <DepartmentsPage /> },
      { path: "employees", element: <EmployeesPage /> },
      { path: "recruitment", element: <RecruitmentPage /> },
      { path: "leave", element: <LeavePage /> },
      { path: "payroll", element: <PayrollPage /> },
      { path: "performance", element: <PerformancePage /> },
      { path: "attendance", element: <PlaceholderPage title="Chấm công" /> },
      { path: "documents", element: <PlaceholderPage title="Tài liệu" /> },
      { path: "onboarding", element: <PlaceholderPage title="Onboarding" /> },
      { path: "training", element: <PlaceholderPage title="Đào tạo" /> },
      { path: "assets", element: <PlaceholderPage title="Tài sản" /> },
      { path: "announcements", element: <PlaceholderPage title="Thông báo" /> },
      { path: "audit", element: <PlaceholderPage title="Nhật ký hệ thống" /> },
      { path: "settings", element: <DevSettingsPage /> }
    ]
  },
  {
    path: "/ess",
    element: <EmployeeShell />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/ess/dashboard" replace /> },
      { path: "dashboard", element: <PlaceholderPage title="Tổng quan" /> },
      { path: "profile", element: <PlaceholderPage title="Hồ sơ" /> },
      { path: "payslips", element: <PlaceholderPage title="Phiếu lương" /> },
      { path: "leave", element: <PlaceholderPage title="Nghỉ phép" /> },
      { path: "attendance", element: <PlaceholderPage title="Chấm công" /> },
      { path: "documents", element: <PlaceholderPage title="Tài liệu" /> },
      { path: "onboarding", element: <PlaceholderPage title="Onboarding" /> },
      { path: "training", element: <PlaceholderPage title="Đào tạo" /> }
    ]
  }
]);
