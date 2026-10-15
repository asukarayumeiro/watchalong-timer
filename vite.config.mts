import { resolve } from "path";
import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import Sitemap from "vite-plugin-sitemap";

const sitemapConfig = {
  hostname: "https://yota-2026.github.io/watchalong-timer/",
};

export default defineConfig({
  base: "/watchalong-timer/",
  plugins: [elmPlugin(), Sitemap(sitemapConfig)],
  build: {
    rollupOptions: {
      input: {
        main: resolve("index.html"),
        en: resolve("en.html"),
      },
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: "modern-compiler",
      },
    },
  },
});
