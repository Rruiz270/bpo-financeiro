# Financial BPO System

A comprehensive multi-tenant Financial BPO platform with integration to DOMINIO accounting system.

## Features

- **Accounts Payable**: Complete supplier and payment management
- **Accounts Receivable**: Customer management, invoicing, and collections
- **Treasury**: Cash flow management and projections
- **Bank Reconciliation**: Automated matching and reconciliation
- **Real-time Dashboards**: KPIs and financial metrics
- **Multi-tenant Architecture**: Separate client portals with data isolation

## Quick Start

### Prerequisites
- Node.js 18+
- PostgreSQL 15+
- Redis 7+
- Docker (optional)

### Installation

1. Clone the repository
```bash
git clone <your-repo>
cd financial-bpo
```

2. Install dependencies
```bash
npm install
```

3. Set up environment variables
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run database migrations
```bash
npm run db:migrate
```

5. Start development servers
```bash
npm run dev
```

## Project Structure

```
financial-bpo/
├── apps/
│   ├── api/         # NestJS backend API
│   └── web/         # Next.js frontend
├── packages/
│   ├── database/    # Prisma schemas
│   ├── shared/      # Shared types and utilities
│   └── ui/          # Shared UI components
└── docs/            # Documentation
```

## Development

### API Development
```bash
cd apps/api
npm run dev
```
API will be available at http://localhost:3333

### Frontend Development
```bash
cd apps/web
npm run dev
```
Web app will be available at http://localhost:3000

## Testing

```bash
# Run all tests
npm test

# Run API tests
npm run test:api

# Run E2E tests
npm run test:e2e
```

## Deployment

See [deployment guide](./docs/deployment.md) for production deployment instructions.

## License

Proprietary - All rights reserved