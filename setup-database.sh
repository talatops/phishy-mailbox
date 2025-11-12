#!/bin/bash

# Database Setup Script for Phishy Mailbox
# Run this script from your local machine (not the server) to set up Supabase

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Setting up Phishy Mailbox Database${NC}"
echo ""

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo -e "${YELLOW}⚠️  DATABASE_URL not set. Using provided connection string...${NC}"
    export DATABASE_URL="postgresql://postgres:QGwshX2rYCyEgWPa@db.lojpgnstxaauvdknsoic.supabase.co:5432/postgres?sslmode=require"
fi

echo -e "${GREEN}Step 1: Generating Prisma Client...${NC}"
yarn prisma generate

echo ""
echo -e "${GREEN}Step 2: Pushing database schema...${NC}"
yarn prisma db push

echo ""
echo -e "${GREEN}Step 3: Seeding database...${NC}"
yarn node ./prisma/seed.js

echo ""
echo -e "${GREEN}✅ Database setup complete!${NC}"
echo ""
echo -e "${YELLOW}📝 Default admin credentials:${NC}"
echo -e "   Email: ${GREEN}admin@example.com${NC}"
echo -e "   Password: ${GREEN}123456${NC}"
echo ""
echo -e "${RED}⚠️  IMPORTANT: Change the admin password immediately after first login!${NC}"

