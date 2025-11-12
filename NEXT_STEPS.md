# Next Steps After Database Setup ✅

## ✅ What's Done

1. ✅ Database schema created (all tables)
2. ✅ Seed data inserted (admin user, sample emails, test study)
3. ✅ `.env.local` configured with Supabase connection string

## 🔄 What to Do Next

### Step 1: Generate Prisma Client

Since you've set up the database manually, you still need to generate the Prisma Client for your application:

```bash
yarn prisma generate
```

This creates the Prisma Client that your application uses to interact with the database.

### Step 2: Set Up Environment Variables

Your `.env.local` should have:

```env
DATABASE_URL="postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"
NEXTAUTH_SECRET="your-secret-here"
NODE_ENV="development"
```

**Generate NEXTAUTH_SECRET** (if not already set):
```bash
openssl rand -base64 32
```

Add it to `.env.local`:
```env
NEXTAUTH_SECRET="[paste-generated-secret-here]"
```

### Step 3: Test Locally

```bash
# Generate Prisma Client
yarn prisma generate

# Start development server
yarn dev
```

Then:
1. Open http://localhost:3000
2. Try logging in:
   - **Email**: `admin@example.com`
   - **Password**: `123456`
3. ⚠️ **Change password immediately after first login!**

### Step 4: Deploy to Vercel

1. **Push your code to GitHub** (if not already done)

2. **Connect to Vercel**:
   - Go to https://vercel.com/dashboard
   - Import your repository
   - Vercel will auto-detect Next.js

3. **Set Environment Variables in Vercel**:
   - Go to Project Settings → Environment Variables
   - Add these variables:

   | Variable | Value | Environment |
   |----------|-------|-------------|
   | `DATABASE_URL` | Get from Supabase Dashboard → Settings → Database → **Transaction mode** connection string | Production, Preview, Development |
   | `NEXTAUTH_SECRET` | The secret you generated (same as local) | Production, Preview, Development |
   | `NODE_ENV` | `production` | Production only |

   **Important**: For Vercel, use the **Transaction mode** connection string (port 6543) with `pgbouncer=true`:
   ```
   postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require
   ```

4. **Deploy**:
   - Click "Deploy"
   - Wait for build to complete
   - Your app will be live!

### Step 5: Verify Deployment

1. Visit your Vercel URL
2. Test admin login
3. Check that you can access the admin dashboard
4. Verify tables are accessible

---

## 📋 Checklist

- [ ] Generate Prisma Client (`yarn prisma generate`)
- [ ] Set `NEXTAUTH_SECRET` in `.env.local`
- [ ] Test locally (`yarn dev`)
- [ ] Login with admin credentials
- [ ] Change admin password
- [ ] Push code to GitHub
- [ ] Connect repository to Vercel
- [ ] Set environment variables in Vercel (use Transaction mode connection string)
- [ ] Deploy to Vercel
- [ ] Test deployed application

---

## 🔗 Important Links

- **Supabase Dashboard**: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
- **Vercel Dashboard**: https://vercel.com/dashboard
- **Local Dev**: http://localhost:3000

---

## 🎉 You're Almost There!

Your database is set up and ready. Just generate the Prisma Client and you can start testing locally, then deploy to Vercel!

