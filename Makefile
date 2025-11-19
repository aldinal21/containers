.PHONY: help network-create postgres-dev-up postgres-dev-down postgres-prod-up postgres-prod-down postgres-logs postgres-clean

# Default environment
ENV ?= dev

help: ## Show this help message
	@echo Available targets:
	@echo   network-create                 Create core network
	@echo   network-list                   List all networks
	@echo   postgres-dev-up                Start PostgreSQL 15 in development mode
	@echo   postgres-dev-down              Stop PostgreSQL 15 in development mode
	@echo   postgres-dev-restart           Restart PostgreSQL 15 in development mode
	@echo   postgres-prod-up               Start PostgreSQL 15 in production mode
	@echo   postgres-prod-down             Stop PostgreSQL 15 in production mode
	@echo   postgres-prod-restart          Restart PostgreSQL 15 in production mode
	@echo   postgres-logs                  Show PostgreSQL logs (use ENV=dev or ENV=prod)
	@echo   postgres-logs-tail             Show last 100 lines of PostgreSQL logs
	@echo   postgres-shell                 Connect to PostgreSQL shell
	@echo   postgres-clean                 Remove PostgreSQL containers and volumes
	@echo   postgres-clean-all             Remove all PostgreSQL containers, volumes, and networks
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
	@echo   minio-dev-up                   Start MinIO in development mode
	@echo   minio-dev-down                 Stop MinIO in development mode
	@echo   minio-dev-restart              Restart MinIO in development mode
	@echo   minio-prod-up                  Start MinIO in production mode
	@echo   minio-prod-down                Stop MinIO in production mode
	@echo   minio-prod-restart             Restart MinIO in production mode
	@echo   minio-logs                     Show MinIO logs (use ENV=dev or ENV=prod)
	@echo   minio-logs-tail                Show last 100 lines of MinIO logs
	@echo   minio-clean                    Remove MinIO containers and volumes
	@echo   minio-clean-all                Remove all MinIO containers, volumes, and networks
	@echo   minio-status                   Show MinIO container status
	@echo   n8n-dev-up                     Start n8n in development mode
	@echo   n8n-dev-down                   Stop n8n in development mode
	@echo   n8n-dev-restart                Restart n8n in development mode
	@echo   n8n-prod-up                    Start n8n in production mode
	@echo   n8n-prod-down                  Stop n8n in production mode
	@echo   n8n-prod-restart               Restart n8n in production mode
	@echo   n8n-logs                       Show n8n logs (use ENV=dev or ENV=prod)
	@echo   n8n-logs-tail                  Show last 100 lines of n8n logs
	@echo   n8n-clean                      Remove n8n containers and volumes
	@echo   n8n-clean-all                  Remove all n8n containers, volumes, and networks
	@echo   n8n-status                     Show n8n container status
	@echo   couchdb-dev-up                 Start CouchDB in development mode
	@echo   couchdb-dev-down               Stop CouchDB in development mode
	@echo   couchdb-dev-restart            Restart CouchDB in development mode
	@echo   couchdb-prod-up                Start CouchDB in production mode
	@echo   couchdb-prod-down              Stop CouchDB in production mode
	@echo   couchdb-prod-restart           Restart CouchDB in production mode
	@echo   couchdb-logs                   Show CouchDB logs (use ENV=dev or ENV=prod)
	@echo   couchdb-logs-tail              Show last 100 lines of CouchDB logs
	@echo   couchdb-clean                  Remove CouchDB containers and volumes
	@echo   couchdb-clean-all              Remove all CouchDB containers, volumes, and networks
	@echo   couchdb-status                 Show CouchDB container status
	@echo   all-up                         Start all services in development mode
	@echo   all-down                       Stop all services in development mode
	@echo   all-prod-up                    Start all services in production mode
	@echo   all-prod-down                  Stop all services in production mode

# Network Management
network-create: ## Create core network
	# Core networks (external)
	-docker network create core_network_dev
	-docker network create core_network_prod

	# NOTE: PostgreSQL, MinIO, n8n, and CouchDB networks should be created by docker compose
	# (they are not marked external in the compose files).
	# Do NOT pre-create them here to avoid compose label conflicts.

