# Manual SQL Setup Instructions for Supabase

## Overview
This guide will help you set up your Phishy Mailbox database manually using Supabase SQL Editor, bypassing Prisma migrations.

## Step-by-Step Instructions

### Step 1: Open Supabase SQL Editor

1. Go to your Supabase Dashboard: https://supabase.com/dashboard/project/lojpgnstxaauvdknsoic
2. Click **SQL Editor** in the left sidebar
3. Click **New query**

### Step 2: Run the Migration Script

1. Open the file `supabase-migration.sql` in this repository
2. Copy **ALL** the contents
3. Paste into the Supabase SQL Editor
4. Click **Run** (or press `Ctrl+Enter` / `Cmd+Enter`)
5. Wait for it to complete - you should see "Success. No rows returned"

**What this does:**
- Creates all database tables
- Creates enums (ExternalImageMode, TimerMode)
- Sets up foreign keys and indexes
- Enables Row Level Security (RLS)
- Creates policies for table access

### Step 3: Run the Seed Script

1. Open the file `supabase-seed.sql` in this repository
2. Copy **ALL** the contents
3. Paste into Supabase SQL Editor
4. Click **Run** (or press `Ctrl+Enter` / `Cmd+Enter`)
5. Wait for completion - you should see "Success. No rows returned"

**What this does:**
- Creates admin user (`admin@example.com` / `123456`) - password hash is already included!
- Inserts 3 sample emails
- Creates a test study with folders
- Links emails to the study
- Creates a test participation code (`123`)

**Note:** The password hash for `123456` is already included in the script (`$2b$10$JZELVk3kqlO2m3GAxeCEAOufdEXKkrEfDorsxx5c1Dk0OisDPqHz2`), so you don't need to generate it manually.

### Step 4: Verify Setup

1. Go to **Table Editor** in Supabase Dashboard
2. Check that these tables exist:
   - ✅ `User` (should have 1 row)
   - ✅ `Email` (should have 3 rows)
   - ✅ `Study` (should have 1 row)
   - ✅ `Folder` (should have 3 rows)
   - ✅ `StudyEmail` (should have 3 rows)
   - ✅ `Participation` (should have 1 row)

3. Verify admin user:
   - Go to `User` table
   - Check that `admin@example.com` exists
   - Verify `canManageUsers` is `true`

### Step 5: Test Login

1. Deploy your app to Vercel (or run locally)
2. Try logging in with:
   - **Email**: `admin@example.com`
   - **Password**: `123456`
3. ⚠️ **IMPORTANT**: Change the password immediately after first login!

---

## Troubleshooting

### Error: "relation already exists"
- Some tables might already exist
- You can either:
  - Drop existing tables: `DROP TABLE IF EXISTS "User" CASCADE;` (repeat for all tables)
  - Or skip the migration and just run the seed script

### Error: "extension pgcrypto does not exist"
- Run this first: `CREATE EXTENSION IF NOT EXISTS pgcrypto;`
- Then try the password hash generation again

### Error: "duplicate key value violates unique constraint"
- The seed data already exists
- This is fine - the `ON CONFLICT DO NOTHING` clauses prevent errors
- Your database is already seeded

### Password hash not working
- Make sure you're using bcrypt hash format (`$2b$10$...`)
- Verify the hash is complete (60+ characters)
- Try regenerating the hash

---

## Files Reference

- **`supabase-migration.sql`** - Creates all tables and schema
- **`supabase-seed.sql`** - Inserts initial data
- **`MANUAL_SQL_SETUP.md`** - This file

---

## Next Steps After Setup

1. ✅ Database is ready
2. ✅ Admin user created
3. ✅ Sample data inserted
4. 🔄 Deploy to Vercel (see `DEPLOYMENT_GUIDE.md`)
5. 🔄 Set up environment variables in Vercel
6. 🔄 Test the application

---

## Quick Reference

**Admin Credentials:**
- Email: `admin@example.com`
- Password: `123456` (change immediately!)

**Test Participation Code:**
- Code: `123`

**Connection String for Vercel:**
- Get from Supabase Dashboard → Settings → Database → Connection string → Transaction mode
- Format: `postgresql://postgres.[REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true&connection_limit=1&sslmode=require`

