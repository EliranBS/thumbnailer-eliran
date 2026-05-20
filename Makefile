COMPOSE ?= docker compose
ENV_FILE ?= .env

.PHONY: help init config up down restart ps logs validate

help:
	@echo "Targets:"
	@echo "  init      Create .env from .env.example if missing"
	@echo "  validate  Validate compose file and required files"
	@echo "  config    Print resolved docker compose configuration"
	@echo "  up        Start all services (build if needed)"
	@echo "  down      Stop all services"
	@echo "  restart   Restart all services"
	@echo "  ps        Show service status"
	@echo "  logs      Tail logs for all services"

init:
	@if [ -f $(ENV_FILE) ]; then \
		echo "$(ENV_FILE) already exists"; \
	else \
		cp .env.example $(ENV_FILE) && echo "Created $(ENV_FILE) from .env.example"; \
	fi

validate:
	@test -f docker-compose.yml || (echo "docker-compose.yml not found" && exit 1)
	@test -f settings.xml || (echo "settings.xml not found" && exit 1)
	@test -f .env.example || (echo ".env.example not found" && exit 1)
	@$(COMPOSE) --env-file $(ENV_FILE) config > /dev/null
	@echo "Compose configuration is valid"

config:
	@$(COMPOSE) --env-file $(ENV_FILE) config

up:
	@$(COMPOSE) --env-file $(ENV_FILE) up -d --build

down:
	@$(COMPOSE) --env-file $(ENV_FILE) down

restart:
	@$(COMPOSE) --env-file $(ENV_FILE) down
	@$(COMPOSE) --env-file $(ENV_FILE) up -d --build

ps:
	@$(COMPOSE) --env-file $(ENV_FILE) ps

logs:
	@$(COMPOSE) --env-file $(ENV_FILE) logs -f
