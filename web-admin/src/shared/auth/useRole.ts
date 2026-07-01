import { useMemo } from "react";

import { useAccess } from "./access";

type Role = "ADMIN" | "HR_MANAGER" | "LINE_MANAGER" | "EMPLOYEE";

const ROLE_PRIORITY: Role[] = ["ADMIN", "HR_MANAGER", "LINE_MANAGER", "EMPLOYEE"];

export function useRole(): Role {
  const access = useAccess();
  return useMemo(() => {
    const roles = access.roles;
    for (const role of ROLE_PRIORITY) {
      if (roles.includes(role)) {
        return role;
      }
    }
    return "EMPLOYEE";
  }, [access.roles]);
}
