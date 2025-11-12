# How to Get the Correct Supabase Connection String

## The Issue
The server environment has IPv6 connectivity issues. We need to get the **exact** connection string from your Supabase dashboard.

## Steps to Get Connection String

1. **Go to Supabase Dashboard**
   - URL: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic

2. **Navigate to Database Settings**
   - Click **Settings** (gear icon) in the left sidebar
   - Click **Database** in the settings menu

3. **Find Connection String Section**
   - Scroll down to **"Connection string"** or **"Connection pooling"** section
   - You'll see multiple connection options:
     - **Direct connection** (port 5432)
     - **Session mode** (Supavisor, port 5432)
     - **Transaction mode** (Supavisor, port 6543)

4. **Copy the Connection String**
   - For **migrations**, use either:
     - **Direct connection** (if your network supports IPv6)
     - **Session mode** (Supavisor, IPv4 compatible)
   - Click the **copy** icon next to the connection string
   - Replace `[YOUR-PASSWORD]` with: `QGwshX2rYCyEgWPa`

5. **Use It**
   ```bash
   export DATABASE_URL="[PASTE_THE_CONNECTION_STRING_HERE]"
   yarn prisma db push
   ```

## What to Look For

The connection string should look like one of these:

**Option 1: Direct Connection**
```
postgresql://postgres:[YOUR-PASSWORD]@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres
```

**Option 2: Supavisor Session Mode (Recommended for IPv4)**
```
postgresql://postgres.lojpgnstxaauvdknsoic:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres
```

**Option 3: Supavisor Transaction Mode (For Vercel)**
```
postgresql://postgres.lojpgnstxaauvdknsoic:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true
```

## After Getting the Connection String

1. **Test it**:
   ```bash
   export DATABASE_URL="[YOUR_CONNECTION_STRING]?sslmode=require"
   yarn prisma db push
   ```

2. **If it works**, run the seed:
   ```bash
   yarn node ./prisma/seed.js
   ```

3. **Save it** for Vercel deployment (use Transaction mode for Vercel)

---

## Quick Test Command

Once you have the connection string, test it:

```bash
export DATABASE_URL="[YOUR_CONNECTION_STRING]?sslmode=require"
yarn prisma db push
```

If you see "Your database is now in sync with your Prisma schema", you're good to go! 🎉

