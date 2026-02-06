# Docker Containers Setup

Setup Docker containers untuk development dan production environment menggunakan Docker Compose dan Makefile.

## 📦 Services

### PostgreSQL 16 (with pgvector)

- **Dev**: Port 5432
- **Prod**: Port 5433
- Username: `admin`
- Password: `admin`
- Database: `postgres`
- **Note**: Gunakan DBeaver atau database client favorit Anda untuk manajemen database. Includes `pgvector` extension for AI embeddings.

### MinIO

- **Dev**:
  - API: Port 9100
  - Console: Port 9101 (http://localhost:9101)
- **Prod**:
  - API: Port 9200
  - Console: Port 9201 (http://localhost:9201)
- Username: `minioadmin`
- Password: `minioadmin`

### Portainer

- **HTTP**: Port 9000 (http://localhost:9000)
- **HTTPS**: Port 9443 (https://localhost:9443)
- Docker management UI

### Redis (Shared)

- **Port**: 6379 (Bound to 0.0.0.0 - Access controlled by UFW/Tailscale)
- **Password**: None (Disabled for local dev convenience)
- **Databases**:
  - DB 0: Development
  - DB 1: Production

### Monitoring Tools

- **Uptime Kuma** (Status): Port 3001 (Bound to 0.0.0.0)

### Tools

- **Syncthing** (File Sync):
  - **Web UI**: http://localhost:8384
  - **Sync Port**: 22000 (TCP/UDP) - Open this in UFW/Firewall!

## 🚀 Quick Start

### Prerequisites

- Docker installed and running
- Make installed (Linux: `sudo apt install make` or `sudo yum install make`)

### Setup for Development

1. **Clone repository**

   ```bash
   git clone https://github.com/ronal-aldinal/containers.git
   cd containers
   ```

2. **Copy environment files**

   ```bash
   cp postgres/postgres16/.env.example postgres/postgres16/.env.dev
   cp minio/.env.example minio/.env.dev
   cp portainer/.env.example portainer/.env
   cp redis/.env.example redis/.env
   cp monitoring/.env.example monitoring/.env
   cp tools/.env.example tools/.env
   ```

3. **Create networks and start all services**

   ```bash
   make all-up
   ```

### Setup for Production

1. **Clone repository on production machine**

   ```bash
   git clone https://github.com/ronal-aldinal/containers.git
   cd containers
   ```

2. **Copy and configure production environment files**

   ```bash
   # Copy environment files
   cp postgres/postgres16/.env.example postgres/postgres16/.env.prod
   cp minio/.env.example minio/.env.prod
   cp portainer/.env.example portainer/.env
   ```

3. **Edit production credentials** (PENTING!)

   Edit file `.env.prod` di setiap folder service untuk mengatur kredensial production yang aman:
   
   ```bash
   nano postgres/postgres16/.env.prod  # Ubah POSTGRES_PASSWORD
   nano minio/.env.prod                # Ubah MINIO_ROOT_USER & MINIO_ROOT_PASSWORD
   nano portainer/.env                 # (Optional) Sesuaikan port jika perlu
   ```

4. **Start all production services**

   ```bash
   make all-prod-up
   ```

5. **Verify services are running**

   ```bash
   docker ps
   # atau cek individual service:
   make postgres-status
   make minio-status
   ```

## 📋 Available Commands

### Help

```bash
make help                  # Show all available commands
```

### Network Management

```bash
make network-create        # Create core networks
make network-list          # List all networks
```

### PostgreSQL Commands

```bash
# Development
make postgres-dev-up       # Start PostgreSQL dev
make postgres-dev-down     # Stop PostgreSQL dev
make postgres-dev-restart  # Restart PostgreSQL dev

# Production
make postgres-prod-up      # Start PostgreSQL prod
make postgres-prod-down    # Stop PostgreSQL prod
make postgres-prod-restart # Restart PostgreSQL prod

# Utilities
make postgres-logs ENV=dev           # Show logs (ENV=dev or prod)
make postgres-logs-tail ENV=dev      # Show last 100 lines
make postgres-shell ENV=dev          # Connect to PostgreSQL shell
make postgres-status                 # Show container status
make postgres-clean ENV=dev          # Remove container & volume
make postgres-clean-all              # Remove all PostgreSQL data
```

### MinIO Commands

```bash
# Development
make minio-dev-up          # Start MinIO dev
make minio-dev-down        # Stop MinIO dev
make minio-dev-restart     # Restart MinIO dev

# Production
make minio-prod-up         # Start MinIO prod
make minio-prod-down       # Stop MinIO prod
make minio-prod-restart    # Restart MinIO prod

# Utilities
make minio-logs ENV=dev    # Show logs (ENV=dev or prod)
make minio-logs-tail ENV=dev # Show last 100 lines
make minio-status          # Show container status
make minio-clean ENV=dev   # Remove container & volume
make minio-clean-all       # Remove all MinIO data
```

### Portainer Commands


make portainer-clean       # Remove container & volume
```

### Redis Commands

```bash
make redis-up              # Start Redis
make redis-down            # Stop Redis
make redis-logs            # Show logs
```

### Monitoring Commands

```bash
make monitoring-up         # Start Uptime Kuma
make monitoring-down       # Stop Monitoring tools
```

### Tools Commands

```bash
make tools-up              # Start Syncthing
make tools-down            # Stop Syncthing
```

### All Services

```bash
# Development
make all-up                # Start all services (dev mode)
make all-down              # Stop all services (dev mode)

# Production
make all-prod-up           # Start all services (prod mode)
make all-prod-down         # Stop all services (prod mode)
```

## 🏗️ Project Structure

```
.
├── Makefile                          # Main commands
├── README.md                         # This file
├── .gitignore                        # Git ignore rules
│
├── postgres/
│   └── postgres16/
│       ├── docker-compose.dev.yml   # PostgreSQL dev config
│       ├── docker-compose.prod.yml  # PostgreSQL prod config
│       ├── .env.dev                 # Dev environment (on dev machine)
│       └── .env.example             # Template (copy to .env.prod on prod machine)
│
├── minio/
│   ├── docker-compose.dev.yml       # MinIO dev config
│   ├── docker-compose.prod.yml      # MinIO prod config
│   ├── .env.dev                     # Dev environment (on dev machine)
│   └── .env.example                 # Template (copy to .env.prod on prod machine)
│
└── portainer/
    ├── docker-compose.yml           # Portainer config
    ├── .env                         # Environment variables
    └── .env.example                 # Environment template

├── redis/
│   ├── docker-compose.yml           # Redis shared config
│   ├── .env                         # Env variables
│   └── .env.example                 # Template
│
└── monitoring/
    ├── docker-compose.yml           # Uptime Kuma
    ├── .env                         # Env variables
    └── .env.example                 # Template

├── tools/
│   ├── docker-compose.yml           # Syncthing
│   ├── .env                         # Env variables
│   └── .env.example                 # Template
```

## 🌐 Network Architecture

### Development Networks

- `core_network_dev` - Shared network for dev services
- `postgres_network_dev` - PostgreSQL dev
- `minio_network_dev` - MinIO dev

### Production Networks

- `core_network_prod` - Shared network for prod services
- `postgres_network_prod` - PostgreSQL prod
- `minio_network_prod` - MinIO prod

### Portainer

- Accesses Docker socket directly (no network needed)

### Database Management

Gunakan DBeaver atau database client favorit Anda untuk connect ke PostgreSQL. Tidak ada pgAdmin yang diinstall di setup ini.

## 🔧 Configuration

### Changing Ports

Edit the respective `.env.dev` or `.env.prod` files:

**PostgreSQL:**

- Dev: `PORT=5432` in `postgres/postgres16/.env.dev`
- Prod: `PORT=5433` in `postgres/postgres16/.env.prod`

**MinIO:**

- Dev API: `MINIO_API_PORT=9100` in `minio/.env.dev`
- Dev Console: `MINIO_CONSOLE_PORT=9101` in `minio/.env.dev`
- Prod API: `MINIO_API_PORT=9200` in `minio/.env.prod`
- Prod Console: `MINIO_CONSOLE_PORT=9201` in `minio/.env.prod`

**Portainer:**

- HTTP: `PORTAINER_HTTP_PORT=9000` in `portainer/.env`
- HTTPS: `PORTAINER_HTTPS_PORT=9443` in `portainer/.env`

### Changing Credentials

Edit credentials in `.env.dev` and `.env.prod` files before starting services.

**Important:** After changing credentials, restart the services:

```bash
make postgres-dev-down
make postgres-dev-up
```

## 📝 Usage Examples

### Connect to PostgreSQL from Application

**Development:**

```
Host: localhost
Port: 5432
User: admin
Password: admin
Database: postgres
```

**Production:**

```
Host: localhost
Port: 5433
User: admin
Password: admin
Database: postgres
```

**From Docker Container (same network):**

```
Host: postgres16_dev (or postgres16_prod)
Port: 5432
User: admin
Password: admin
Database: postgres
```

### Connect to MinIO from Application

**Development:**

```
Endpoint: http://localhost:9100
Access Key: minioadmin
Secret Key: minioadmin
```

**From Docker Container (same network):**

```
Endpoint: http://minio_dev:9000
Access Key: minioadmin
Secret Key: minioadmin
```

## 🛟 Troubleshooting

### Ports Already in Use

If you get port conflict errors, check what's using the port:

```bash
# Linux
sudo netstat -tulpn | grep :5432
# or
sudo lsof -i :5432
```

Change the port in the respective `.env` file.

### Container Unhealthy

Some containers may show "unhealthy" status but still work fine (like Portainer). Check logs:

```bash
make portainer-logs
```

### Reset Everything

To completely reset all data:

```bash
make postgres-clean-all
make minio-clean-all
make portainer-clean
```

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- [Portainer Documentation](https://docs.portainer.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 📄 License

This is a personal development setup. Modify as needed for your use case.

## 🤝 Contributing

This is a personal setup, but feel free to fork and adapt to your needs!
