export type DevSettings = {
  token: string;
  tenantId: string;
};

const TOKEN_KEY = "hrms.dev.token";
const TENANT_KEY = "hrms.dev.tenant";
export const DEV_SETTINGS_CHANGED = "hrms.dev.settings.changed";

function readStorage(key: string): string {
  if (typeof window === "undefined") {
    return "";
  }

  return window.localStorage.getItem(key) ?? "";
}

export function loadDevSettings(): DevSettings {
  return {
    token: readStorage(TOKEN_KEY),
    tenantId: readStorage(TENANT_KEY)
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
