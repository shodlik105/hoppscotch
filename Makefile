STACK      = hoppscotch
IMAGE      = hoppscotch/hoppscotch
TAG        = password
FULL_IMAGE = $(IMAGE):$(TAG)
COMPOSE    = services/config.yaml

.PHONY: build build-auth build-hoppscotch services-up services-down migrate logs ps restart restart-app restart-nginx restart-auth help

## ── Build ─────────────────────────────────────────────────────────────────
build: build-auth

build-auth:
	docker build -t hoppscotch-auth:local auth-service/

build-hoppscotch:
	DOCKER_BUILDKIT=0 docker build \
		--build-arg TARGETARCH=$(shell uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') \
		-f src/prod.Dockerfile --target aio \
		-t $(FULL_IMAGE) src/

## ── Deploy ────────────────────────────────────────────────────────────────
services-up: .env.urls
	set -a && . ./.env && set +a && \
	docker stack deploy -c $(COMPOSE) $(STACK)

services-down:
	docker stack rm $(STACK)

## ── Migration ─────────────────────────────────────────────────────────────
migrate:
	set -a && . ./.env && set +a && \
	docker stack deploy -c $(COMPOSE) $(STACK)

## ── Env URLs ──────────────────────────────────────────────────────────────
.env.urls:
	bash scripts/gen-env-urls.sh

env-urls:
	bash scripts/gen-env-urls.sh

## ── Logs & Status ─────────────────────────────────────────────────────────
logs:
	docker service logs -f $(STACK)_hoppscotch

logs-nginx:
	docker service logs -f $(STACK)_nginx

logs-backend:
	docker service logs -f $(STACK)_hoppscotch 2>&1 | grep -i "backend\|nest\|error"

ps:
	docker stack ps $(STACK)

## ── Restart services ──────────────────────────────────────────────────────
restart:
	docker service update --force $(STACK)_hoppscotch
	docker service update --force $(STACK)_nginx

restart-app:
	docker service update --force $(STACK)_hoppscotch

restart-nginx:
	docker service update --force $(STACK)_nginx

restart-auth:
	docker service update --force --image hoppscotch-auth:local $(STACK)_auth-service

## ── Help ──────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "  make build          — Docker image qurish (src/ dan)"
	@echo "  make services-up    — Swarm stack deploy qilish"
	@echo "  make services-down  — Stackni o'chirish"
	@echo "  make migrate        — DB migratsiya ishlatish"
	@echo "  make logs           — Hoppscotch loglarini ko'rish"
	@echo "  make ps             — Stack holatini ko'rish"
	@echo "  make restart        — Hoppscotch + Nginx qayta ishlatish"
	@echo "  make env-urls       — .env.urls ni qayta generatsiya qilish"
	@echo ""
