import axios, { AxiosHeaders } from "axios";

import { clearDevToken, loadDevSettings } from "../config/devSettingsStore";

export type DevSettings = { token: string; tenantId: string };
type HeaderOptions = {
  includeAuthorization?: boolean;
  tenantId?: string;
};

export function buildHeaders(settings: DevSettings, options: HeaderOptions = {}) {
  const headers: { Authorization?: string; "X-Tenant-Id": string } = {
    "X-Tenant-Id": options.tenantId?.trim() || settings.tenantId
  };

  const token = settings.token.trim();
  if (options.includeAuthorization !== false && token) {
    headers.Authorization = `Bearer ${token}`;
  }

  return headers;
}

function isLoginRequest(url?: string): boolean {
  return Boolean(url?.endsWith("/auth/login"));
}

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? "/api/v1"
});

apiClient.interceptors.request.use((config) => {
  const mergedHeaders = AxiosHeaders.from(config.headers);
  const loginRequest = isLoginRequest(config.url);
  const explicitTenant = mergedHeaders.get("X-Tenant-Id")?.toString();
  const headers = buildHeaders(loadDevSettings(), {
    includeAuthorization: !loginRequest,
    tenantId: loginRequest ? explicitTenant : undefined
  });

  mergedHeaders.set("X-Tenant-Id", headers["X-Tenant-Id"]);
  if (headers.Authorization) {
    mergedHeaders.set("Authorization", headers.Authorization);
  } else {
    mergedHeaders.delete("Authorization");
  }

  config.headers = mergedHeaders;
  return config;
});

// Response interceptor: handle 401, 403, and 5xx globally
apiClient.interceptors.response.use(
  (response) => response,
  (error: import("axios").AxiosError) => {
    const status = error.response?.status;

    if (status === 401) {
      clearDevToken();
      window.location.href = "/login";
    } else if (status === 403) {
      console.error("Access forbidden (403):", error.config?.url);
    } else if (status && status >= 500) {
      console.error("Server error:", status, error.config?.url);
    }

    return Promise.reject(error);
  }
);
