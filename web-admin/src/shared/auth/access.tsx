import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";

import { apiClient, trySilentRefresh } from "../api/client";
import { DEV_SETTINGS_CHANGED, loadDevSettings } from "../config/devSettingsStore";

type AccessSnapshot = {
  userId: string | null;
  username: string;
  displayName: string;
  employeeId: string | null;
  roles: string[];
  authorities: string[];
};

type AccessState = {
  access: AccessSnapshot | null;
  authorities: string[];
  roles: string[];
  loading: boolean;
  error: boolean;
  hasAuthority: (authority: string) => boolean;
  reload: () => Promise<AccessSnapshot>;
};

const AccessContext = createContext<AccessState | null>(null);

const EMPTY_ACCESS: AccessSnapshot = {
  userId: null,
  username: "",
  displayName: "",
  employeeId: null,
  roles: [],
  authorities: []
};

export function AccessProvider({ children }: { children: React.ReactNode }) {
  const [access, setAccess] = useState<AccessSnapshot | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  const loadAccess = useCallback(async () => {
    const settings = loadDevSettings();
    if (!settings.token.trim()) {
      // P3: no in-memory/persisted token — try the httpOnly refresh cookie
      // once (survives reloads without localStorage) before giving up.
      try {
        await trySilentRefresh();
      } catch {
        setAccess(EMPTY_ACCESS);
        setError(false);
        setLoading(false);
        return EMPTY_ACCESS;
      }
    }

    setLoading(true);
    try {
      const response = await apiClient.get<AccessSnapshot>("/authz/me");
      setAccess(response.data);
      setError(false);
      return response.data;
    } catch (err) {
      console.error("Failed to load access:", err);
      setAccess(EMPTY_ACCESS);
      setError(true);
      return EMPTY_ACCESS;
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadAccess();
    window.addEventListener("storage", loadAccess);
    window.addEventListener(DEV_SETTINGS_CHANGED, loadAccess);
    window.addEventListener("focus", loadAccess);

    return () => {
      window.removeEventListener("storage", loadAccess);
      window.removeEventListener(DEV_SETTINGS_CHANGED, loadAccess);
      window.removeEventListener("focus", loadAccess);
    };
  }, [loadAccess]);

  const value = useMemo<AccessState>(() => {
    const authorities = access?.authorities ?? [];
    return {
      access,
      authorities,
      roles: access?.roles ?? [],
      loading,
      error,
      hasAuthority: (authority: string) => authorities.includes(authority),
      reload: loadAccess
    };
  }, [access, error, loadAccess, loading]);

  return <AccessContext.Provider value={value}>{children}</AccessContext.Provider>;
}

export function useAccess(): AccessState {
  const context = useContext(AccessContext);
  if (!context) {
    throw new Error("useAccess must be used within AccessProvider");
  }
  return context;
}
