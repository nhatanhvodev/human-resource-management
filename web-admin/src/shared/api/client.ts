import axios from "axios";

import { loadDevSettings } from "../config/devSettingsStore";

export type DevSettings = { token: string; tenantId: string };

export function buildHeaders(settings: DevSettings) {
  return {
    Authorization: `Bearer ${settings.token}`,
    "X-Tenant-Id": settings.tenantId
  };
}

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? "/api"
});

apiClient.interceptors.request.use((config) => {
  const settings = loadDevSettings();
  config.headers = {
    ...(config.headers ?? {}),
    ...buildHeaders(settings)
  };
  return config;
});
