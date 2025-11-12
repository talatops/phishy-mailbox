# Fixing Supabase Connection Issues

## The Problem
Your server only resolves IPv6 addresses, but Supabase's direct connection (`db.lojpgnstxaauvdknsoic.supabase.co`) may require IPv6 support that your environment doesn't have.

## Solution: Use Supavisor Connection String (IPv4 Compatible)

### Step 1: Get the Correct Connection String from Supabase Dashboard

1. Go to your Supabase Dashboard: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
2. Navigate to **Settings** → **Database**
3. Scroll down to **Connection string** section
4. Look for **"Session mode"** or **"Supavisor Session Mode"** connection string
5. It should look like one of these formats:
   - `postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres`
   - Or similar format with pooler hostname

### Step 2: Use the Connection String

The connection string format should be:
```
postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
```

**Note**: The username format changes from `postgres` to `postgres.[PROJECT-REF]` when using Supavisor.

### Step 3: Try Alternative: Use Transaction Mode (Port 6543)

If Session mode doesn't work, try Transaction mode:

```
postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&sslmode=require
```

### Step 4: Run Migrations

Once you have the correct connection string:

```bash
export DATABASE_URL="[YOUR_SUPAVISOR_CONNECTION_STRING]"
yarn prisma generate
yarn prisma db push
yarn node ./prisma/seed.js
```

---

## Alternative: Run from Local Machine

If the server still has connectivity issues, run migrations from your local machine:

1. **On your local machine** (with proper internet/IPv6 support):
   ```bash
   cd /path/to/phishy-mailbox
   export DATABASE_URL="postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"
   yarn prisma generate
   yarn prisma db push
   yarn node ./prisma/seed.js
   ```

2. Your local machine likely has better IPv6 support than the server.

---

## Quick Test: Verify Connection

Test if you can reach the database:

```bash
# Test DNS resolution
nslookup db.lojpgnstxaauvdknsoic.supabase.co

# Test connection (if psql is available)
psql "postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"
```

---

## Connection String Formats Reference

### Direct Connection (IPv6, may not work on your server)
```
postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres?sslmode=require
```

### Supavisor Session Mode (IPv4 compatible, recommended for migrations)
```
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres?sslmode=require
```

### Supavisor Transaction Mode (For serverless/Vercel)
```
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true&sslmode=require
```

**Your project details:**
- Project REF: `lojpgnstxaauvdknsoic`
- Region: `ap-southeast-1`
- Password: `QGwshX2rYCyEgWPa`

---

## Next Steps

1. **Get the Supavisor connection string from Supabase Dashboard**
2. **Update the connection string** in your environment
3. **Run migrations** using the new connection string
4. **If still failing**, run from your local machine instead

