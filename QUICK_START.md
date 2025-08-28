# Quick Start Guide - Financial BPO

## 1. Prerequisites

- Node.js 18+ installed
- Git installed
- Neon account (free tier is fine)

## 2. Neon Database Setup (5 minutes)

### Step 1: Create Neon Account
1. Go to [https://console.neon.tech](https://console.neon.tech)
2. Sign up (GitHub signin recommended)
3. Create a new project called "financial-bpo"

### Step 2: Get Connection Strings
1. In Neon dashboard, go to "Connection Details"
2. Copy both connection strings:
   - **Direct connection** (for migrations)
   - **Pooled connection** (for app - click "Pooled connection" checkbox)

### Step 3: Configure Environment
```bash
# In project root
cp .env.example .env

# Edit .env and paste your Neon connection strings:
# DATABASE_URL="postgresql://[user]:[password]@[endpoint].neon.tech/financial_bpo?sslmode=require"
# DATABASE_POOL_URL="postgresql://[user]:[password]@[endpoint]-pooler.neon.tech/financial_bpo?sslmode=require"
```

## 3. Project Setup (10 minutes)

```bash
# Run the setup script
cd /Users/Raphael/financial-bpo
chmod +x setup.sh
./setup.sh

# Install dependencies
npm install

# Generate Prisma client
npm run db:generate

# Run database migrations
npm run db:migrate

# Seed initial data (optional)
npm run db:seed
```

## 4. Start Development Servers

### Option 1: With Docker (Recommended)
```bash
# Start all services (Redis, MinIO, etc)
docker-compose up -d

# In another terminal, start the apps
npm run dev
```

### Option 2: Without Docker
```bash
# Terminal 1 - Start API
cd apps/api
npm run dev

# Terminal 2 - Start Web
cd apps/web
npm run dev

# Note: You'll need Redis running locally
# Mac: brew services start redis
# Ubuntu: sudo service redis-server start
```

## 5. Access the Application

1. **Client Portal**: http://localhost:3000/login/demo
   - Each client gets their own login URL
   - Example: `/login/empresa-abc`

2. **API Documentation**: http://localhost:3333/graphql
   - GraphQL playground

3. **Queue Monitor**: http://localhost:3334/bull
   - Monitor background jobs

## 6. Create Your First Tenant

```bash
# Use the CLI tool
npm run cli tenant:create

# Or use the API
curl -X POST http://localhost:3333/api/tenants \
  -H "Content-Type: application/json" \
  -d '{
    "slug": "demo",
    "companyName": "Demo Company",
    "cnpj": "12345678901234",
    "adminEmail": "admin@demo.com",
    "adminPassword": "demo123"
  }'
```

## 7. Test Login

1. Go to: http://localhost:3000/login/demo
2. Use credentials:
   - Email: admin@demo.com
   - Password: demo123

## Common Issues & Solutions

### Neon Connection Error
```
Error: Can't reach database server
```
**Solution**: Make sure you're using the correct connection string with `sslmode=require`

### Port Already in Use
```
Error: Port 3000 is already in use
```
**Solution**: Kill the process or change ports in `.env`

### Redis Connection Error
```
Error: Redis connection failed
```
**Solution**: 
- With Docker: Make sure `docker-compose up redis` is running
- Without Docker: Install and start Redis locally

## Next Steps

1. **Configure DOMINIO Integration**
   - Add your DOMINIO API credentials to `.env`
   - Test the integration endpoint

2. **Set Up Bank Integrations**
   - Start with one bank (recommend Banco do Brasil)
   - Add API credentials to `.env`

3. **Create Your First Client**
   - Use the admin panel to create a real client
   - Configure their specific settings

4. **Deploy to Production**
   - See [deployment guide](./docs/deployment.md)

## Useful Commands

```bash
# Database
npm run db:migrate     # Run migrations
npm run db:seed        # Seed data
npm run db:reset       # Reset database
npm run db:studio      # Open Prisma Studio

# Development
npm run dev            # Start all services
npm run build          # Build for production
npm run test           # Run tests
npm run lint           # Run linter

# Production
npm run start          # Start production server
```

## Support

- Check `/docs` folder for detailed documentation
- Create issues on GitHub for bugs
- Join our Discord for community support

Happy coding! 🚀