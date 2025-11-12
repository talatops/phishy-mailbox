# Vercel Database URL for Asia-Pacific Region

## Your Transaction Mode Connection String

For your Supabase project in **Asia-Pacific (ap-southeast-1)** region, use this connection string for Vercel:

```
postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require
```

## Breakdown

- **Host**: `aws-0-ap-southeast-1.pooler.supabase.com`
- **Port**: `6543` (Transaction mode)
- **Username**: `postgres.lojpgnstxaauvdknsoic` (note the format: `postgres.[PROJECT-REF]`)
- **Password**: `QGwshX2rYCyEgWPa`
- **Database**: `postgres`
- **Parameters**:
  - `pgbouncer=true` - Enables connection pooling
  - `connection_limit=1` - Limits connections per serverless function
  - `sslmode=require` - Requires SSL encryption

## How to Verify in Supabase Dashboard

1. Go to: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
2. Navigate to **Settings** → **Database**
3. Scroll to **Connection string** section
4. Click **"Transaction mode"** tab
5. You should see a connection string like:
   ```
   postgresql://postgres.lojpgnstxaauvdknsoic:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true
   ```
6. Replace `[YOUR-PASSWORD]` with `QGwshX2rYCyEgWPa`
7. Add `&connection_limit=1&sslmode=require` at the end

## For Vercel Environment Variables

Set this in Vercel:

**Variable Name**: `DATABASE_URL`

**Value**:
```
postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require
```

**Environments**: ✅ Production, ✅ Preview, ✅ Development

---

## Note on Region

Your project is in **ap-southeast-1** (Asia Pacific - Singapore), which is correct for Asia-Pacific deployments. The connection string format uses `aws-0-ap-southeast-1.pooler.supabase.com` as the hostname.

