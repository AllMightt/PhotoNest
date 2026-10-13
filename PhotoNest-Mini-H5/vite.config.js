import { defineConfig } from 'vite'
import uniPackage from '@dcloudio/vite-plugin-uni'

const uni = uniPackage.default || uniPackage

export default defineConfig({
  plugins: [uni()],
  test: {
    environment: 'node',
    include: ['src/**/*.test.js']
  },
  server: {
    port: 5175,
    host: true,
    proxy: {
      '/dev-api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/dev-api/, '')
      }
    }
  }
})
