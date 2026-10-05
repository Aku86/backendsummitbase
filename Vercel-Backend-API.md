# Deploy backend Summit Base ke Vercel

Gunakan folder `backend-node/` sebagai project Vercel terpisah.

1. Buat project Vercel baru dan import repository backend.
2. Root Directory diarahkan ke `backend-node` bila backend dan frontend berada dalam satu repository.
3. Environment Variables (Production):
   - `MONGODB_URI` = connection string MongoDB Atlas
   - `MONGODB_DB` = `summit_base`
   - `ADMIN_EMAIL` = email admin
   - `ADMIN_PASSWORD` = password admin minimal 12 karakter
   - `ADMIN_NAME` = `Summit Base Admin`
   - `SESSION_TTL_DAYS` = `7`
   - `COOKIE_SECURE` = `true`
   - `TRUST_PROXY` = `true`
   - `FRONTEND_ORIGINS` = `https://summitbase.my.id,https://www.summitbase.my.id`
4. Deploy.
5. Tambahkan custom domain `api.summitbase.my.id` pada project backend Vercel.
6. Setelah domain aktif, buka `https://api.summitbase.my.id/api/health`. Respons yang sehat akan berisi `ok: true` dan `database: "mongodb"`.
7. Frontend cPanel sudah diarahkan ke `https://api.summitbase.my.id` melalui `frontend-cpanel/api-config.js`.

Jangan menaruh `MONGODB_URI` atau password admin di GitHub atau file frontend.
