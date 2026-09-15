import {
  QueryClient,
  useMutation,
  useQuery,
  type UseMutationOptions,
  type UseQueryOptions,
} from "@tanstack/react-query";
import type { AxiosRequestConfig } from "axios";

import { apiClient } from "./client";

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      gcTime: 5 * 60_000,
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

type ApiQueryOptions<T> = Omit<UseQueryOptions<T, Error, T, readonly unknown[]>, "queryKey" | "queryFn"> & {
  config?: AxiosRequestConfig;
};

/**
 * P1: single place for all GETs — caching, dedupe, retries.
 * queryFn still goes through apiClient so auth headers + 401 handling stay central.
 */
export function useApiQuery<T>(key: readonly unknown[], url: string, options?: ApiQueryOptions<T>) {
  const { config, ...queryOptions } = options ?? {};
  return useQuery<T, Error>({
    queryKey: key,
    queryFn: async () => (await apiClient.get<T>(url, config)).data,
    ...queryOptions,
  });
}

type ApiMutationArgs = {
  url: string;
  method?: "post" | "put" | "patch" | "delete";
  config?: AxiosRequestConfig;
};

/**
 * P1: mutations invalidate caller-specified query keys on success,
 * replacing manual refetch chains scattered across pages.
 */
export function useApiMutation<TData = unknown, TVariables = unknown>(
  mutationOptions?: UseMutationOptions<unknown, Error, ApiMutationArgs & { body?: TVariables }, unknown> & {
    invalidateKeys?: readonly unknown[][];
  }
) {
  const { invalidateKeys, onSuccess: callerOnSuccess, ...rest } = mutationOptions ?? {};
  return useMutation<unknown, Error, ApiMutationArgs & { body?: TVariables }, unknown>({
    mutationFn: async ({ url, method = "post", body, config }: ApiMutationArgs & { body?: TVariables }) => {
      // Keep axios call shapes identical to direct apiClient usage so existing
      // call assertions (e.g. delete(url) with a single arg) keep passing.
      if (method === "delete") {
        const res = config
          ? await apiClient.delete<TData>(url, config)
          : await apiClient.delete<TData>(url);
        return res.data;
      }
      if (method === "put") {
        const res = config
          ? await apiClient.put<TData>(url, body, config)
          : await apiClient.put<TData>(url, body);
        return res.data;
      }
      if (method === "patch") {
        const res = config
          ? await apiClient.patch<TData>(url, body, config)
          : await apiClient.patch<TData>(url, body);
        return res.data;
      }
      const res = config
        ? await apiClient.post<TData>(url, body, config)
        : await apiClient.post<TData>(url, body);
      return res.data;
    },
    onSuccess: (
      data: unknown,
      variables: ApiMutationArgs & { body?: TVariables },
      onMutateResult: unknown,
      context: unknown
    ) => {
      invalidateKeys?.forEach((key) => void queryClient.invalidateQueries({ queryKey: key }));
      type CallerSuccess = (d: unknown, v: unknown, r: unknown, c: unknown) => void;
      (callerOnSuccess as unknown as CallerSuccess | undefined)?.(data, variables, onMutateResult, context);
    },
    ...rest,
  });
}

export function asArray<T>(data: unknown): T[] {
  return Array.isArray(data) ? (data as T[]) : [];
}
