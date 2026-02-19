.PHONY: help network-create postgres-dev-up postgres-dev-down postgres-prod-up postgres-prod-down postgres-logs postgres-clean

# Default environment
ENV ?= dev

help: ## Show this help message
	@echo Available targets:
	@echo   network-create                 Create core network
	@echo   network-list                   List all networks
	@echo   postgres-dev-up                Start PostgreSQL 16 in development mode
	@echo   postgres-dev-down              Stop PostgreSQL 16 in development mode
	@echo   postgres-dev-restart           Restart PostgreSQL 16 in development mode
	@echo   postgres-prod-up               Start PostgreSQL 16 in production mode
	@echo   postgres-prod-down             Stop PostgreSQL 16 in production mode
	@echo   postgres-prod-restart          Restart PostgreSQL 16 in production mode
	@echo   postgres-logs                  "Show PostgreSQL logs (use ENV=dev or ENV=prod)"
	@echo   postgres-logs-tail             Show last 100 lines of PostgreSQL logs
	@echo   postgres-shell                 "Connect to PostgreSQL shell (use ENV=dev or ENV=prod)"
	@echo   postgres-clean                 Remove PostgreSQL containers and volumes
	@echo   postgres-clean-all             Remove all PostgreSQL containers, volumes, and networks
	@echo   postgres-backup                "Backup PostgreSQL database (use ENV=dev or ENV=prod)"
	@echo   postgres-status                Show PostgreSQL container status
	@echo   pgadmin-up                     Start pgAdmin4
	@echo   pgadmin-down                   Stop pgAdmin4
	@echo   pgadmin-restart                Restart pgAdmin4
	@echo   pgadmin-logs                   Show pgAdmin4 logs
	@echo   pgadmin-clean                  Remove pgAdmin4 container and volume
	@echo   portainer-up                   Start Portainer
	@echo   portainer-down                 Stop Portainer
	@echo   portainer-restart              Restart Portainer
	@echo   portainer-logs                 Show Portainer logs
	@echo   portainer-clean                Remove Portainer container and volume
	@echo   redis-up                       Start Redis (Shared Instance)
	@echo   redis-down                     Stop Redis
	@echo   monitoring-up                  Start Monitoring tools (Uptime Kuma)
	@echo   monitoring-down                Stop Monitoring tools
	@echo   tools-up                       Start Tools (Syncthing)
	@echo   tools-down                     Stop Tools
	@echo   media-up                       Start Media Server (Jellyfin + FileBrowser)
	@echo   media-down                     Stop Media Server
	@echo   omnimind-up                    Start Omnimind (AI Service)
	@echo   omnimind-down                  Stop Omnimind
	@echo   adguard-up                     Start AdGuard Home (DNS Blocker)
	@echo   adguard-down                   Stop AdGuard Home
	@echo   adguard-logs                   Show AdGuard logs
	@echo   minio-dev-up                   Start MinIO in development mode
	@echo   minio-dev-down                 Stop MinIO in development mode
	@echo   minio-dev-restart              Restart MinIO in development mode
	@echo   minio-prod-up                  Start MinIO in production mode
	@echo   minio-prod-down                Stop MinIO in production mode
	@echo   minio-prod-restart             Restart MinIO in production mode
	@echo   minio-logs                     "Show MinIO logs (use ENV=dev or ENV=prod)"
	@echo   minio-logs-tail                Show last 100 lines of MinIO logs
	@echo   minio-clean                    Remove MinIO containers and volumes
	@echo   minio-clean-all                Remove all MinIO containers, volumes, and networks
	@echo   minio-status                   Show MinIO container status
	@echo   all-up                         Start all services in development mode
	@echo   all-down                       Stop all services in development mode
	@echo   all-prod-up                    Start all services in production mode
	@echo   all-prod-down                  Stop all services in production mode

# Network Management
network-create: ## Create core network
	# Core networks (external)
	-docker network create core_network_dev
	-docker network create core_network_prod

	# NOTE: PostgreSQL and MinIO networks should be created by docker compose
	# (they are not marked external in the compose files).
	# Do NOT pre-create them here to avoid compose label conflicts.

network-list: ## List all networks
	docker network ls

