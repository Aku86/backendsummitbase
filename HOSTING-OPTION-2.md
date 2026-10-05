# Summit Base — Opsi 2: cPanel Frontend + Node.js Backend

Arsitektur:

- `https://summitbase.my.id` → frontend statis di cPanel ZenHosta
- `https://api.summitbase.my.id` → backend Node.js + MongoDB
- MongoDB → MongoDB Atlas

## 1. Frontend cPanel

Upload **isi folder `frontend-cpanel/`** ke `public_html/` ZenHosta. Jangan upload `server.js` sebagai pengganti `index.html`. File `index.html` harus berada langsung di `public_html`.

Setelah upload, buka `https://summitbase.my.id/`.

File `frontend-cpanel/api-config.js` harus berisi:

```js
window.SUMMIT_API_BASE = "https://api.summitbase.my.id";
```

## 2. Backend Node.js

Upload folder `backend-node/` ke server yang mendukung Node.js 22.x+ atau deploy folder ini ke Vercel sebagai project backend.

Buat `.env` di root backend:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=ISI_CONNECTION_STRING_ATLAS
MONGODB_DB=summit_base
ADMIN_EMAIL=admin@summitbase.local
ADMIN_PASSWORD=ISI_PASSWORD_ADMIN
ADMIN_NAME=Summit Base Admin
SESSION_TTL_DAYS=7
COOKIE_SECURE=true
TRUST_PROXY=true
FRONTEND_ORIGINS=https://summitbase.my.id,https://www.summitbase.my.id
```

Jangan commit `.env`.

## 3. DNS API

Jika backend ada di VPS/hosting Node.js, buat subdomain:

`api.summitbase.my.id`

Arahkan DNS ke server backend. Jalankan Node.js pada port internal, misalnya `3000`, lalu gunakan Nginx/Caddy untuk HTTPS.

Jika backend dideploy ke Vercel, tambahkan domain `api.summitbase.my.id` pada project backend Vercel.

## 4. Install dan jalankan backend

```bash
npm install --omit=dev
npm start
```

Untuk VPS gunakan process manager seperti PM2:

```bash
pm install -g pm2
pm pm2 start server.js --name summit-base-api
pm pm2 save
```

## 5. Tes

Buka:

- `https://summitbase.my.id/` → homepage
- `https://api.summitbase.my.id/api/health` → API health
- `https://summitbase.my.id/admin.html` → login admin
- `https://summitbase.my.id/customer.html` → customer dashboard

Jika homepage tampil tetapi login gagal, cek CORS dan pastikan `FRONTEND_ORIGINS` memuat domain frontend.

## 6. MongoDB Atlas

Backend harus memakai connection string Atlas yang disimpan sebagai `MONGODB_URI`. Tambahkan IP server backend ke Network Access Atlas. Jangan masukkan credential ke GitHub atau frontend.
