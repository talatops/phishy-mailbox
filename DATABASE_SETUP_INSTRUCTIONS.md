# Database Setup Instructions

## Issue
The server has network connectivity issues (IPv6-only DNS resolution), so we need to run migrations from your local machine.

## ✅ Solution: Run Migrations Locally

You have **3 options** to set up your Supabase database:

---

## Option 1: Use the Setup Script (Recommended)

1. **On your local machine** (where you have the code), run:

```bash
# Set the database URL
export DATABASE_URL="postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"

# Run the setup script
./setup-database.sh
```

Or manually run each step:

```bash
export DATABASE_URL="postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"
yarn prisma generate
yarn prisma db push
yarn node ./prisma/seed.js
```

---

## Option 2: Use Supabase SQL Editor

1. Go to your Supabase Dashboard: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
2. Navigate to **SQL Editor**
3. Run Prisma migrations manually (see below for SQL)

**Note**: This is more complex as you'd need to convert Prisma schema to SQL. Option 1 is easier.

---

## Option 3: Use Supabase CLI (If Installed)

```bash
# Install Supabase CLI (if not installed)
npm install -g supabase

# Login with your access token
supabase login --token sbp_53774bc4f46ec5787a770181cbb61e1366ba66ae

# Link to your project
supabase link --project-ref lojpgnstxaauvdknsoic

# Push schema (if you have migrations)
supabase db push
```

---

## Connection String for Vercel

When setting up Vercel, use this connection string with connection pooling:

```
postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require
```

**Note**: Port `6543` is for connection pooling (better for serverless/Vercel), port `5432` is for direct connections (better for migrations).

---

## Default Admin Credentials (After Seeding)

- **Email**: `admin@example.com`
- **Password**: `123456`

⚠️ **IMPORTANT**: Change this password immediately after first login!

---

## Troubleshooting

### Connection Issues?

1. **Check Supabase Dashboard**: Ensure project is active (not paused)
2. **Try Direct Connection**: Use port `5432` for migrations
3. **Try Pooler Connection**: Use port `6543` for Vercel/serverless
4. **Check SSL**: Ensure `?sslmode=require` is in connection string

### Still Having Issues?

Run from your local machine where you have:
- Internet connectivity
- Yarn installed
- Node.js installed

The server environment has network restrictions that prevent direct database connections.

