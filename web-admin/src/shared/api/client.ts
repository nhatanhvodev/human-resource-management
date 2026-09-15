import axios, { AxiosHeaders, type RawAxiosHeaders } from "axios";

import { clearDevToken, loadDevSettings, saveSessionToken } from "../config/devSettingsStore";

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

function isRefreshRequest(url?: string): boolean {
  return Boolean(url?.endsWith("/auth/refresh"));
}

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? "/api/v1";

// Bare instance (no interceptors) so refresh never recurses into itself.
const refreshHttp = axios.create({ baseURL: API_BASE, withCredentials: true });

type RefreshResponse = { token: string; tenantId: string };

let refreshPromise: Promise<string> | null = null;

/**
 * P3: single-flight silent refresh using the httpOnly cookie.
 * Resolves with the new access token (also stored in memory).
 */
export function trySilentRefresh(): Promise<string> {
  if (!refreshPromise) {
    refreshPromise = (async () => {
      const settings = loadDevSettings();
      const res = await refreshHttp.post<RefreshResponse>("/auth/refresh", null, {
        headers: { "X-Tenant-Id": settings.tenantId || "default" },
      });
      saveSessionToken(res.data.token, res.data.tenantId || settings.tenantId);
      return res.data.token;
    })().finally(() => {
      refreshPromise = null;
    });
  }
  return refreshPromise;
}

export const apiClient = axios.create({
  baseURL: API_BASE,
  // Send the refresh cookie on same-origin (vite proxy) and credentialed CORS.
  withCredentials: true,
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

// Response interceptor: handle 401, 403, and 5xx globally.
// P0 fix: never redirect for the login call itself (wrong password would wipe
// state and loop), never redirect twice, and never redirect when already on
// /login — otherwise a single expired token causes an infinite reload loop.
// P3: on 401, try one silent refresh + retry before giving up.
let redirectingToLogin = false;
function redirectToLoginOnce(): void {
  if (redirectingToLogin) return;
  if (typeof window !== "undefined" && window.location.pathname === "/login") return;
  redirectingToLogin = true;
  clearDevToken();
  window.location.href = "/login";
}

export function resetLoginRedirectForTests(): void {
  redirectingToLogin = false;
}

apiClient.interceptors.response.use(
  (response) => response,
  async (error: import("axios").AxiosError) => {
    const status = error.response?.status;
    const url = error.config?.url ?? "";
    const original = error.config as (import("axios").AxiosRequestConfig & { _retried?: boolean }) | undefined;

    if (status === 401) {
      if (!isLoginRequest(url) && !isRefreshRequest(url) && original && !original._retried) {
        original._retried = true;
        try {
          const token = await trySilentRefresh();
          const headers = AxiosHeaders.from(original.headers as unknown as RawAxiosHeaders | undefined);
          headers.set("Authorization", `Bearer ${token}`);
          original.headers = headers.toJSON();
          return await apiClient(original);
        } catch {
          // Refresh failed → fall through to login redirect.
        }
      }
      if (!isLoginRequest(url) && !isRefreshRequest(url)) {
        redirectToLoginOnce();
      }
    } else if (status === 403) {
      console.error("Access forbidden (403):", error.config?.url);
    } else if (status && status >= 500) {
      console.error("Server error:", status, error.config?.url);
    }

    return Promise.reject(error);
  }
);
