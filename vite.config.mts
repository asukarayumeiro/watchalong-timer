import { resolve } from "path";
import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

export default defineConfig({
  base: "/watchalong-timer/",
  plugins: [elmPlugin()],
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
