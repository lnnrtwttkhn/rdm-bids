# Variables
IMAGE_NAME = lnnrtwttkhn/rdm-bids
CONTAINER_NAME = rdm-bids-container
CURRENT_DIR = $(shell pwd)

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  build       - Build the Docker image"
	@echo "  run         - Run container interactively"
	@echo "  shell       - Start bash shell in container"
	@echo "  render      - Render Quarto document"
	@echo "  jupyter     - Start Jupyter server"
	@echo "  clean       - Remove container and image"
	@echo "  push        - Push image to registry"
	@echo "  pull        - Pull latest image"

# Build the Docker image
.PHONY: build
build:
	docker build --platform=linux/arm64 -t $(IMAGE_NAME):latest .

# Build with specific Quarto version
.PHONY: build-quarto
build-quarto:
	@read -p "Enter Quarto version (default: 1.8.27): " version; \
	version=$${version:-1.8.27}; \
	docker build --build-arg QUARTO_VERSION=$$version --platform=linux/arm64 -t $(IMAGE_NAME):latest .

# Run container interactively
.PHONY: run
run:
	docker run -it --rm \
		--name $(CONTAINER_NAME) \
		-v $(CURRENT_DIR):/workspace \
		-w /workspace \
		$(IMAGE_NAME):latest

# Start bash shell
.PHONY: shell
shell:
	docker run -it --rm \
		--name $(CONTAINER_NAME) \
		-v $(CURRENT_DIR):/workspace \
		-w /workspace \
		$(IMAGE_NAME):latest bash

# Render Quarto document
.PHONY: render
render:
	docker run --rm \
		-v $(CURRENT_DIR):/workspace \
		-w /workspace \
		$(IMAGE_NAME):latest \
		uv run quarto render

# Render with specific profile
.PHONY: render-profile
render-profile:
	@read -p "Enter profile name (e.g., ipynb, ci): " profile; \
	docker run --rm \
		-v $(CURRENT_DIR):/workspace \
		-w /workspace \
		$(IMAGE_NAME):latest \
		uv run quarto render --profile $$profile

# Start Jupyter server
.PHONY: jupyter
jupyter:
	@echo "Starting Jupyter Lab on http://localhost:8888"
	docker run --rm \
		--name $(CONTAINER_NAME)-jupyter \
		-p 8888:8888 \
		-v $(CURRENT_DIR):/workspace \
		-w /workspace \
		$(IMAGE_NAME):latest \
		uv run jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# Start Quarto preview server
.PHONY: preview
preview:
	@echo "Starting Quarto preview on http://localhost:4200"
	docker run --rm \
		--name $(CONTAINER_NAME)-preview \
		-p 4200:4200 \
		-v $(CURRENT_DIR):/workspace \
		-w /workspace \
		$(IMAGE_NAME):latest \
		uv run quarto preview --host 0.0.0.0 --port 4200 --no-browser

# Check Quarto and Python versions
.PHONY: versions
versions:
	docker run --rm $(IMAGE_NAME):latest uv run quarto --version
	docker run --rm $(IMAGE_NAME):latest uv run python --version

# Check installed packages
.PHONY: packages
packages:
	docker run --rm $(IMAGE_NAME):latest uv run pip list

# Pull latest image from registry
.PHONY: pull
pull:
	docker pull $(IMAGE_NAME):latest

# Push image to registry
.PHONY: push
push:
	docker push $(IMAGE_NAME):latest

# Clean up containers and images
.PHONY: clean
clean:
	docker container rm -f $(CONTAINER_NAME) 2>/dev/null || true
	docker container rm -f $(CONTAINER_NAME)-jupyter 2>/dev/null || true
	docker container rm -f $(CONTAINER_NAME)-preview 2>/dev/null || true

# Clean up images
.PHONY: clean-images
clean-images: clean
	docker image rm $(IMAGE_NAME):latest 2>/dev/null || true

# Show running containers
.PHONY: ps
ps:
	docker ps --filter name=$(CONTAINER_NAME)

# Show logs from running container
.PHONY: logs
logs:
	docker logs $(CONTAINER_NAME) -f