#!/bin/bash

echo "🚀 Setting up Financial BPO Database on Neon..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi

echo -e "${YELLOW}Testing connection to Neon...${NC}"

# Test connection
psql "$DATABASE_URL" -c "SELECT version();" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Successfully connected to Neon PostgreSQL${NC}"
else
    echo -e "${RED}✗ Failed to connect to database. Please check your connection string.${NC}"
    exit 1
fi

echo -e "${YELLOW}Enabling required extensions...${NC}"

# Enable extensions
psql "$DATABASE_URL" << EOF
-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable crypto for encryption
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Show enabled extensions
SELECT * FROM pg_extension;
EOF

echo -e "${GREEN}✓ Extensions enabled${NC}"

echo -e "${YELLOW}Running Prisma setup...${NC}"

# Generate Prisma client
npm run db:generate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Prisma client generated${NC}"
else
    echo -e "${RED}✗ Failed to generate Prisma client${NC}"
    exit 1
fi

# Run migrations
echo -e "${YELLOW}Running database migrations...${NC}"
npm run db:migrate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Migrations completed successfully${NC}"
else
    echo -e "${RED}✗ Migration failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Database setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Run 'npm run dev' to start the development servers"
echo "2. Access the app at http://localhost:3000/login/demo"
echo "3. Create your first tenant using the CLI or API"