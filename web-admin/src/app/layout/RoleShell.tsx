import { AdminShell } from "./AdminShell";
import { EmployeeShell } from "./EmployeeShell";
import { ManagerShell } from "./ManagerShell";
import { useAccess } from "../../shared/auth/access";
import { useRole } from "../../shared/auth/useRole";
import { Navigate } from "react-router-dom";
import { Spin } from "antd";

export function RoleShell() {
  const access = useAccess();
  const role = useRole();

  if (access.loading) {
    return (
      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", height: "100vh" }}>
        <Spin size="large" />
      </div>
    );
  }
  if (!access.access?.userId) {
    return <Navigate to="/login" replace />;
  }
  if (role === "ADMIN" || role === "HR_MANAGER") {
    return <AdminShell />;
  }
  if (role === "LINE_MANAGER") {
    return <ManagerShell />;
  }
  return <EmployeeShell />;
}
