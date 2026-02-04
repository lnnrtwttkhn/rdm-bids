# Use official Python runtime as base image
FROM python:3.13-slim

# Build arguments for flexible configuration
ARG QUARTO_VERSION=1.8.27

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tree \
    git \
    build-essential \
    ca-certificates \
    gdebi-core \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install uv using the official method
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install Quarto
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        QUARTO_ARCH="linux-amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        QUARTO_ARCH="linux-arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-${QUARTO_ARCH}.deb && \
    gdebi -n quarto-${QUARTO_VERSION}-${QUARTO_ARCH}.deb && \
    rm quarto-${QUARTO_VERSION}-${QUARTO_ARCH}.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency files and install Python dependencies
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

# Install and register bash kernel for Jupyter
RUN uv run python -m bash_kernel.install

# Add quarto extension
RUN quarto add mcanouil/quarto-collapse-output

# Set environment variables
ENV QUARTO_PYTHON="/app/.venv/bin/python"
ENV PATH="/app/.venv/bin:$PATH"