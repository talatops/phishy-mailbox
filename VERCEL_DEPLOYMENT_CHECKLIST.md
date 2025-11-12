# Vercel Deployment Checklist ✅

## ⚠️ Important: Set Environment Variables FIRST!

You **must** set environment variables in Vercel **before** or **during** the first deployment, otherwise the build will fail.

---

## 🚀 Step-by-Step Deployment

### Step 1: Push to GitHub

```bash
git add .
git commit -m "Prepare for Vercel deployment"
git push origin main
```

### Step 2: Connect to Vercel

1. Go to https://vercel.com/dashboard
2. Click **"Add New..."** → **"Project"**
3. Import your GitHub repository
4. Vercel will auto-detect Next.js ✅

### Step 3: Configure Build Settings (Usually Auto-Detected)

Vercel should auto-detect:
- ✅ Framework: Next.js
- ✅ Build Command: `yarn build` (or `next build`)
- ✅ Install Command: `yarn install`
- ✅ Output Directory: `.next` (auto)

**Note**: The `output: 'standalone'` in `next.config.js` is for Docker - Vercel ignores it, so it's fine.

### Step 4: Set Environment Variables ⚠️ CRITICAL

**DO THIS BEFORE CLICKING DEPLOY!**

Go to **Environment Variables** section and add:

#### 4.1 Get Transaction Mode Connection String

1. Go to Supabase Dashboard: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
2. Navigate to **Settings** → **Database**
3. Scroll to **Connection string** section
4. Click **"Transaction mode"** tab
5. Copy the connection string
6. Replace `[YOUR-PASSWORD]` with: `QGwshX2rYCyEgWPa`

It should look like:
```
postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true
```

#### 4.2 Add Environment Variables

Click **"Add"** for each variable:

| Variable Name | Value | Environment |
|--------------|-------|-------------|
| `DATABASE_URL` | `postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require` | ✅ Production<br>✅ Preview<br>✅ Development |
| `NEXTAUTH_SECRET` | `e0pDX+wn76iPJmF00dxXVbScWFDMjtKsyg91cdgc2RY=` | ✅ Production<br>✅ Preview<br>✅ Development |
| `NODE_ENV` | `production` | ✅ Production only |

**Important Notes:**
- Use **Transaction mode** connection string (port 6543) for Vercel
- Add `&connection_limit=1&sslmode=require` to the connection string
- Set all three variables for **all environments** (Production, Preview, Development)

### Step 5: Deploy

1. Click **"Deploy"** button
2. Wait 2-5 minutes for build to complete
3. Watch the build logs - you should see:
   - ✅ Installing dependencies
   - ✅ Running `yarn prisma generate` (automatic)
   - ✅ Running `next build`
   - ✅ Deployment successful

### Step 6: Verify Deployment

1. Visit your Vercel URL (e.g., `https://phishy-mailbox.vercel.app`)
2. Try logging in:
   - Email: `admin@example.com`
   - Password: `123456`
3. Check Vercel logs if there are any errors

---

## ✅ Pre-Deployment Checklist

- [x] Database migrations completed (SQL scripts run)
- [x] Seed data inserted (admin user created)
- [x] Prisma Client generated locally (`yarn prisma generate`)
- [x] Code committed and pushed to GitHub
- [ ] **Environment variables set in Vercel** ⚠️
- [ ] Repository connected to Vercel
- [ ] First deployment successful
- [ ] Login tested

---

## 🔧 What Happens During Build

Vercel will automatically:
1. ✅ Install dependencies (`yarn install`)
2. ✅ Generate Prisma Client (`prisma generate` - runs automatically)
3. ✅ Build Next.js app (`next build`)
4. ✅ Deploy to edge network

**You don't need to do anything special** - Vercel handles Prisma automatically!

---

## ⚠️ Common Issues

### Build Fails: "DATABASE_URL not found"
- **Solution**: Set `DATABASE_URL` environment variable in Vercel (even if invalid, Prisma needs it at build time)

### Build Fails: "NEXTAUTH_SECRET not set"
- **Solution**: Add `NEXTAUTH_SECRET` to environment variables

### Runtime Error: "Can't reach database"
- **Solution**: Use Transaction mode connection string (port 6543) with `pgbouncer=true`

### Build Succeeds but App Crashes
- **Solution**: Check Vercel logs → Functions → Check for runtime errors
- Verify all environment variables are set correctly

---

## 📝 Quick Reference

**Your Environment Variables:**
```
DATABASE_URL=postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require
NEXTAUTH_SECRET=e0pDX+wn76iPJmF00dxXVbScWFDMjtKsyg91cdgc2RY=
NODE_ENV=production
```

**Admin Credentials:**
- Email: `admin@example.com`
- Password: `123456` (change immediately!)

---

## 🎉 After Successful Deployment

1. ✅ Test login functionality
2. ✅ Change admin password
3. ✅ Test creating studies/emails
4. ✅ Monitor Vercel logs for any errors
5. ✅ Set up custom domain (optional)

---

## 💡 Pro Tips

1. **Always set environment variables BEFORE deploying** - saves time
2. **Use Transaction mode connection string** for Vercel (better for serverless)
3. **Monitor build logs** - they show exactly what's happening
4. **Check Vercel Function logs** if runtime errors occur
5. **Keep your `.env.local`** for local development (don't commit it!)

---

**Ready to deploy?** Just push to GitHub, connect to Vercel, set environment variables, and click Deploy! 🚀

