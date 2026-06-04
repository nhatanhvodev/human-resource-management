import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: "autoUpdate",
      manifest: {
        name: "HRMS",
        short_name: "HRMS",
        theme_color: "#1677ff",
        icons: [
          { src: "/icon-192.png", sizes: "192x192", type: "image/png" }
        ]
      },
      workbox: { globPatterns: ["**/*.{js,css,html,ico,png,svg}"] }
    })
  ],
  server: {
    proxy: {
      "/api": "http://localhost:8080"
    }
  }
});
