# PostgreSQL Setup Guide for ProductRank

## Overview

This guide will help you migrate from SQLite to PostgreSQL for the ProductRank application.

## Prerequisites

1. PostgreSQL installed on your system
2. Basic knowledge of terminal/command line

## Installation

### On macOS (using Homebrew)
```bash
brew install postgresql
brew services start postgresql
```

### On Ubuntu/Debian
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### On Windows
1. Download PostgreSQL from https://www.postgresql.org/download/windows/
2. Run the installer and follow the setup wizard
3. Remember the password you set for the postgres user

## Database Setup

1. **Connect to PostgreSQL as superuser:**
   ```bash
   sudo -u postgres psql
   ```
   (On Windows: Open "SQL Shell (psql)" from Start menu)

2. **Create user and databases:**
   ```sql
   CREATE USER productrank WITH ENCRYPTED PASSWORD 'your_secure_password';
   
   CREATE DATABASE productrank_development OWNER productrank;
   CREATE DATABASE productrank_test OWNER productrank;
   CREATE DATABASE productrank_production OWNER productrank;
   
   -- Grant privileges
   GRANT ALL PRIVILEGES ON DATABASE productrank_development TO productrank;
   GRANT ALL PRIVILEGES ON DATABASE productrank_test TO productrank;
   GRANT ALL PRIVILEGES ON DATABASE productrank_production TO productrank;
   
   \q
   ```

## Environment Configuration

1. **Create a `.env` file in the project root:**
   ```bash
   touch .env
   ```

2. **Add the following environment variables:**
   ```env
   # PostgreSQL Configuration
   POSTGRES_HOST=localhost
   POSTGRES_PORT=5432
   POSTGRES_USER=productrank
   POSTGRES_PASSWORD=your_secure_password
   
   # Rails Environment
   RAILS_ENV=development
   ```

3. **Add `.env` to your `.gitignore`:**
   ```bash
   echo ".env" >> .gitignore
   ```

## Update Database Configuration

The database configuration has been updated to use PostgreSQL in production while keeping SQLite for development. To fully switch to PostgreSQL:

1. **Update `config/database.yml`** to use PostgreSQL for development:
   ```yaml
   development:
     <<: *default
     database: productrank_development
     username: <%= ENV.fetch("POSTGRES_USER") { "productrank" } %>
     password: <%= ENV["POSTGRES_PASSWORD"] %>
     host: <%= ENV.fetch("POSTGRES_HOST") { "localhost" } %>
     port: <%= ENV.fetch("POSTGRES_PORT") { 5432 } %>
   ```

## Migration Steps

1. **Install required gems:**
   ```bash
   bundle install
   ```

2. **Create and migrate the database:**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

3. **Start the server:**
   ```bash
   bin/rails server
   ```

## Troubleshooting

### Connection Issues
- Ensure PostgreSQL is running: `brew services list` (macOS) or `systemctl status postgresql` (Linux)
- Check if the port 5432 is available: `lsof -i :5432`
- Verify user permissions in PostgreSQL

### Authentication Issues
- Double-check username/password in `.env` file
- Ensure the PostgreSQL user has proper permissions

### Migration Issues
- Drop and recreate databases if needed:
  ```sql
  DROP DATABASE IF EXISTS productrank_development;
  CREATE DATABASE productrank_development OWNER productrank;
  ```

## Production Deployment

For production deployment, ensure:

1. **Secure password management** using encrypted credentials or environment variables
2. **SSL/TLS connections** configured in database.yml
3. **Connection pooling** properly configured for your hosting platform
4. **Backup strategy** implemented

## Docker Setup (Alternative)

If you prefer using Docker for PostgreSQL:

```yaml
# docker-compose.yml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: productrank_development
      POSTGRES_USER: productrank
      POSTGRES_PASSWORD: your_secure_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Run with: `docker-compose up -d`

## Performance Optimization

For better performance in production:

1. **Configure connection pooling**
2. **Enable query logging** for optimization
3. **Set up read replicas** if needed
4. **Configure proper indexes** on frequently queried columns

## Backup and Recovery

Regular backup strategy:
```bash
# Backup
pg_dump productrank_production > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore
psql productrank_production < backup_file.sql
```