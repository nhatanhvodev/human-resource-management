import { useMemo } from "react";

import { getJwtPayload, getToken, LOCAL_DEV_TOKEN } from "./jwt";

type Role = "ADMIN" | "HR_MANAGER" | "LINE_MANAGER" | "EMPLOYEE";

const ROLE_PRIORITY: Role[] = ["ADMIN", "HR_MANAGER", "LINE_MANAGER", "EMPLOYEE"];

export function useRole(): Role {
  return useMemo(() => {
    const token = getToken();
    if (token === LOCAL_DEV_TOKEN) {
      return "ADMIN";
    }

    const payload = getJwtPayload(token);
    const roles = payload?.roles ?? (payload?.role ? [payload.role] : []);
    for (const role of ROLE_PRIORITY) {
      if (roles.includes(role)) {
        return role;
      }
    }
    return "EMPLOYEE";
  }, []);
}
