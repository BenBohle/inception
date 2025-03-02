# Variablen
DOCKER_COMPOSE = docker compose

.PHONY: build up down

build:
	$(DOCKER_COMPOSE) build

build-nc:
	$(DOCKER_COMPOSE) build --no-cache

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

rmvol:
	$(DOCKER_COMPOSE) down -v