import { createBrowserRouter, Navigate } from "react-router-dom";
import { lazy, Suspense } from "react";
import { Spin } from "antd";

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

const EssDashboardPage = lazy(() => import("../features/ess/EssDashboardPage"));
const MyProfilePage = lazy(() => import("../features/ess/MyProfilePage"));
const MyPayslipsPage = lazy(() => import("../features/ess/MyPayslipsPage"));
const MyLeavePage = lazy(() => import("../features/ess/MyLeavePage"));
const MyAttendancePage = lazy(() => import("../features/ess/MyAttendancePage"));
const MyDocumentsPage = lazy(() => import("../features/ess/MyDocumentsPage"));
const MyOnboardingPage = lazy(() => import("../features/ess/MyOnboardingPage"));
const MyTrainingPage = lazy(() => import("../features/ess/MyTrainingPage"));

const Lazy = ({ children }: { children: React.ReactNode }) => (
  <Suspense fallback={<Spin style={{ display: 'block', margin: '40px auto' }} />}>{children}</Suspense>
);

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
      { path: "dashboard", element: <Lazy><EssDashboardPage /></Lazy> },
      { path: "profile", element: <Lazy><MyProfilePage /></Lazy> },
      { path: "payslips", element: <Lazy><MyPayslipsPage /></Lazy> },
      { path: "leave", element: <Lazy><MyLeavePage /></Lazy> },
      { path: "attendance", element: <Lazy><MyAttendancePage /></Lazy> },
      { path: "documents", element: <Lazy><MyDocumentsPage /></Lazy> },
      { path: "onboarding", element: <Lazy><MyOnboardingPage /></Lazy> },
      { path: "training", element: <Lazy><MyTrainingPage /></Lazy> }
    ]
  }
]);
