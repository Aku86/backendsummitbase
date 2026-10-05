# Summit Base — Panduan Publish Hosting

Paket ini sudah disiapkan untuk production dengan Node.js + MongoDB Atlas.
Tidak ada `.env`, `node_modules`, atau `.git` di paket release. Jangan memasukkan credential ke GitHub.


## Domain utama langsung membuka halaman Summit Base

Project ini sudah menggunakan `public/index.html` sebagai halaman utama. Backend menangani:

```text
https://DOMAIN-KAMU/            -> public/index.html
https://DOMAIN-KAMU/admin       -> public/admin.html
https://DOMAIN-KAMU/customer    -> public/customer.html
https://DOMAIN-KAMU/api/health  -> API health check
```

Jadi untuk domain seperti `https://summitbase.my.id`, pengunjung cukup membuka:

```text
https://summitbase.my.id/
```

dan halaman utama akan langsung tampil. Untuk VPS/cPanel Node.js, arahkan domain ke **Node.js application** yang menjalankan `server.js`, bukan menjadikan folder `public/` sebagai document root Apache/PHP. Untuk Vercel, `vercel.json` sudah meneruskan root `/` ke handler Node.js.

Jika domain masih menampilkan `Not Found`, halaman kosong, atau directory listing, biasanya domain belum diarahkan ke aplikasi Node.js yang benar. Periksa **Application URL / domain mapping** pada hosting dan pastikan startup file-nya `server.js`.

## Opsi A — Vercel + MongoDB Atlas (disarankan)

1. Upload/push folder ini ke GitHub.
2. Import repository ke Vercel.
3. Di Vercel → Settings → Environment Variables tambahkan:

```text
MONGODB_URI
MONGODB_DB
ADMIN_EMAIL
ADMIN_PASSWORD
ADMIN_NAME
SESSION_TTL_DAYS
COOKIE_SECURE=true
TRUST_PROXY=true
```

4. `MONGODB_URI` adalah connection string MongoDB Atlas. Jangan kirim atau commit nilainya.
5. `MONGODB_DB` gunakan `summit_base`.
6. Redeploy setelah Environment Variables disimpan.
7. Tes:

```text
https://DOMAIN-KAMU.vercel.app/
https://DOMAIN-KAMU.vercel.app/api/health
https://DOMAIN-KAMU.vercel.app/admin.html
```

`vercel.json` dan `api/index.js` sudah disediakan.

## Opsi B — VPS / hosting Node.js

Persyaratan:
- Node.js 22.16+
- npm
- akses outbound ke MongoDB Atlas
- HTTPS di depan aplikasi (misalnya Caddy/Nginx)

Upload source release, lalu:

```bash
npm install --omit=dev
```

Buat `.env` di server:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://USERNAME:PASSWORD@CLUSTER.mongodb.net/?retryWrites=true&w=majority
MONGODB_DB=summit_base
ADMIN_EMAIL=admin@summitbase.local
ADMIN_PASSWORD=GANTI_DENGAN_PASSWORD_PRODUCTION
ADMIN_NAME=Summit Base Admin
SESSION_TTL_DAYS=7
COOKIE_SECURE=true
TRUST_PROXY=true
```

Jalankan:

```bash
npm start
```

Gunakan process manager seperti systemd atau PM2 dan reverse proxy HTTPS.
Contoh Caddy/systemd ada di folder `deploy/`.

## Opsi C — Docker

Project sudah memiliki `Dockerfile`.
Build:

```bash
docker build -t summit-base .
```

Run dengan environment variable dari host/secret manager. Jangan menulis credential MongoDB ke Dockerfile atau image.

## MongoDB Atlas

Database default: `summit_base`.
Collection dibuat/diinisialisasi backend saat request API pertama:
- users
- admin_users
- sessions
- catalog
- rentals
- rental_extensions
- counters

Untuk deployment Vercel, atur Network Access Atlas sesuai arsitektur. Untuk koneksi langsung Vercel, MongoDB mendokumentasikan kebutuhan allowlist yang sesuai dengan IP dinamis Vercel.

## Sebelum production

- Jangan upload `.env`.
- Jangan upload `MONGODB_URI` ke GitHub.
- Gunakan password admin production yang unik dan minimal 12 karakter.
- Gunakan database user khusus aplikasi.
- Pastikan HTTPS aktif.
- Uji `/api/health`, login admin, customer, approval rental, stok, pengembalian, dan perpanjangan.
