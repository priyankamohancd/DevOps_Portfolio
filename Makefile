# Makefile - convenience shortcuts for the lab.
# Students run: make build, make test, make deploy, etc.

IMAGE_NAME := cicd-demo
IMAGE_TAG  := latest

.PHONY: help install test lint build run stop logs deploy clean pipeline

help:
	@echo "Targets:"
	@echo "  install   - install Python deps locally"
	@echo "  lint      - run flake8 on the app"
	@echo "  test      - run pytest"
	@echo "  build     - build the Docker image"
	@echo "  run       - run the container in the foreground"
	@echo "  deploy    - run via docker-compose (detached)"
	@echo "  stop      - stop the docker-compose stack"
	@echo "  logs      - tail container logs"
	@echo "  clean     - remove the image and container"
	@echo "  pipeline  - run the full local pipeline (lint -> test -> build -> deploy)"

install:
	pip install -r app/requirements.txt
	pip install flake8

lint:
	flake8 app/ --max-line-length=100 --exclude=__pycache__

test:
	cd app && pytest -v

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run:
	docker run --rm -p 5000:5000 $(IMAGE_NAME):$(IMAGE_TAG)

deploy:
	docker compose up -d --build
	@sleep 3
	@echo "Deployed. Try: curl http://localhost:5000/"

stop:
	docker compose down

logs:
	docker compose logs -f

clean:
	-docker compose down
	-docker rmi $(IMAGE_NAME):$(IMAGE_TAG)

# Run the entire pipeline locally - this is what the CI server does.
pipeline: lint test build deploy
	@echo ""
	@echo "Pipeline complete! App is live at http://localhost:5000"
