# Docker Containers Setup

Setup Docker containers untuk development dan production environment menggunakan Docker Compose dan Makefile.

## 📦 Services

### PostgreSQL 15

- **Dev**: Port 5432
- **Prod**: Port 5433
- Username: `admin`
- Password: `admin`
- Database: `postgres`
- **Note**: Gunakan DBeaver atau database client favorit Anda untuk manajemen database

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

### n8n

- **Dev**: Port 5678 (http://localhost:5678)
- **Prod**: Port 5679 (http://localhost:5679)
- Workflow automation tool
- Uses PostgreSQL as database backend

### CouchDB

- **Dev**: 
  - Port 5984 (http://localhost:5984)
  - Admin Port 5986
- **Prod**: 
  - Port 5985 (http://localhost:5985)
  - Admin Port 5987
- Username: `admin`
- Password: `admin`
- Fauxton UI available at http://localhost:5984/_utils

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
   cp postgres/postgres15/.env.example postgres/postgres15/.env.dev
   cp minio/.env.example minio/.env.dev
   cp n8n/.env.example n8n/.env.dev
   cp couchdb/.env.example couchdb/.env.dev
   cp portainer/.env.example portainer/.env
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
   cp postgres/postgres15/.env.example postgres/postgres15/.env.prod
   cp minio/.env.example minio/.env.prod
   cp n8n/.env.example n8n/.env.prod
   cp couchdb/.env.example couchdb/.env.prod
   cp portainer/.env.example portainer/.env
   ```

3. **Edit production credentials** (PENTING!)

   Edit file `.env.prod` di setiap folder service untuk mengatur kredensial production yang aman:
   
   ```bash
   nano postgres/postgres15/.env.prod  # Ubah POSTGRES_PASSWORD
   nano minio/.env.prod                # Ubah MINIO_ROOT_USER & MINIO_ROOT_PASSWORD
   nano n8n/.env.prod                  # Ubah N8N credentials
   nano couchdb/.env.prod              # Ubah COUCHDB_USER & COUCHDB_PASSWORD
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
   make n8n-status
   make couchdb-status
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

```bash
make portainer-up          # Start Portainer
make portainer-down        # Stop Portainer
make portainer-restart     # Restart Portainer
make portainer-logs        # Show logs
make portainer-clean       # Remove container & volume
```

### n8n Commands

```bash
# Development
make n8n-dev-up            # Start n8n dev
make n8n-dev-down          # Stop n8n dev
make n8n-dev-restart       # Restart n8n dev

# Production
make n8n-prod-up           # Start n8n prod
make n8n-prod-down         # Stop n8n prod
make n8n-prod-restart      # Restart n8n prod

# Utilities
make n8n-logs ENV=dev      # Show logs (ENV=dev or prod)
make n8n-logs-tail ENV=dev # Show last 100 lines
make n8n-status            # Show container status
make n8n-clean ENV=dev     # Remove container & volume
make n8n-clean-all         # Remove all n8n data
```

### CouchDB Commands

```bash
# Development
make couchdb-dev-up        # Start CouchDB dev
make couchdb-dev-down      # Stop CouchDB dev
make couchdb-dev-restart   # Restart CouchDB dev

# Production
make couchdb-prod-up       # Start CouchDB prod
make couchdb-prod-down     # Stop CouchDB prod
make couchdb-prod-restart  # Restart CouchDB prod

# Utilities
make couchdb-logs ENV=dev      # Show logs (ENV=dev or prod)
make couchdb-logs-tail ENV=dev # Show last 100 lines
make couchdb-status            # Show container status
make couchdb-clean ENV=dev     # Remove container & volume
make couchdb-clean-all         # Remove all CouchDB data
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
│   └── postgres15/
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
├── n8n/
│   ├── docker-compose.dev.yml       # n8n dev config
│   ├── docker-compose.prod.yml      # n8n prod config
│   ├── .env.dev                     # Dev environment (on dev machine)
│   └── .env.example                 # Template (copy to .env.prod on prod machine)
│
├── couchdb/
│   ├── docker-compose.dev.yml       # CouchDB dev config
│   ├── docker-compose.prod.yml      # CouchDB prod config
│   ├── .env.dev                     # Dev environment (on dev machine)
│   └── .env.example                 # Template (copy to .env.prod on prod machine)
│
└── portainer/
    ├── docker-compose.yml           # Portainer config
    ├── .env                         # Environment variables
    └── .env.example                 # Environment template
```

## 🌐 Network Architecture

### Development Networks

- `core_network_dev` - Shared network for dev services
- `postgres_network_dev` - PostgreSQL dev + n8n dev
- `minio_network_dev` - MinIO dev
- `n8n_network_dev` - n8n dev
- `couchdb_network_dev` - CouchDB dev

### Production Networks

- `core_network_prod` - Shared network for prod services
- `postgres_network_prod` - PostgreSQL prod + n8n prod
- `minio_network_prod` - MinIO prod
- `n8n_network_prod` - n8n prod
- `couchdb_network_prod` - CouchDB prod

### Portainer

- Accesses Docker socket directly (no network needed)

### n8n Database

n8n uses PostgreSQL as its database backend, connecting to the same PostgreSQL instance (dev or prod) through the postgres_network.

### Database Management

Gunakan DBeaver atau database client favorit Anda untuk connect ke PostgreSQL. Tidak ada pgAdmin yang diinstall di setup ini.

## 🔧 Configuration

### Changing Ports

Edit the respective `.env.dev` or `.env.prod` files:

**PostgreSQL:**

- Dev: `PORT=5432` in `postgres/postgres15/.env.dev`
- Prod: `PORT=5433` in `postgres/postgres15/.env.prod`

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
Host: postgres15_dev (or postgres15_prod)
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
make n8n-clean-all
make couchdb-clean-all
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
