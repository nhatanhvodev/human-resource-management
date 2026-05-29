import axios, { AxiosHeaders } from "axios";

import { loadDevSettings } from "../config/devSettingsStore";

export type DevSettings = { token: string; tenantId: string };

export function buildHeaders(settings: DevSettings) {
  const headers: { Authorization?: string; "X-Tenant-Id": string } = {
    "X-Tenant-Id": settings.tenantId
  };

  const token = settings.token.trim();
  if (token) {
    headers.Authorization = `Bearer ${token}`;
  }

  return headers;
}

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? "/api/v1"
});

apiClient.interceptors.request.use((config) => {
  const mergedHeaders = AxiosHeaders.from(config.headers);
  const headers = buildHeaders(loadDevSettings());

  mergedHeaders.set("X-Tenant-Id", headers["X-Tenant-Id"]);
  if (headers.Authorization) {
    mergedHeaders.set("Authorization", headers.Authorization);
  } else {
    mergedHeaders.delete("Authorization");
  }

  config.headers = mergedHeaders;
  return config;
});
