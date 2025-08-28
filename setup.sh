#!/bin/bash

# Financial BPO System - Initial Setup Script

echo "🚀 Setting up Financial BPO System..."

# Create monorepo structure
echo "📁 Creating project structure..."

# Root package.json
cat > package.json << EOF
{
  "name": "financial-bpo",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "test": "turbo run test",
    "lint": "turbo run lint",
    "db:migrate": "cd packages/database && npx prisma migrate dev",
    "db:generate": "cd packages/database && npx prisma generate",
    "db:seed": "cd packages/database && npx tsx seed.ts"
  },
  "devDependencies": {
    "turbo": "^1.11.0",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

# Create directories
mkdir -p apps/api/src/{modules,common,config}
mkdir -p apps/web/{app,components,lib,hooks,services}
mkdir -p packages/{database,shared,ui}
mkdir -p docs

# Initialize NestJS API
echo "🔧 Setting up API..."
cd apps/api

cat > package.json << EOF
{
  "name": "@financial-bpo/api",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "nest start --watch",
    "build": "nest build",
    "test": "jest"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/config": "^3.0.0",
    "@nestjs/jwt": "^10.0.0",
    "@nestjs/passport": "^10.0.0",
    "@nestjs/graphql": "^12.0.0",
    "@nestjs/apollo": "^12.0.0",
    "@apollo/server": "^4.0.0",
    "graphql": "^16.0.0",
    "@prisma/client": "^5.0.0",
    "bcrypt": "^5.1.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.0",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.0",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.8.0"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/express": "^4.17.17",
    "@types/jest": "^29.5.0",
    "@types/bcrypt": "^5.0.0",
    "jest": "^29.5.0",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.0"
  }
}
EOF

# Create NestJS configuration
cat > nest-cli.json << EOF
{
  "type": "application",
  "root": "src",
  "compilerOptions": {
    "deleteOutDir": true
  }
}
EOF

# Create main.ts
cat > src/main.ts << EOF
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  
  await app.listen(3333);
  console.log('🚀 API running on http://localhost:3333');
}
bootstrap();
EOF

# Initialize Next.js Web App
echo "🎨 Setting up Web App..."
cd ../../apps/web

cat > package.json << EOF
{
  "name": "@financial-bpo/web",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@radix-ui/react-alert-dialog": "^1.0.0",
    "@radix-ui/react-dialog": "^1.0.0",
    "@radix-ui/react-dropdown-menu": "^2.0.0",
    "@radix-ui/react-label": "^2.0.0",
    "@radix-ui/react-select": "^2.0.0",
    "@radix-ui/react-slot": "^1.0.0",
    "@radix-ui/react-tabs": "^1.0.0",
    "@radix-ui/react-toast": "^1.0.0",
    "@tanstack/react-query": "^5.0.0",
    "@hookform/resolvers": "^3.0.0",
    "react-hook-form": "^7.0.0",
    "axios": "^1.6.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "date-fns": "^2.30.0",
    "lucide-react": "^0.290.0",
    "recharts": "^2.9.0",
    "tailwind-merge": "^2.0.0",
    "tailwindcss-animate": "^1.0.0",
    "zod": "^3.22.0",
    "zustand": "^4.4.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "autoprefixer": "^10.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "14.0.0",
    "postcss": "^8.0.0",
    "tailwindcss": "^3.3.0",
    "typescript": "^5.0.0"
  }
}
EOF

# Create Next.js config
cat > next.config.js << EOF
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    serverActions: true
  }
}

module.exports = nextConfig
EOF

# Create Tailwind config
cat > tailwind.config.ts << EOF
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        }
      }
    },
  },
  plugins: [require('tailwindcss-animate')],
}

export default config
EOF

# Initialize Database Package
echo "🗄️  Setting up Database Package..."
cd ../../packages/database

cat > package.json << EOF
{
  "name": "@financial-bpo/database",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "generate": "prisma generate",
    "migrate": "prisma migrate dev",
    "seed": "tsx seed.ts"
  },
  "dependencies": {
    "@prisma/client": "^5.0.0"
  },
  "devDependencies": {
    "prisma": "^5.0.0",
    "tsx": "^4.0.0",
    "@types/node": "^20.0.0"
  }
}
EOF

# Create Prisma schema
cat > schema.prisma << EOF
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model Tenant {
  id               String   @id @default(uuid())
  slug             String   @unique
  companyName      String   @map("company_name")
  tradeName        String?  @map("trade_name")
  cnpj             String   @unique
  dominioApiKey    String?  @map("dominio_api_key")
  subscriptionPlan String   @default("basic") @map("subscription_plan")
  isActive         Boolean  @default(true) @map("is_active")
  createdAt        DateTime @default(now()) @map("created_at")
  updatedAt        DateTime @updatedAt @map("updated_at")

  users            UserTenant[]
  suppliers        Supplier[]
  customers        Customer[]
  accountsPayable  AccountsPayable[]
  accountsReceivable AccountsReceivable[]
  bankAccounts     BankAccount[]

  @@map("tenants")
}

model User {
  id           String   @id @default(uuid())
  email        String   @unique
  passwordHash String   @map("password_hash")
  fullName     String   @map("full_name")
  cpf          String?
  phone        String?
  avatarUrl    String?  @map("avatar_url")
  isSuperAdmin Boolean  @default(false) @map("is_super_admin")
  isActive     Boolean  @default(true) @map("is_active")
  lastLoginAt  DateTime? @map("last_login_at")
  createdAt    DateTime @default(now()) @map("created_at")
  updatedAt    DateTime @updatedAt @map("updated_at")

  tenants      UserTenant[]

  @@map("users")
}

