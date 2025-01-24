# Variablen
DOCKER_COMPOSE = docker-compose

.PHONY: build up down

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down
