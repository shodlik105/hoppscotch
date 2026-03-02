STACK = hoppscotch

.PHONY: postgres-up services-up migrates-up

postgres-up:
	set -a && . ./.env && set +a && docker stack deploy -c databases/postgres-config.yaml $(STACK)

services-up:
	set -a && . ./.env && set +a && docker stack deploy -c databases/postgres-config.yaml -c services/config.yaml $(STACK)

migrates-up:
	set -a && . ./.env && set +a && docker stack deploy -c databases/postgres-config.yaml -c migrates/migrate-config.yaml $(STACK)
