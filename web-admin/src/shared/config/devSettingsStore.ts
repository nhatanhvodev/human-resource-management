export type DevSettings = {
  token: string;
  tenantId: string;
};

const TOKEN_KEY = "hrms.dev.token";
const TENANT_KEY = "hrms.dev.tenant";
const DEFAULT_LOCAL_TENANT = "default";
export const DEV_SETTINGS_CHANGED = "hrms.dev.settings.changed";

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
  return {
    token: readStorage(TOKEN_KEY),
    tenantId: readStorage(TENANT_KEY, defaultValue(DEFAULT_LOCAL_TENANT))
  };
}

export function saveDevSettings(settings: DevSettings): void {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(TOKEN_KEY, settings.token);
  window.localStorage.setItem(TENANT_KEY, settings.tenantId);
  window.dispatchEvent(new Event(DEV_SETTINGS_CHANGED));
}

export function clearDevToken(): void {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.removeItem(TOKEN_KEY);
  window.dispatchEvent(new Event(DEV_SETTINGS_CHANGED));
}