# PostgreSQL 16 - Development
postgres-dev-up: network-create ## Start PostgreSQL 16 in development mode
	cd postgres/postgres16 && docker compose -f docker-compose.dev.yml -p postgres16_dev --env-file .env.dev up -d

postgres-dev-down: ## Stop PostgreSQL 16 in development mode
	cd postgres/postgres16 && docker compose -f docker-compose.dev.yml -p postgres16_dev --env-file .env.dev down

postgres-dev-restart: ## Restart PostgreSQL 16 in development mode
	cd postgres/postgres16 && docker compose -f docker-compose.dev.yml -p postgres16_dev --env-file .env.dev restart

# PostgreSQL 16 - Production
postgres-prod-up: network-create ## Start PostgreSQL 16 in production mode
	cd postgres/postgres16 && docker compose -f docker-compose.prod.yml -p postgres16_prod --env-file .env.prod up -d

postgres-prod-down: ## Stop PostgreSQL 16 in production mode
	cd postgres/postgres16 && docker compose -f docker-compose.prod.yml -p postgres16_prod --env-file .env.prod down

postgres-prod-restart: ## Restart PostgreSQL 16 in production mode
	cd postgres/postgres16 && docker compose -f docker-compose.prod.yml -p postgres16_prod --env-file .env.prod restart

# PostgreSQL Logs
postgres-logs: ## Show PostgreSQL logs (use ENV=dev or ENV=prod)
	cd postgres/postgres16 && docker compose -f docker-compose.$(ENV).yml -p postgres16_$(ENV) --env-file .env.$(ENV) logs -f

postgres-logs-tail: ## Show last 100 lines of PostgreSQL logs
	cd postgres/postgres16 && docker compose -f docker-compose.$(ENV).yml -p postgres16_$(ENV) --env-file .env.$(ENV) logs --tail=100

# PostgreSQL Shell
postgres-shell: ## Connect to PostgreSQL shell (use ENV=dev or ENV=prod)
	cd postgres/postgres16 && docker compose -f docker-compose.$(ENV).yml -p postgres16_$(ENV) --env-file .env.$(ENV) exec postgres16 psql -U admin -d postgres

# Cleanup
postgres-clean: ## Remove PostgreSQL containers and volumes
	cd postgres/postgres16 && docker compose -f docker-compose.$(ENV).yml -p postgres16_$(ENV) --env-file .env.$(ENV) down -v

postgres-clean-all: ## Remove all PostgreSQL containers, volumes, and networks
	-cd postgres/postgres16 && docker compose -f docker-compose.dev.yml -p postgres16_dev --env-file .env.dev down -v
	-cd postgres/postgres16 && docker compose -f docker-compose.prod.yml -p postgres16_prod --env-file .env.prod down -v
	-docker network rm core_network_dev
	-docker network rm core_network_prod

# Backup
postgres-backup: ## Backup PostgreSQL database (Usage: make postgres-backup ENV=dev)
	@mkdir -p backups/postgres
	@echo "Backing up postgres16_$(ENV)..."
	@docker exec -t postgres16_$(ENV) pg_dumpall -c -U admin | gzip > backups/postgres/dump_$(ENV)_$$(date +%Y-%m-%d_%H%M%S).sql.gz
	@echo "Backup saved to backups/postgres/dump_$(ENV)_$$(date +%Y-%m-%d_%H%M%S).sql.gz"

# Status
postgres-status: ## Show PostgreSQL container status
	docker ps -a | grep postgres16 || echo "No PostgreSQL containers found"

# pgAdmin4
pgadmin-up: network-create ## Start pgAdmin4
	cd postgres/pgadmin4 && docker compose up -d

pgadmin-down: ## Stop pgAdmin4
	cd postgres/pgadmin4 && docker compose down

pgadmin-restart: ## Restart pgAdmin4
	cd postgres/pgadmin4 && docker compose restart

pgadmin-logs: ## Show pgAdmin4 logs
	cd postgres/pgadmin4 && docker compose logs -f

pgadmin-clean: ## Remove pgAdmin4 container and volume
	cd postgres/pgadmin4 && docker compose down -v

# Portainer
portainer-up: ## Start Portainer
	cd portainer && docker compose up -d

portainer-down: ## Stop Portainer
	cd portainer && docker compose down

portainer-restart: ## Restart Portainer
	cd portainer && docker compose restart

