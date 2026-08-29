# Файл Makefile используется для автоматизации задач сборки и развертывания проекта.

include .env
export

# print working directory
export PROJECT_ROOT = $(shell pwd)

env-up:
	docker compose up -d todoapp-postgres

env-down:
	docker compose down todoapp-postgres

env-cleanup:
	@read -p "Are you sure you want to remove all containers, volumes, and networks? [y/n] " confirm && \
	if [ "$$confirm" = "y" ]; then \
		docker compose down todoapp-postgres && \
		rm -rf out/pgdata && \
		echo "All containers, volumes, and networks have been removed."; \
	else \
		echo "Cleanup canceled."; \
	fi


migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Error: 'seq' variable is not set. Please provide a sequence number for the migration."; \
		exit 1; \
	fi
	docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"


test-target:
	echo "value $(var)"