# Neon PostgreSQL Setup Guide

## Why Neon?

- **Serverless PostgreSQL** with auto-scaling
- **Branching** for development/staging environments
- **Free tier** includes 0.5 GB storage
- **Connection pooling** built-in
- **Auto-suspend** to save costs

## Setup Steps

### 1. Create Neon Account

1. Go to [https://neon.tech](https://neon.tech)
2. Sign up with GitHub/Google/Email
3. Create your first project

### 2. Create Database

```sql
-- Neon will create a default database, but you can create a specific one:
CREATE DATABASE financial_bpo;
```

### 3. Get Connection String

Your connection string will look like:
```
postgresql://username:password@ep-xxxx-xxxx-123456.us-east-2.aws.neon.tech/financial_bpo?sslmode=require
```

### 4. Configure Pooled Connection

For serverless/edge functions, use the pooled connection string:
```
postgresql://username:password@ep-xxxx-xxxx-123456-pooler.us-east-2.aws.neon.tech/financial_bpo?sslmode=require
```

### 5. Update .env File

```bash
# Direct connection (for migrations)
DATABASE_URL="postgresql://username:password@ep-xxxx-xxxx-123456.us-east-2.aws.neon.tech/financial_bpo?sslmode=require"

# Pooled connection (for application)
DATABASE_POOL_URL="postgresql://username:password@ep-xxxx-xxxx-123456-pooler.us-east-2.aws.neon.tech/financial_bpo?sslmode=require"
```

### 6. Configure Prisma for Neon

Update `packages/database/schema.prisma`:

```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DATABASE_URL") // For migrations
}
```

### 7. Enable Required Extensions

Run in Neon SQL Editor:
```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable crypto for encryption
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enable Row Level Security
-- (Already in our schema)
```

## Development Workflow

### 1. Create Development Branch

Neon supports database branching:

```bash
# Create a dev branch in Neon dashboard
# You'll get a separate connection string for dev
```

### 2. Environment Setup

Create `.env.local` for development:
```bash
# Development branch
DATABASE_URL="postgresql://username:password@ep-xxxx-xxxx-dev.us-east-2.aws.neon.tech/financial_bpo?sslmode=require"
```

Create `.env.production` for production:
```bash
# Main branch
DATABASE_URL="postgresql://username:password@ep-xxxx-xxxx-main.us-east-2.aws.neon.tech/financial_bpo?sslmode=require"
```

### 3. Run Migrations

```bash
# Install dependencies first
cd /Users/Raphael/financial-bpo
npm install

# Generate Prisma client
npm run db:generate

# Run migrations
npm run db:migrate
```

## Connection Pooling Configuration

For NestJS backend (`apps/api/src/config/database.config.ts`):

```typescript
import { PrismaClient } from '@prisma/client'

// Use connection pooling in production
const databaseUrl = process.env.NODE_ENV === 'production' 
  ? process.env.DATABASE_POOL_URL 
  : process.env.DATABASE_URL

export const prisma = new PrismaClient({
  datasources: {
    db: {
      url: databaseUrl,
    },
  },
  log: process.env.NODE_ENV === 'development' ? ['query'] : [],
})
```

## Monitoring & Optimization

### 1. Enable Query Insights

In Neon dashboard:
- Go to Settings > Monitoring
- Enable "Query insights"
- Monitor slow queries

### 2. Connection Limits

Free tier includes:
- 100 simultaneous connections (direct)
- 1000 connections (pooled)

### 3. Auto-suspend Settings

Configure in Neon dashboard:
- Auto-suspend after 5 minutes of inactivity (free tier)
- Instant wake-up on new connections

## Security Best Practices

### 1. IP Allowlisting

For production:
1. Go to Settings > Security
2. Add your application's IP addresses
3. Enable "Restrict IP addresses"

### 2. Database Roles

Create separate roles for different access levels:

```sql
-- Read-only role for reporting
CREATE ROLE reporting_user WITH LOGIN PASSWORD 'secure_password';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reporting_user;

-- Application role with full access
CREATE ROLE app_user WITH LOGIN PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user;
```

### 3. SSL/TLS

Always use `sslmode=require` in connection strings.

## Backup Strategy

Neon provides:
- **Point-in-time recovery** (7 days on free tier)
- **Manual backups** via pg_dump

Create backup script:
```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump $DATABASE_URL > backups/backup_$DATE.sql
```

## Cost Optimization

Free tier includes:
- 0.5 GB storage
- 10 GB bandwidth/month
- 100 compute hours/month

To optimize:
1. Use connection pooling
2. Enable auto-suspend
3. Clean up old data regularly
4. Use database branching for dev/test

## Troubleshooting

### Connection Issues

1. Check SSL requirement:
```bash
# Test connection
psql $DATABASE_URL
```

2. Verify pooler for serverless:
```javascript
// Use pooled connection for edge functions
const DATABASE_URL = process.env.DATABASE_POOL_URL
```

### Migration Issues

1. Use direct connection for migrations:
```bash
# Not pooled connection
DATABASE_URL="postgresql://...ep-xxxx-xxxx-123456.us-east-2.aws.neon.tech/..."
```

2. Check extension availability:
```sql
SELECT * FROM pg_extension;
```