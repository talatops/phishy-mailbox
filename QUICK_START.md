# Quick Start: Deploy to Vercel + Supabase

## 🚀 Quick Deployment Steps

### 1. Supabase Setup (5 minutes)

```bash
# 1. Create project at https://supabase.com/dashboard
# 2. Get connection string from Settings → Database
# 3. Run migrations locally:
export DATABASE_URL="postgresql://postgres:[PASSWORD]@db.[PROJECT].supabase.co:5432/postgres"
yarn prisma generate
yarn prisma db push
yarn node ./prisma/seed.js  # Optional: creates admin@example.com / 123456
```

### 2. Vercel Setup (5 minutes)

1. **Connect Repository**
   - Go to https://vercel.com/dashboard
   - Import your GitHub repo

2. **Set Environment Variables**
   - `DATABASE_URL`: Supabase connection string (with `?pgbouncer=true&connection_limit=1`)
   - `NEXTAUTH_SECRET`: Generate with `openssl rand -base64 32`
   - `NODE_ENV`: `production`

3. **Deploy**
   - Click "Deploy"
   - Wait 2-5 minutes

### 3. Post-Deployment

- Visit your Vercel URL
- Login: `admin@example.com` / `123456`
- **Change password immediately!**

---

## 📋 Required Environment Variables

| Variable | Description | How to Get |
|----------|-------------|------------|
| `DATABASE_URL` | Supabase PostgreSQL connection | Supabase Dashboard → Settings → Database |
| `NEXTAUTH_SECRET` | Random secret for auth | `openssl rand -base64 32` |
| `NODE_ENV` | Environment mode | Set to `production` |

---

## 🔗 Important Links

- **Full Guide**: See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- **Vercel Dashboard**: https://vercel.com/dashboard
- **Supabase Dashboard**: https://supabase.com/dashboard

---

## ⚠️ Common Issues

**Database Connection Failed?**
- Use connection string with `?pgbouncer=true&connection_limit=1`
- Check Supabase project is active (not paused)

**NEXTAUTH_SECRET Error?**
- Ensure it's set in Vercel environment variables
- Redeploy after adding

**Build Failed?**
- Check Vercel build logs
- Ensure `DATABASE_URL` is set (even during build)

---

## ✅ Pre-Deployment Checklist

- [ ] Code changes committed (hardcoded secret fixed)
- [ ] Supabase project created
- [ ] Database migrations run (`prisma db push`)
- [ ] `NEXTAUTH_SECRET` generated
- [ ] Vercel project connected
- [ ] All environment variables set
- [ ] First deployment successful

---

For detailed instructions, see [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

