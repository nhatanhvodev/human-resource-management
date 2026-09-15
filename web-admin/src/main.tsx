import "antd/dist/reset.css";
import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider } from "react-router-dom";

import { QueryClientProvider } from "@tanstack/react-query";
import { router } from "./app/router";
import { AccessProvider } from "./shared/auth/access";
import { queryClient } from "./shared/api/query";
import { ErrorBoundary } from "./shared/ui/ErrorBoundary";
import "./app/styles.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <AccessProvider>
          <RouterProvider router={router} future={{ v7_startTransition: true }} />
        </AccessProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  </React.StrictMode>
);
