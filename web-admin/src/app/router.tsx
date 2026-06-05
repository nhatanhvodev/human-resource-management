import { createBrowserRouter, Navigate } from "react-router-dom";
import { lazy, Suspense } from "react";
import { Result, Spin } from "antd";
import { useTranslation } from "react-i18next";

import ErrorPage from "./ErrorPage";
import { RoleShell } from "./layout/RoleShell";
import { EmployeeShell } from "./layout/EmployeeShell";
import DashboardPage from "../features/dashboard/DashboardPage";
import DepartmentsPage from "../features/departments/DepartmentsPage";
import EmployeesPage from "../features/employees/EmployeesPage";
import LeavePage from "../features/leave/LeavePage";
import PayrollPage from "../features/payroll/PayrollPage";
import PerformancePage from "../features/performance/PerformancePage";
import RecruitmentPage from "../features/recruitment/RecruitmentPage";
import DevSettingsPage from "../features/settings/DevSettingsPage";
import AttendancePage from "../features/attendance/AttendancePage";
import DocumentsPage from "../features/documents/DocumentsPage";
import OnboardingPage from "../features/onboarding/OnboardingPage";
import TrainingPage from "../features/training/TrainingPage";
import CourseDetailPage from "../features/training/CourseDetailPage";
import AssetsPage from "../features/assets/AssetsPage";
import AnnouncementsPage from "../features/announcements/AnnouncementsPage";
import AuditLogPage from "../features/audit/AuditLogPage";
import AuthorizationPage from "../features/authorization/AuthorizationPage";
import { hasAuthority } from "../shared/auth/jwt";

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

const RequireAuthority = ({ authority, children }: { authority: string; children: React.ReactNode }) => {
  const { t } = useTranslation();
  if (!hasAuthority(authority)) {
    return <Result status="403" title="403" subTitle={t("auth.forbidden")} />;
  }

  return children;
};

export const router = createBrowserRouter([
  {
    path: "/",
    element: <RoleShell />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/dashboard" replace /> },
      { path: "dashboard", element: <RequireAuthority authority="dashboard:read"><DashboardPage /></RequireAuthority> },
      { path: "departments", element: <RequireAuthority authority="department:read"><DepartmentsPage /></RequireAuthority> },
      { path: "employees", element: <RequireAuthority authority="employee:read"><EmployeesPage /></RequireAuthority> },
      { path: "recruitment", element: <RequireAuthority authority="recruitment:read"><RecruitmentPage /></RequireAuthority> },
      { path: "leave", element: <RequireAuthority authority="leave:read"><LeavePage /></RequireAuthority> },
      { path: "payroll", element: <RequireAuthority authority="payroll:read"><PayrollPage /></RequireAuthority> },
      { path: "performance", element: <RequireAuthority authority="performance:read"><PerformancePage /></RequireAuthority> },
      { path: "attendance", element: <RequireAuthority authority="attendance:read"><AttendancePage /></RequireAuthority> },
      { path: "documents", element: <RequireAuthority authority="document:read"><DocumentsPage /></RequireAuthority> },
      { path: "onboarding", element: <RequireAuthority authority="onboarding:read"><OnboardingPage /></RequireAuthority> },
      { path: "training", element: <RequireAuthority authority="training:read"><TrainingPage /></RequireAuthority> },
      { path: "training/courses/:id", element: <RequireAuthority authority="training:read"><CourseDetailPage /></RequireAuthority> },
      { path: "assets", element: <RequireAuthority authority="asset:read"><AssetsPage /></RequireAuthority> },
      { path: "announcements", element: <RequireAuthority authority="announcement:read"><AnnouncementsPage /></RequireAuthority> },
      { path: "audit", element: <RequireAuthority authority="audit:read"><AuditLogPage /></RequireAuthority> },
      { path: "authorization", element: <RequireAuthority authority="authz:read"><AuthorizationPage /></RequireAuthority> },
      { path: "settings", element: <DevSettingsPage /> }
    ]
  },
  {
    path: "/manager",
    element: <RoleShell />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/manager/dashboard" replace /> },
      { path: "dashboard", element: <RequireAuthority authority="dashboard:read"><DashboardPage /></RequireAuthority> },
      { path: "employees", element: <RequireAuthority authority="employee:read"><EmployeesPage /></RequireAuthority> },
      { path: "leave", element: <RequireAuthority authority="leave:read"><LeavePage /></RequireAuthority> },
      { path: "attendance", element: <RequireAuthority authority="attendance:read"><AttendancePage /></RequireAuthority> },
      { path: "documents", element: <RequireAuthority authority="document:read"><DocumentsPage /></RequireAuthority> },
      { path: "training", element: <RequireAuthority authority="training:read"><TrainingPage /></RequireAuthority> },
      { path: "announcements", element: <RequireAuthority authority="announcement:read"><AnnouncementsPage /></RequireAuthority> },
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
