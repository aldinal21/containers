# Home Server Infrastructure - v1.0.0

A production-ready Docker infrastructure for personal development, AI services, and media management. Optimized for low-resource environments (e.g., 8GB RAM) with strict resource limits and automated maintenance.

## 🏗️ Architecture Overview

- **OS**: Ubuntu Server (LVM Managed)
- **Memory**: 8GB Physical + 15GB Swap
- **Networking**: All services bind to `0.0.0.0`, secured by **UFW** and accessible via **Tailscale**.
- **Maintenance**: 
  - **Log Rotation**: Max 3 files x 10MB per container.
  - **Resource Limits**: Strict RAM caps on all services.
  - **Backups**: Automated database dumps via Makefile.

## 📦 Services

### 🐘 Database (PostgreSQL 16 + pgvector)
- **Image**: `pgvector/pgvector:pg16`
- **Dev Port**: `5432` | **Prod Port**: `5433`
- **Memory Limit**: 1.5GB
- **Usage**: General relational data + AI Vector Embeddings.

### 🧠 Custom AI (Omnimind)
- **Image**: `ronalll/omnimind:latest`
- **Port**: `6789`
- **Feature**: Native TTS (Gemini) and AI Logic Aggregator.

### 📂 Object Storage (MinIO)
- **Dev API**: `9100` | **Dev Console**: `9101`
- **Prod API**: `9200` | **Prod Console**: `9201`
- **Memory Limit**: 512MB

### ⚡ Cache (Redis Shared)
- **Port**: `6379`
- **Memory Limit**: 128MB
- **Database**: DB 0 (Dev), DB 1 (Prod).

### 🎬 Media Server (Jellyfin + FileBrowser)
- **Jellyfin**: `:8096` (Streaming)
- **FileBrowser**: `:8081` (File Management & Upload)
- **Path**: `/home/aldinal21/Movies`

### 📊 Monitoring & Management
- **Portainer**: `:9000` / `:9443` (Docker UI)
- **Uptime Kuma**: `:3001` (Service Monitoring)
- **AdGuard Home**: `:8085` (DNS Ad-blocker)

## 🚀 Quick Start

1. **Setup Folders**:
   ```bash
   mkdir -p ~/Movies/Film ~/Movies/Series
   ```

2. **Environment Configuration**:
   ```bash
   cp postgres/postgres16/.env.example postgres/postgres16/.env.dev
   cp postgres/postgres16/.env.example postgres/postgres16/.env.prod
   cp minio/.env.example minio/.env.dev
   cp redis/.env.example redis/.env
   cp monitoring/.env.example monitoring/.env
   cp media/.env.example media/.env
   cp omnimind/.env.example omnimind/.env
   cp adguard/.env.example adguard/.env
   ```

3. **Start Core Services**:
   ```bash
   make all-up monitoring-up media-up omnimind-up
   ```

## 🛠️ Management Commands (Makefile)

- `make help`: Show all available commands.
- `make postgres-backup ENV=dev`: Manual DB backup.
- `make <service>-logs`: Tail logs for any service.
- `make <service>-down`: Stop specific service.

## 🏗️ Project Structure

```
.
├── Makefile
├── README.md
├── .gemini.md
│
├── adguard/
├── media/
├── monitoring/
├── omnimind/
├── portainer/
├── postgres/
├── redis/
└── tools/
```

---
*Maintained by @aldinal21*
