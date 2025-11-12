# Deployment Guide: Phishy Mailbox to Vercel + Supabase

This guide will walk you through deploying the Phishy Mailbox application to Vercel with Supabase as the database.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Setting up Supabase](#setting-up-supabase)
3. [Preparing Your Code](#preparing-your-code)
4. [Deploying to Vercel](#deploying-to-vercel)
5. [Post-Deployment Setup](#post-deployment-setup)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before you begin, ensure you have:
- A GitHub account (for connecting to Vercel)
- A Vercel account ([sign up here](https://vercel.com/signup))
- A Supabase account ([sign up here](https://supabase.com/dashboard))
- Node.js 20+ installed locally (for running migrations)
- Yarn installed locally

---

## Step 1: Setting up Supabase

### 1.1 Create a New Supabase Project

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click **"New Project"**
3. Fill in:
   - **Name**: `phishy-mailbox` (or your preferred name)
   - **Database Password**: Choose a strong password (save this!)
   - **Region**: Choose the closest region to your users
   - **Pricing Plan**: Free tier is fine for development

### 1.2 Get Your Database Connection String

1. In your Supabase project dashboard, go to **Settings** → **Database**
2. Scroll down to **Connection string** section
3. Select **"URI"** tab
4. Copy the connection string (it looks like: `postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres`)
5. Replace `[YOUR-PASSWORD]` with the password you set when creating the project
6. Add `?pgbouncer=true&connection_limit=1` at the end for better Vercel compatibility:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres?pgbouncer=true&connection_limit=1
   ```
   **Note**: For migrations, you may need to use the direct connection string (without pgbouncer). Check Supabase docs for the transaction pooler connection string.

### 1.3 Run Database Migrations

You need to set up your database schema before deploying:

1. **Install dependencies locally** (if not already done):
   ```bash
   yarn install
   ```

2. **Set your DATABASE_URL** temporarily:
   ```bash
   export DATABASE_URL="postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"
   ```
   Or create a `.env.local` file:
   ```
   DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```

3. **Generate Prisma Client**:
   ```bash
   yarn prisma generate
   ```

4. **Push the schema to Supabase**:
   ```bash
   yarn prisma db push
   ```

5. **Seed the database** (optional, creates admin user):
   ```bash
   yarn node ./prisma/seed.js
   ```
   
   **Default admin credentials** (from seed script):
   - Email: `admin@example.com`
   - Password: `123456`
   
   ⚠️ **IMPORTANT**: Change this password immediately after first login!

---

## Step 2: Preparing Your Code

### 2.1 Verify Environment Variables

The application requires these environment variables:
- `DATABASE_URL` - Your Supabase connection string
- `NEXTAUTH_SECRET` - A random secret for NextAuth (generate one)
- `NEXTAUTH_URL` - Your Vercel deployment URL (auto-set by Vercel)

### 2.2 Generate NEXTAUTH_SECRET

Generate a secure random secret:

**On Linux/Mac:**
```bash
openssl rand -base64 32
```

**On Windows (PowerShell):**
```powershell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

**Or use an online generator:**
- Visit: https://generate-secret.vercel.app/32

Save this secret - you'll need it for Vercel.

### 2.3 Code Changes Already Made

✅ The hardcoded `NEXTAUTH_SECRET` in `src/server/auth.ts` has been fixed to use `env.NEXTAUTH_SECRET`
✅ The app is already configured for Vercel (handles `VERCEL_URL` automatically)

---

## Step 3: Deploying to Vercel

### 3.1 Connect Your Repository

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Click **"Add New..."** → **"Project"**
3. Import your Git repository (GitHub/GitLab/Bitbucket)
4. Select the `phishy-mailbox` repository

### 3.2 Configure Build Settings

Vercel should auto-detect Next.js, but verify these settings:

- **Framework Preset**: Next.js
- **Root Directory**: `./` (root)
- **Build Command**: `yarn build` (or leave default)
- **Output Directory**: `.next` (auto-detected)
- **Install Command**: `yarn install`

### 3.3 Set Environment Variables

In the Vercel project settings, add these environment variables:

1. Go to **Settings** → **Environment Variables**

2. Add the following:

   | Name | Value | Environment |
   |------|-------|-------------|
   | `DATABASE_URL` | Your Supabase connection string (with pgbouncer) | Production, Preview, Development |
   | `NEXTAUTH_SECRET` | The secret you generated earlier | Production, Preview, Development |
   | `NODE_ENV` | `production` | Production only |

   **Note**: For `DATABASE_URL`, use the connection string with `?pgbouncer=true&connection_limit=1` for Production/Preview environments.

3. Click **"Save"** after adding each variable

### 3.4 Deploy

1. Click **"Deploy"** button
2. Wait for the build to complete (usually 2-5 minutes)
3. Once deployed, you'll get a URL like: `https://phishy-mailbox.vercel.app`

### 3.5 Update NEXTAUTH_URL (if needed)

If Vercel doesn't automatically set `NEXTAUTH_URL`:

1. Go to **Settings** → **Environment Variables**
2. Add `NEXTAUTH_URL` with your Vercel deployment URL:
   - Value: `https://your-project.vercel.app`
   - Environment: Production, Preview, Development

---

## Step 4: Post-Deployment Setup

### 4.1 Verify Database Connection

1. Visit your deployed app: `https://your-project.vercel.app`
2. Try logging in with the admin credentials (if you seeded the database)
3. Check Vercel logs for any database connection errors

### 4.2 Run Database Migrations (if needed)

If you need to run migrations after deployment, you can:

**Option A: Use Supabase SQL Editor**
1. Go to Supabase Dashboard → **SQL Editor**
2. Run Prisma migration SQL manually (from `prisma/migrations/` folder)

**Option B: Use Vercel CLI**
```bash
vercel env pull .env.local
yarn prisma db push
```

**Option C: Use Supabase CLI** (recommended for production)
```bash
supabase db push
```

### 4.3 Seed Production Database (if needed)

If you need to seed the production database:

1. Set `DATABASE_URL` to your production Supabase connection string
2. Run: `yarn node ./prisma/seed.js`

⚠️ **Warning**: Only seed if the database is empty. The seed script checks for existing users.

---

## Step 5: Important Notes

### 5.1 Database Connection Pooling

Supabase uses connection pooling. For Vercel serverless functions:
- Use the **Transaction Pooler** connection string (port 6543) or
- Use the **Session Pooler** connection string with `?pgbouncer=true`

The direct connection (port 5432) may cause connection limit issues with serverless functions.

### 5.2 Prisma Migrations on Vercel

Vercel doesn't automatically run migrations. You have a few options:

1. **Manual migrations**: Run `prisma db push` locally before deploying
2. **GitHub Actions**: Set up CI/CD to run migrations automatically
3. **Supabase Migrations**: Use Supabase's migration system

### 5.3 Next.js Standalone Output

The app uses `output: 'standalone'` in `next.config.js`, which is good for Docker but Vercel handles this automatically. This won't cause issues.

### 5.4 Entrypoint Script

The `entrypoint.sh` script is used for Docker deployments. Vercel doesn't use this, so migrations/seeding must be done manually or via CI/CD.

---

## Step 6: Troubleshooting

### Issue: Database Connection Errors

**Symptoms**: "Can't reach database server" or connection timeout errors

**Solutions**:
1. Verify `DATABASE_URL` is correct in Vercel environment variables
2. Check if you're using the pooler connection string (port 6543 or with `?pgbouncer=true`)
3. Verify Supabase project is active and not paused
4. Check Supabase dashboard for connection issues

### Issue: NEXTAUTH_SECRET Error

**Symptoms**: "NEXTAUTH_SECRET is not set" error

**Solutions**:
1. Verify `NEXTAUTH_SECRET` is set in Vercel environment variables
2. Ensure it's set for all environments (Production, Preview, Development)
3. Redeploy after adding the variable

### Issue: Build Fails

**Symptoms**: Build errors during Vercel deployment

**Solutions**:
1. Check build logs in Vercel dashboard
2. Ensure `DATABASE_URL` is set (even if invalid, Prisma needs it at build time)
3. Verify Node.js version compatibility (app uses Node 20)
4. Check for TypeScript errors: `yarn lint`

### Issue: Prisma Client Not Generated

**Symptoms**: "PrismaClient is not generated" errors

**Solutions**:
1. Ensure `yarn prisma generate` runs during build (should be automatic)
2. Check `package.json` postinstall script (if exists)
3. Verify Prisma schema is valid: `yarn prisma validate`

### Issue: Environment Variables Not Loading

**Symptoms**: App works locally but fails on Vercel

**Solutions**:
1. Verify environment variables are set in Vercel dashboard
2. Ensure variables are added to correct environments
3. Redeploy after adding/changing variables
4. Check variable names match exactly (case-sensitive)

---

## Step 7: Setting Up Custom Domain (Optional)

1. Go to Vercel project → **Settings** → **Domains**
2. Add your custom domain
3. Follow DNS configuration instructions
4. Update `NEXTAUTH_URL` environment variable to match your custom domain

---

## Step 8: Monitoring and Maintenance

### 8.1 Monitor Vercel Logs

- Go to Vercel Dashboard → Your Project → **Deployments** → Click on a deployment → **Logs**
- Watch for errors, especially database connection issues

### 8.2 Monitor Supabase

- Check Supabase Dashboard → **Database** → **Connection Pooling** for connection stats
- Monitor **Logs** for database errors
- Check **Usage** for quota limits (free tier has limits)

### 8.3 Set Up Alerts

- Configure Vercel alerts for failed deployments
- Set up Supabase alerts for database issues
- Monitor application uptime

---

## Additional Resources

- [Vercel Next.js Documentation](https://vercel.com/docs/frameworks/nextjs)
- [Supabase PostgreSQL Guide](https://supabase.com/docs/guides/database)
- [Prisma Deployment Guide](https://www.prisma.io/docs/guides/deployment)
- [NextAuth.js Deployment](https://next-auth.js.org/configuration/options#secret)

---

## Quick Checklist

- [ ] Supabase project created
- [ ] Database schema pushed (`yarn prisma db push`)
- [ ] Database seeded (optional)
- [ ] `NEXTAUTH_SECRET` generated
- [ ] Repository connected to Vercel
- [ ] Environment variables set in Vercel:
  - [ ] `DATABASE_URL`
  - [ ] `NEXTAUTH_SECRET`
  - [ ] `NODE_ENV` (production)
- [ ] First deployment successful
- [ ] Admin login tested
- [ ] Changed default admin password

---

## Support

If you encounter issues:
1. Check Vercel deployment logs
2. Check Supabase dashboard logs
3. Review this guide's troubleshooting section
4. Check the project's GitHub issues

Good luck with your deployment! 🚀

