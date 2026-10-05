# Summit Base Backend — MongoDB + Vercel

Upload the contents of this folder as a separate GitHub repository, then import that repository into Vercel.

Required Vercel Environment Variables:
- MONGODB_URI
- MONGODB_DB=summit_base
- ADMIN_EMAIL
- ADMIN_PASSWORD
- ADMIN_NAME
- SESSION_TTL_DAYS=7
- COOKIE_SECURE=true
- TRUST_PROXY=true
- FRONTEND_ORIGINS=https://summitbase.my.id,https://www.summitbase.my.id

Do not commit `.env` or any MongoDB/admin credentials.

After deployment, test:
`https://YOUR-BACKEND-DOMAIN/api/health`

Then add the custom domain:
`api.summitbase.my.id`
