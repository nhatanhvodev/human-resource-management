import { loadDevSettings } from "../config/devSettingsStore";

export const LOCAL_DEV_TOKEN = "local-test-token";

export const ADMIN_AUTHORITIES = [
  "dashboard:read",
  "department:read",
  "department:create",
  "department:update",
  "department:delete",
  "employee:read",
  "employee:create",
  "employee:update",
  "employee:delete",
  "leave:read",
  "leave:create",
  "leave:approve",
  "payroll:read",
  "payroll:create",
  "payroll:execute",
  "payroll:approve",
  "recruitment:read",
  "recruitment:create",
  "recruitment:update",
  "recruitment:convert",
  "performance:read",
  "performance:create",
  "performance:update",
  "attendance:read",
  "attendance:create",
  "attendance:approve",
  "document:read",
  "document:create",
  "document:delete",
  "notification:create",
  "announcement:read",
  "announcement:create",
  "announcement:delete",
  "onboarding:read",
  "onboarding:create",
  "onboarding:update",
  "onboarding:delete",
  "training:read",
  "training:create",
  "training:update",
  "asset:read",
  "asset:create",
  "asset:update",
  "asset:delete",
  "audit:read",
  "authz:read",
  "authz:update",
  "self:access"
] as const;

type JwtPayload = {
  sub?: string;
  employee_id?: string;
  role?: string;
  roles?: string[];
  authorities?: string[];
  scope?: string;
};

function decodeBase64Url(value: string): string {
  const normalized = value.replace(/-/g, "+").replace(/_/g, "/");
  const padded = normalized.padEnd(Math.ceil(normalized.length / 4) * 4, "=");
  return atob(padded);
}

export function getToken(): string {
  return loadDevSettings().token.trim();
}

export function getJwtPayload(token = getToken()): JwtPayload | null {
  if (!token || token === LOCAL_DEV_TOKEN) {
    return null;
  }

  try {
    const [, payload] = token.split(".");
    if (!payload) {
      return null;
    }
    return JSON.parse(decodeBase64Url(payload)) as JwtPayload;
  } catch {
    return null;
  }
}

export function getAuthorities(token = getToken()): string[] {
  if (token === LOCAL_DEV_TOKEN) {
    return [...ADMIN_AUTHORITIES];
  }

  const payload = getJwtPayload(token);
  if (Array.isArray(payload?.authorities)) {
    return payload.authorities;
  }
  if (payload?.scope) {
    return payload.scope.split(/\s+/).filter(Boolean);
  }
  return [];
}

export function hasAuthority(authority: string, token = getToken()): boolean {
  return getAuthorities(token).includes(authority);
}

export function getEmployeeId(): string {
  const token = getToken();
  if (token === LOCAL_DEV_TOKEN) {
    return "b1000000-0000-4000-8000-000000000001";
  }

  const payload = getJwtPayload(token);
  return payload?.employee_id ?? payload?.sub ?? "";
}
