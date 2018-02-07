######################### BUILDING & RUNNING #########################

# "make" - Build all Docker images.
.PHONY: all
all: build build-dev

# "make start" - Build and run the *development* Docker images.
.PHONY: start
start: build-dev up-dev

# "make serve" - Build and run the *final* (i.e. "production", optimized) Docker images.
.PHONY: serve
serve: build up

# "make clean" - Stop all Dockers and clean up.
.PHONY: clean
clean: stop
	docker system prune -f
	
# "make stop" - Stop all Docker containers.
.PHONY: stop
stop: down down-dev

# Building and running the *final* Docker images using Compose.
#   uses docker-compose.yml
.PHONY: build up down
build:
	docker-compose build
up:
	docker-compose up
down:
	docker-compose down

# Building and running the *development* Docker images using Compose.
#   uses docker-compose-dev.yml
.PHONY: build-dev up-dev down-dev
build-dev:
	docker-compose -f docker-compose-dev.yml build
up-dev:
	docker-compose -f docker-compose-dev.yml up
down-dev:
	docker-compose -f docker-compose-dev.yml down

######################### DEVELOPMENT HELPERS #########################

# Get an interactive shell in one of the running Docker containers.
#   make shell <docker-name>
#   e.g. "make shell task-api"
.PHONY: shell
shell:
	docker exec -it $(CMDARGS) /bin/sh

# Execute a shell command in one of the running Docker containers.
#   make exec <docker-name> <command>
#   e.g. "make exec task-api npm version"
.PHONY: exec
exec:
	docker exec -t $(CMDARGS)

# If the first target is "exec" or "shell", store the remaining list of targets 
# in CMDARGS and prevent their execution (treat as arguments instead).
CMD := $(firstword $(MAKECMDGOALS))
ifeq ($(CMD),$(filter $(CMD),exec shell))
  CMDARGS := $(filter-out exec shell, $(MAKECMDGOALS))
  $(eval $(CMDARGS):;@:)
endif

######################### KUBERNETES #########################
# These targets currently use a bash script, TODO write a PowerShell version for Windows.

# "make login" - Secure copy secrets from bastion and configures kubectl and docker.
.PHONY: login
login:
	./k8s/kube.sh login

# "make logout" - Forget all secrets and unconfigure kubectl and docker.
.PHONY: logout
logout:
	./k8s/kube.sh logout

# "make publish" - Publish all docker images to Docker Hub.
.PHONY: publish
publish:
	./k8s/kube.sh publish

# "make deploy" - Deploy all services to the Kubernetes cluster.
.PHONY: deploy
deploy:
	./k8s/kube.sh deploy

# "make destroy" - Delete all services from the Kubernetes cluster.
.PHONY: destroy
destroy:
	./k8s/kube.sh destroy

# "make dashboard" - Open the Kubernetes dashboard.
.PHONY: dashboard
dashboard:
	./k8s/kube.sh dashboard