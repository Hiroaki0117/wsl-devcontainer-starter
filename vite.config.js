import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  // コンテナーの中では localhost が IPv6 (::1) だけを指すことがあり、
  // VS Code のポート転送 (127.0.0.1) が届かない。全てのアドレスで待ち受ける
  server: { host: true },
})