network-list: ## List all networks
	docker network ls

# PostgreSQL 15 - Development
postgres-dev-up: network-create ## Start PostgreSQL 15 in development mode
	cd postgres/postgres15 && docker compose -f docker-compose.dev.yml -p postgres15_dev --env-file .env.dev up -d

postgres-dev-down: ## Stop PostgreSQL 15 in development mode
	cd postgres/postgres15 && docker compose -f docker-compose.dev.yml -p postgres15_dev --env-file .env.dev down

postgres-dev-restart: ## Restart PostgreSQL 15 in development mode
	cd postgres/postgres15 && docker compose -f docker-compose.dev.yml -p postgres15_dev --env-file .env.dev restart

# PostgreSQL 15 - Production
postgres-prod-up: network-create ## Start PostgreSQL 15 in production mode
	cd postgres/postgres15 && docker compose -f docker-compose.prod.yml -p postgres15_prod --env-file .env.prod up -d

postgres-prod-down: ## Stop PostgreSQL 15 in production mode
	cd postgres/postgres15 && docker compose -f docker-compose.prod.yml -p postgres15_prod --env-file .env.prod down

postgres-prod-restart: ## Restart PostgreSQL 15 in production mode
	cd postgres/postgres15 && docker compose -f docker-compose.prod.yml -p postgres15_prod --env-file .env.prod restart

# PostgreSQL Logs
postgres-logs: ## Show PostgreSQL logs (use ENV=dev or ENV=prod)
	cd postgres/postgres15 && docker compose -f docker-compose.$(ENV).yml -p postgres15_$(ENV) --env-file .env.$(ENV) logs -f

postgres-logs-tail: ## Show last 100 lines of PostgreSQL logs
	cd postgres/postgres15 && docker compose -f docker-compose.$(ENV).yml -p postgres15_$(ENV) --env-file .env.$(ENV) logs --tail=100

# PostgreSQL Shell
postgres-shell: ## Connect to PostgreSQL shell (use ENV=dev or ENV=prod)
	cd postgres/postgres15 && docker compose -f docker-compose.$(ENV).yml -p postgres15_$(ENV) --env-file .env.$(ENV) exec postgres15 psql -U admin -d postgres

# Cleanup
postgres-clean: ## Remove PostgreSQL containers and volumes
	cd postgres/postgres15 && docker compose -f docker-compose.$(ENV).yml -p postgres15_$(ENV) --env-file .env.$(ENV) down -v

postgres-clean-all: ## Remove all PostgreSQL containers, volumes, and networks
	-cd postgres/postgres15 && docker compose -f docker-compose.dev.yml -p postgres15_dev --env-file .env.dev down -v
	-cd postgres/postgres15 && docker compose -f docker-compose.prod.yml -p postgres15_prod --env-file .env.prod down -v
	-docker network rm core_network_dev
	-docker network rm core_network_prod

# Status
postgres-status: ## Show PostgreSQL container status
	docker ps -a | grep postgres15 || echo "No PostgreSQL containers found"

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

# n8n - Development
n8n-dev-up: network-create postgres-dev-up ## Start n8n in development mode
	cd n8n && docker compose -f docker-compose.dev.yml -p n8n_dev --env-file .env.dev up -d

n8n-dev-down: ## Stop n8n in development mode
	cd n8n && docker compose -f docker-compose.dev.yml -p n8n_dev --env-file .env.dev down

n8n-dev-restart: ## Restart n8n in development mode
	cd n8n && docker compose -f docker-compose.dev.yml -p n8n_dev --env-file .env.dev restart

# n8n - Production
n8n-prod-up: network-create postgres-prod-up ## Start n8n in production mode
	cd n8n && docker compose -f docker-compose.prod.yml -p n8n_prod --env-file .env.prod up -d

n8n-prod-down: ## Stop n8n in production mode
	cd n8n && docker compose -f docker-compose.prod.yml -p n8n_prod --env-file .env.prod down

n8n-prod-restart: ## Restart n8n in production mode
	cd n8n && docker compose -f docker-compose.prod.yml -p n8n_prod --env-file .env.prod restart

