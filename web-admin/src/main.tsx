import "antd/dist/reset.css";
import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider } from "react-router-dom";

import { router } from "./app/router";
import { AccessProvider } from "./shared/auth/access";
import "./app/styles.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <AccessProvider>
      <RouterProvider router={router} future={{ v7_startTransition: true }} />
    </AccessProvider>
  </React.StrictMode>
);
