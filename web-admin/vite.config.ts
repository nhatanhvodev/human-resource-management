import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: "autoUpdate",
      includeAssets: ["icon-192.png", "icon-512.png"],
      manifest: {
        name: "HRMS",
        short_name: "HRMS",
        description: "Human Resource Management System",
        start_url: "/",
        scope: "/",
        display: "standalone",
        background_color: "#ffffff",
        theme_color: "#1677ff",
        icons: [
          { src: "/icon-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
          { src: "/icon-512.png", sizes: "512x512", type: "image/png", purpose: "any" },
          { src: "/icon-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" }
        ]
      },
      workbox: {
        globPatterns: ["**/*.{js,css,html,ico,png,svg}"],
        maximumFileSizeToCacheInBytes: 5 * 1024 * 1024
      }
    })
  ],
  server: {
    proxy: {
      "/api": "http://localhost:8080"
    }
  },
  build: {
    chunkSizeWarningLimit: 600,
    rollupOptions: {
      output: {
        // P1: vendor splits — antd/echarts/react load in parallel and stay
        // cached across deploys instead of invalidating one giant bundle.
        manualChunks: {
          antd: ["antd", "@ant-design/icons"],
          echarts: ["echarts", "echarts-for-react"],
          vendor: ["react", "react-dom", "react-router-dom", "@tanstack/react-query", "axios", "i18next", "react-i18next"],
        },
      },
    },
  },
});
