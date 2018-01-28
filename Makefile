# "make" - build all Docker images
.PHONY: all
all: build build-dev

# "make start" - build and run the *development* Docker images
.PHONY: start
start: build-dev up-dev

# "make serve" - build and run the *final* Docker images
.PHONY: serve
serve: build up

# "make clean" - stop all Dockers and clean up
.PHONY: clean
clean: down down-dev
	docker system prune -f

# Get an interactive shell in one of the running Docker
#   make shell <docker-name>
#   e.g. "make shell task-api"
.PHONY: shell
shell:
	docker exec -it $(CMDARGS) /bin/sh

# Execute a shell command in one of the running Dockers
#   make exec <docker-name> <command>
#   e.g. "make exec task-api npm version"
.PHONY: exec
exec:
	docker exec -t $(CMDARGS)

# Building and running the *final* Docker images using Compose
#   uses docker-compose.yml
.PHONY: build up down
build:
	docker-compose build
up:
	docker-compose up
down:
	docker-compose down

# Building and running the *development* Docker images using Compose
#   uses docker-compose-dev.yml
.PHONY: build-dev up-dev down-dev
build-dev:
	docker-compose -f docker-compose-dev.yml build
up-dev:
	docker-compose -f docker-compose-dev.yml up
down-dev:
	docker-compose -f docker-compose-dev.yml down

# If the first target is "exec" or "shell", store the remaining list of targets 
# in CMDARGS and prevent their execution (treat as arguments instead).
CMD := $(firstword $(MAKECMDGOALS))
ifeq ($(CMD),$(filter $(CMD),exec shell))
  CMDARGS := $(filter-out exec shell, $(MAKECMDGOALS))
  $(eval $(CMDARGS):;@:)
endif