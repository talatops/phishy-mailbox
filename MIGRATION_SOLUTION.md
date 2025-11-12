# Database Migration Solution

## Problem Summary

Your server environment cannot connect to Supabase due to:
- **IPv6-only DNS resolution** - Supabase resolves to IPv6 addresses
- **Network/firewall restrictions** - Server cannot reach Supabase database ports
- **Connection timeouts** - All connection attempts fail

## ✅ Recommended Solution: Run Migrations Locally

Since the server has connectivity issues, **run the migrations from your local machine** where you have proper internet connectivity.

### Step-by-Step Instructions

1. **On your local machine**, navigate to the project:
   ```bash
   cd /path/to/phishy-mailbox
   ```

2. **Get the correct connection string from Supabase Dashboard**:
   - Go to: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
   - Navigate to: **Settings** → **Database**
   - Scroll to **"Connection string"** section
   - Copy the **"Session mode"** or **"Direct connection"** string
   - Replace `[YOUR-PASSWORD]` with: `QGwshX2rYCyEgWPa`

3. **Set the connection string**:
   ```bash
   export DATABASE_URL="postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"
   ```
   
   Or use the Supavisor connection string from the dashboard if the direct one doesn't work.

4. **Run the migrations**:
   ```bash
   # Generate Prisma Client
   yarn prisma generate
   
   # Push schema to database
   yarn prisma db push
   
   # Seed the database (creates admin user)
   yarn node ./prisma/seed.js
   ```

5. **Verify success**:
   - You should see: "Your database is now in sync with your Prisma schema"
   - Check Supabase dashboard → **Table Editor** to see the tables created

---

## Alternative: Use Supabase SQL Editor

If local migration still fails, you can manually create tables using Supabase SQL Editor:

1. Go to Supabase Dashboard → **SQL Editor**
2. I can generate the SQL schema for you if needed
3. Run the SQL directly in the editor

---

## Connection String for Vercel

Once migrations are done, use this connection string format for Vercel:

**For Vercel (use Transaction Mode/Supavisor):**
```
postgresql://postgres.lojpgnstxaauvdknsoic:QGwshX2rYCyEgWPa@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require
```

**Get the exact string from Supabase Dashboard:**
- Settings → Database → Connection string → **Transaction mode**
- Copy and use that for Vercel environment variables

---

## Default Admin Credentials (After Seeding)

- **Email**: `admin@example.com`
- **Password**: `123456`

⚠️ **Change this password immediately after first login!**

---

## Files Created for You

1. **`setup-database.sh`** - Automated setup script (run locally)
2. **`DATABASE_SETUP_INSTRUCTIONS.md`** - Detailed instructions
3. **`GET_CONNECTION_STRING.md`** - How to get connection string from dashboard
4. **`SUPABASE_CONNECTION_FIX.md`** - Troubleshooting guide

---

## Next Steps

1. ✅ **Run migrations locally** (recommended)
2. ✅ **Verify tables created** in Supabase dashboard
3. ✅ **Deploy to Vercel** with the Transaction mode connection string
4. ✅ **Test the application**

---

## Why This Happens

Supabase databases use IPv6 addresses, and some server environments (especially in restricted networks, containers, or certain cloud providers) may not have proper IPv6 connectivity configured. Running migrations from your local machine (which typically has full internet connectivity) bypasses this issue.

---

## Need Help?

If you encounter issues:
1. Check Supabase dashboard logs
2. Verify project is ACTIVE (not paused)
3. Try the Supavisor connection string from dashboard
4. Check your local machine's network connectivity

