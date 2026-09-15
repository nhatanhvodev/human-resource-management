export type DevSettings = {
  token: string;
  tenantId: string;
};

const TOKEN_KEY = "hrms.dev.token";
const TENANT_KEY = "hrms.dev.tenant";
const DEFAULT_LOCAL_TENANT = "default";
export const DEV_SETTINGS_CHANGED = "hrms.dev.settings.changed";

const MAX_TOKEN_LEN = 8192;
const MAX_TENANT_LEN = 64;

// P0: keep an in-memory copy so a malicious script that only gets
// localStorage-read timing still races logout; also lets us drop expired
// JWTs without sending them to the server first.
let memoryToken: string | null = null;

function sanitizeTenant(raw: string, fallback = ""): string {
  const t = raw.trim().toLowerCase();
  if (!t || t.length > MAX_TENANT_LEN || !/^[a-z0-9][a-z0-9_-]*$/.test(t)) {
    return fallback;
  }
  return t;
}

function sanitizeToken(raw: string): string {
  const t = raw.trim();
  if (!t || t.length > MAX_TOKEN_LEN || /\s/.test(t)) {
    return "";
  }
  return t;
}

function isExpiredJwt(token: string): boolean {
  const parts = token.split(".");
  if (parts.length !== 3) return false; // opaque dev-token: leave to server
  try {
    const payload = JSON.parse(atob(parts[1].replace(/-/g, "+").replace(/_/g, "/")));
    if (typeof payload.exp === "number") {
      return payload.exp * 1000 <= Date.now() - 30_000;
    }
  } catch {
    return false;
  }
  return false;
}

function readStorage(key: string, fallback = ""): string {
  if (typeof window === "undefined") {
    return fallback;
  }

  const stored = window.localStorage.getItem(key);
  return stored?.trim() ? stored : fallback;
}

function defaultValue(value: string): string {
  return import.meta.env.DEV ? value : "";
}

export function loadDevSettings(): DevSettings {
  if (memoryToken !== null) {
    const tenant = sanitizeTenant(readStorage(TENANT_KEY, defaultValue(DEFAULT_LOCAL_TENANT)), defaultValue(DEFAULT_LOCAL_TENANT));
    if (memoryToken && isExpiredJwt(memoryToken)) {
      clearDevToken();
      return { token: "", tenantId: tenant };
    }
    return { token: memoryToken, tenantId: tenant };
  }
  const token = sanitizeToken(readStorage(TOKEN_KEY));
  const tenant = sanitizeTenant(readStorage(TENANT_KEY, defaultValue(DEFAULT_LOCAL_TENANT)), defaultValue(DEFAULT_LOCAL_TENANT));
  if (token && isExpiredJwt(token)) {
    clearDevToken();
    return { token: "", tenantId: tenant };
  }
  memoryToken = token || null;
  return {
    token,
    tenantId: tenant
  };
}

export function saveDevSettings(settings: DevSettings): void {
  if (typeof window === "undefined") {
    return;
  }

  // Explicit dev override (DevSettings page): still persisted on purpose.
  const token = sanitizeToken(settings.token);
  const tenant = sanitizeTenant(settings.tenantId, DEFAULT_LOCAL_TENANT);
  memoryToken = token || null;
  window.localStorage.setItem(TOKEN_KEY, token);
  window.localStorage.setItem(TENANT_KEY, tenant);
  window.dispatchEvent(new Event(DEV_SETTINGS_CHANGED));
}

/**
 * P3: normal login sessions keep the access token in memory only.
 * Persistence across reloads comes from the httpOnly refresh cookie
 * (silent refresh on boot), not from localStorage.
 */
export function saveSessionToken(token: string, tenantId: string): void {
  memoryToken = sanitizeToken(token) || null;
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(TENANT_KEY, sanitizeTenant(tenantId, DEFAULT_LOCAL_TENANT));
  window.dispatchEvent(new Event(DEV_SETTINGS_CHANGED));
}

export function clearDevToken(): void {
  memoryToken = null;
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.removeItem(TOKEN_KEY);
  window.dispatchEvent(new Event(DEV_SETTINGS_CHANGED));
}