# n8n Logs
n8n-logs: ## Show n8n logs (use ENV=dev or ENV=prod)
	cd n8n && docker compose -f docker-compose.$(ENV).yml -p n8n_$(ENV) --env-file .env.$(ENV) logs -f

n8n-logs-tail: ## Show last 100 lines of n8n logs
	cd n8n && docker compose -f docker-compose.$(ENV).yml -p n8n_$(ENV) --env-file .env.$(ENV) logs --tail=100

# n8n Cleanup
n8n-clean: ## Remove n8n containers and volumes (use ENV=dev or ENV=prod)
	cd n8n && docker compose -f docker-compose.$(ENV).yml -p n8n_$(ENV) --env-file .env.$(ENV) down -v

n8n-clean-all: ## Remove all n8n containers, volumes, and networks
	-cd n8n && docker compose -f docker-compose.dev.yml -p n8n_dev --env-file .env.dev down -v
	-cd n8n && docker compose -f docker-compose.prod.yml -p n8n_prod --env-file .env.prod down -v

# n8n Status
n8n-status: ## Show n8n container status
	docker ps -a | grep n8n || echo "No n8n containers found"

# CouchDB - Development
couchdb-dev-up: network-create ## Start CouchDB in development mode
	cd couchdb && docker compose -f docker-compose.dev.yml -p couchdb_dev --env-file .env.dev up -d

couchdb-dev-down: ## Stop CouchDB in development mode
	cd couchdb && docker compose -f docker-compose.dev.yml -p couchdb_dev --env-file .env.dev down

couchdb-dev-restart: ## Restart CouchDB in development mode
	cd couchdb && docker compose -f docker-compose.dev.yml -p couchdb_dev --env-file .env.dev restart

# CouchDB - Production
couchdb-prod-up: network-create ## Start CouchDB in production mode
	cd couchdb && docker compose -f docker-compose.prod.yml -p couchdb_prod --env-file .env.prod up -d

couchdb-prod-down: ## Stop CouchDB in production mode
	cd couchdb && docker compose -f docker-compose.prod.yml -p couchdb_prod --env-file .env.prod down

couchdb-prod-restart: ## Restart CouchDB in production mode
	cd couchdb && docker compose -f docker-compose.prod.yml -p couchdb_prod --env-file .env.prod restart

# CouchDB Logs
couchdb-logs: ## Show CouchDB logs (use ENV=dev or ENV=prod)
	cd couchdb && docker compose -f docker-compose.$(ENV).yml -p couchdb_$(ENV) --env-file .env.$(ENV) logs -f

couchdb-logs-tail: ## Show last 100 lines of CouchDB logs
	cd couchdb && docker compose -f docker-compose.$(ENV).yml -p couchdb_$(ENV) --env-file .env.$(ENV) logs --tail=100

# CouchDB Cleanup
couchdb-clean: ## Remove CouchDB containers and volumes (use ENV=dev or ENV=prod)
	cd couchdb && docker compose -f docker-compose.$(ENV).yml -p couchdb_$(ENV) --env-file .env.$(ENV) down -v

couchdb-clean-all: ## Remove all CouchDB containers, volumes, and networks
	-cd couchdb && docker compose -f docker-compose.dev.yml -p couchdb_dev --env-file .env.dev down -v
	-cd couchdb && docker compose -f docker-compose.prod.yml -p couchdb_prod --env-file .env.prod down -v

# CouchDB Status
couchdb-status: ## Show CouchDB container status
	docker ps -a | grep couchdb || echo "No CouchDB containers found"

# All Services
all-up: network-create postgres-dev-up portainer-up minio-dev-up n8n-dev-up couchdb-dev-up ## Start all services in development mode

all-down: couchdb-dev-down n8n-dev-down postgres-dev-down portainer-down minio-dev-down ## Stop all services in development mode

all-prod-up: network-create postgres-prod-up portainer-up minio-prod-up n8n-prod-up couchdb-prod-up ## Start all services in production mode

all-prod-down: couchdb-prod-down n8n-prod-down postgres-prod-down portainer-down minio-prod-down ## Stop all services in production mode
