import { createBrowserRouter, Navigate } from "react-router-dom";
import { lazy, Suspense } from "react";
import { Result, Spin } from "antd";
import { useTranslation } from "react-i18next";

import ErrorPage from "./ErrorPage";
import { RoleShell } from "./layout/RoleShell";
import { EmployeeShell } from "./layout/EmployeeShell";
import { useAccess } from "../shared/auth/access";
import LoginPage from "../features/auth/LoginPage";

// P1: every route chunk is code-split — the old static imports bundled all
// admin pages (antd + echarts ≈ 2.8MB) into the initial download.
const DashboardPage = lazy(() => import("../features/dashboard/DashboardPage"));
const DepartmentsPage = lazy(() => import("../features/departments/DepartmentsPage"));
const EmployeesPage = lazy(() => import("../features/employees/EmployeesPage"));
const LeavePage = lazy(() => import("../features/leave/LeavePage"));
const PayrollPage = lazy(() => import("../features/payroll/PayrollPage"));
const PerformancePage = lazy(() => import("../features/performance/PerformancePage"));
const RecruitmentPage = lazy(() => import("../features/recruitment/RecruitmentPage"));
const DevSettingsPage = lazy(() => import("../features/settings/DevSettingsPage"));
const DocumentsPage = lazy(() => import("../features/documents/DocumentsPage"));
const OnboardingPage = lazy(() => import("../features/onboarding/OnboardingPage"));
const TrainingPage = lazy(() => import("../features/training/TrainingPage"));
const CourseDetailPage = lazy(() => import("../features/training/CourseDetailPage"));
const AssetsPage = lazy(() => import("../features/assets/AssetsPage"));
const AnnouncementsPage = lazy(() => import("../features/announcements/AnnouncementsPage"));
const AuditLogPage = lazy(() => import("../features/audit/AuditLogPage"));
const AuthorizationPage = lazy(() => import("../features/authorization/AuthorizationPage"));
const AttendancePage = lazy(() => import("../features/attendance/AttendancePage"));

const EssDashboardPage = lazy(() => import("../features/ess/EssDashboardPage"));
const MyProfilePage = lazy(() => import("../features/ess/MyProfilePage"));
const MyPayslipsPage = lazy(() => import("../features/ess/MyPayslipsPage"));
const MyLeavePage = lazy(() => import("../features/ess/MyLeavePage"));
const MyDocumentsPage = lazy(() => import("../features/ess/MyDocumentsPage"));
const MyOnboardingPage = lazy(() => import("../features/ess/MyOnboardingPage"));
const MyTrainingPage = lazy(() => import("../features/ess/MyTrainingPage"));
const MyAttendancePage = lazy(() => import("../features/ess/MyAttendancePage"));

const Lazy = ({ children }: { children: React.ReactNode }) => (
  <Suspense fallback={<Spin style={{ display: 'block', margin: '40px auto' }} />}>{children}</Suspense>
);

const RequireAuthority = ({ authority, children }: { authority: string; children: React.ReactNode }) => {
  const { t } = useTranslation();
  const access = useAccess();
  if (access.loading) {
    return <Spin style={{ display: "block", margin: "40px auto" }} />;
  }
  if (!access.hasAuthority(authority)) {
    return <Result status="403" title="403" subTitle={t("auth.forbidden")} />;
  }

  return children;
};

export const router = createBrowserRouter([
  {
    path: "/login",
    element: <LoginPage />,
    errorElement: <ErrorPage />
  },
  {
    path: "/",
    element: <RoleShell />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/dashboard" replace /> },
      { path: "dashboard", element: <RequireAuthority authority="dashboard:read"><Lazy><DashboardPage /></Lazy></RequireAuthority> },
      { path: "departments", element: <RequireAuthority authority="department:read"><Lazy><DepartmentsPage /></Lazy></RequireAuthority> },
      { path: "employees", element: <RequireAuthority authority="employee:read"><Lazy><EmployeesPage /></Lazy></RequireAuthority> },
      { path: "recruitment", element: <RequireAuthority authority="recruitment:read"><Lazy><RecruitmentPage /></Lazy></RequireAuthority> },
      { path: "leave", element: <RequireAuthority authority="leave:read"><Lazy><LeavePage /></Lazy></RequireAuthority> },
      { path: "attendance", element: <RequireAuthority authority="attendance:read"><Lazy><AttendancePage /></Lazy></RequireAuthority> },
      { path: "payroll", element: <RequireAuthority authority="payroll:read"><Lazy><PayrollPage /></Lazy></RequireAuthority> },
      { path: "performance", element: <RequireAuthority authority="performance:read"><Lazy><PerformancePage /></Lazy></RequireAuthority> },
      { path: "documents", element: <RequireAuthority authority="document:read"><Lazy><DocumentsPage /></Lazy></RequireAuthority> },
      { path: "onboarding", element: <RequireAuthority authority="onboarding:read"><Lazy><OnboardingPage /></Lazy></RequireAuthority> },
      { path: "training", element: <RequireAuthority authority="training:read"><Lazy><TrainingPage /></Lazy></RequireAuthority> },
      { path: "training/courses/:id", element: <RequireAuthority authority="training:read"><Lazy><CourseDetailPage /></Lazy></RequireAuthority> },
      { path: "assets", element: <RequireAuthority authority="asset:read"><Lazy><AssetsPage /></Lazy></RequireAuthority> },
      { path: "announcements", element: <RequireAuthority authority="announcement:read"><Lazy><AnnouncementsPage /></Lazy></RequireAuthority> },
      { path: "audit", element: <RequireAuthority authority="audit:read"><Lazy><AuditLogPage /></Lazy></RequireAuthority> },
      { path: "authorization", element: <RequireAuthority authority="authz:read"><Lazy><AuthorizationPage /></Lazy></RequireAuthority> },
      { path: "settings", element: <RequireAuthority authority="authz:update"><Lazy><DevSettingsPage /></Lazy></RequireAuthority> }
    ]
  },
  {
    path: "/manager",
    element: <RoleShell />,
    errorElement: <ErrorPage />,
    children: [
      { index: true, element: <Navigate to="/manager/dashboard" replace /> },
      { path: "dashboard", element: <RequireAuthority authority="dashboard:read"><Lazy><DashboardPage /></Lazy></RequireAuthority> },
      { path: "employees", element: <RequireAuthority authority="employee:read"><Lazy><EmployeesPage /></Lazy></RequireAuthority> },
      { path: "leave", element: <RequireAuthority authority="leave:read"><Lazy><LeavePage /></Lazy></RequireAuthority> },
      { path: "attendance", element: <RequireAuthority authority="attendance:read"><Lazy><AttendancePage /></Lazy></RequireAuthority> },
      { path: "documents", element: <RequireAuthority authority="document:read"><Lazy><DocumentsPage /></Lazy></RequireAuthority> },
      { path: "training", element: <RequireAuthority authority="training:read"><Lazy><TrainingPage /></Lazy></RequireAuthority> },
      { path: "announcements", element: <RequireAuthority authority="announcement:read"><Lazy><AnnouncementsPage /></Lazy></RequireAuthority> },
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
