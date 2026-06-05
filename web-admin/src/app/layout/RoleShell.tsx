import { AdminShell } from "./AdminShell";
import { EmployeeShell } from "./EmployeeShell";
import { ManagerShell } from "./ManagerShell";
import { useRole } from "../../shared/auth/useRole";

export function RoleShell() {
  const role = useRole();

  if (role === "ADMIN" || role === "HR_MANAGER") {
    return <AdminShell />;
  }
  if (role === "LINE_MANAGER") {
    return <ManagerShell />;
  }
  return <EmployeeShell />;
}