model UserTenant {
  id        String   @id @default(uuid())
  userId    String   @map("user_id")
  tenantId  String   @map("tenant_id")
  role      String   @default("operator")
  createdAt DateTime @default(now()) @map("created_at")

  user   User   @relation(fields: [userId], references: [id])
  tenant Tenant @relation(fields: [tenantId], references: [id])

  @@unique([userId, tenantId])
  @@map("user_tenants")
}

model Supplier {
  id          String   @id @default(uuid())
  tenantId    String   @map("tenant_id")
  cnpjCpf     String   @map("cnpj_cpf")
  name        String
  tradeName   String?  @map("trade_name")
  contactInfo Json?    @map("contact_info")
  bankAccounts Json?   @map("bank_accounts")
  paymentTerms Int     @default(30) @map("payment_terms")
  isActive    Boolean  @default(true) @map("is_active")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  tenant   Tenant @relation(fields: [tenantId], references: [id])
  payables AccountsPayable[]

  @@unique([tenantId, cnpjCpf])
  @@map("suppliers")
}

model Customer {
  id              String   @id @default(uuid())
  tenantId        String   @map("tenant_id")
  cnpjCpf         String   @map("cnpj_cpf")
  name            String
  tradeName       String?  @map("trade_name")
  contactInfo     Json?    @map("contact_info")
  creditLimit     Decimal  @default(0) @map("credit_limit")
  paymentTerms    Int      @default(30) @map("payment_terms")
  isActive        Boolean  @default(true) @map("is_active")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  tenant      Tenant @relation(fields: [tenantId], references: [id])
  receivables AccountsReceivable[]

  @@unique([tenantId, cnpjCpf])
  @@map("customers")
}

model AccountsPayable {
  id              String    @id @default(uuid())
  tenantId        String    @map("tenant_id")
  supplierId      String    @map("supplier_id")
  documentNumber  String?   @map("document_number")
  description     String
  originalAmount  Decimal   @map("original_amount")
  paidAmount      Decimal   @default(0) @map("paid_amount")
  dueDate         DateTime  @map("due_date")
  paymentDate     DateTime? @map("payment_date")
  paymentStatus   String    @default("pending") @map("payment_status")
  createdAt       DateTime  @default(now()) @map("created_at")
  updatedAt       DateTime  @updatedAt @map("updated_at")

  tenant   Tenant   @relation(fields: [tenantId], references: [id])
  supplier Supplier @relation(fields: [supplierId], references: [id])

  @@map("accounts_payable")
}

model AccountsReceivable {
  id              String    @id @default(uuid())
  tenantId        String    @map("tenant_id")
  customerId      String    @map("customer_id")
  documentNumber  String?   @map("document_number")
  description     String
  originalAmount  Decimal   @map("original_amount")
  receivedAmount  Decimal   @default(0) @map("received_amount")
  dueDate         DateTime  @map("due_date")
  paymentDate     DateTime? @map("payment_date")
  collectionStatus String   @default("pending") @map("collection_status")
  createdAt       DateTime  @default(now()) @map("created_at")
  updatedAt       DateTime  @updatedAt @map("updated_at")

  tenant   Tenant   @relation(fields: [tenantId], references: [id])
  customer Customer @relation(fields: [customerId], references: [id])

  @@map("accounts_receivable")
}

model BankAccount {
  id             String   @id @default(uuid())
  tenantId       String   @map("tenant_id")
  bankCode       String   @map("bank_code")
  bankName       String   @map("bank_name")
  agencyNumber   String   @map("agency_number")
  accountNumber  String   @map("account_number")
  accountType    String   @map("account_type")
  currentBalance Decimal  @default(0) @map("current_balance")
  isActive       Boolean  @default(true) @map("is_active")
  createdAt      DateTime @default(now()) @map("created_at")
  updatedAt      DateTime @updatedAt @map("updated_at")

  tenant Tenant @relation(fields: [tenantId], references: [id])

  @@map("bank_accounts")
}
EOF

# Create environment example
cd ../..
cat > .env.example << EOF
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/financial_bpo?schema=public"

# Redis
REDIS_URL="redis://localhost:6379"

# JWT
JWT_SECRET="your-super-secret-jwt-key"
JWT_EXPIRES_IN="7d"

# API URLs
API_URL="http://localhost:3333"
NEXT_PUBLIC_API_URL="http://localhost:3333"

# DOMINIO Integration
DOMINIO_API_URL="https://api.dominio.com.br"
DOMINIO_API_KEY="your-dominio-api-key"

# Banking APIs (add as needed)
BANCO_DO_BRASIL_CLIENT_ID=""
BANCO_DO_BRASIL_CLIENT_SECRET=""
EOF

# Create turbo.json
cat > turbo.json << EOF
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "lint": {
      "outputs": []
    }
  }
}
EOF

# Create .gitignore
cat > .gitignore << EOF
# Dependencies
node_modules
.pnp
.pnp.js

# Testing
coverage
.nyc_output

# Next.js
.next/
out/
build
dist

# Misc
.DS_Store
*.pem
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# IDE
.vscode
.idea

# Turbo
.turbo

# Prisma
packages/database/prisma/migrations
EOF

echo "✅ Project structure created!"
echo ""
echo "📋 Next steps:"
echo "1. Run 'npm install' to install dependencies"
echo "2. Set up your PostgreSQL database"
echo "3. Copy .env.example to .env and configure"
echo "4. Run 'npm run db:migrate' to create database tables"
echo "5. Run 'npm run dev' to start development servers"
echo ""
echo "🎉 Happy coding!"