portainer-logs: ## Show Portainer logs
	cd portainer && docker compose logs -f

portainer-clean: ## Remove Portainer container and volume
	cd portainer && docker compose down -v

# Redis (Shared)
redis-up: ## Start Redis (Shared Instance)
	cd redis && docker compose up -d

redis-down: ## Stop Redis
	cd redis && docker compose down

redis-logs: ## Show Redis logs
	cd redis && docker compose logs -f

# Monitoring (Uptime Kuma)
monitoring-up: ## Start Monitoring tools (Uptime Kuma)
	cd monitoring && docker compose up -d

monitoring-down: ## Stop Monitoring tools
	cd monitoring && docker compose down

# AdGuard Home
adguard-up: ## Start AdGuard Home
	cd adguard && docker compose up -d

adguard-down: ## Stop AdGuard Home
	cd adguard && docker compose down

adguard-logs: ## Show AdGuard logs
	cd adguard && docker compose logs -f

# Omnimind
omnimind-up: ## Start Omnimind
	cd omnimind && docker compose up -d

omnimind-down: ## Stop Omnimind
	cd omnimind && docker compose down

omnimind-logs: ## Show Omnimind logs
	cd omnimind && docker compose logs -f

# Media (Jellyfin + FileBrowser)
media-up: ## Start Media Server
	cd media && docker compose up -d

media-down: ## Stop Media Server
	cd media && docker compose down

media-logs: ## Show Media logs
	cd media && docker compose logs -f

# Tools (Syncthing)
tools-up: ## Start Tools (Syncthing)
	cd tools && docker compose up -d

tools-down: ## Stop Tools
	cd tools && docker compose down

tools-logs: ## Show Tools logs
	cd tools && docker compose logs -f

# MinIO - Development
minio-dev-up: network-create ## Start MinIO in development mode
	cd minio && docker compose -f docker-compose.dev.yml -p minio_dev --env-file .env.dev up -d

minio-dev-down: ## Stop MinIO in development mode
	cd minio && docker compose -f docker-compose.dev.yml -p minio_dev --env-file .env.dev down

minio-dev-restart: ## Restart MinIO in development mode
	cd minio && docker compose -f docker-compose.dev.yml -p minio_dev --env-file .env.dev restart

# MinIO - Production
minio-prod-up: network-create ## Start MinIO in production mode
	cd minio && docker compose -f docker-compose.prod.yml -p minio_prod --env-file .env.prod up -d

minio-prod-down: ## Stop MinIO in production mode
	cd minio && docker compose -f docker-compose.prod.yml -p minio_prod --env-file .env.prod down

minio-prod-restart: ## Restart MinIO in production mode
	cd minio && docker compose -f docker-compose.prod.yml -p minio_prod --env-file .env.prod restart

# MinIO Logs
minio-logs: ## Show MinIO logs (use ENV=dev or ENV=prod)
	cd minio && docker compose -f docker-compose.$(ENV).yml -p minio_$(ENV) --env-file .env.$(ENV) logs -f

minio-logs-tail: ## Show last 100 lines of MinIO logs
	cd minio && docker compose -f docker-compose.$(ENV).yml -p minio_$(ENV) --env-file .env.$(ENV) logs --tail=100

# MinIO Cleanup
minio-clean: ## Remove MinIO containers and volumes (use ENV=dev or ENV=prod)
	cd minio && docker compose -f docker-compose.$(ENV).yml -p minio_$(ENV) --env-file .env.$(ENV) down -v

minio-clean-all: ## Remove all MinIO containers, volumes, and networks
	-cd minio && docker compose -f docker-compose.dev.yml -p minio_dev --env-file .env.dev down -v
	-cd minio && docker compose -f docker-compose.prod.yml -p minio_prod --env-file .env.prod down -v

# MinIO Status
minio-status: ## Show MinIO container status
	docker ps -a | grep minio || echo "No MinIO containers found"

# All Services
all-up: network-create postgres-dev-up redis-up portainer-up minio-dev-up ## Start all services in development mode

all-down: postgres-dev-down redis-down portainer-down minio-dev-down ## Stop all services in development mode

all-prod-up: network-create postgres-prod-up portainer-up minio-prod-up ## Start all services in production mode

all-prod-down: postgres-prod-down portainer-down minio-prod-down ## Stop all services in production mode
