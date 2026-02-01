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
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    apt-get update && \
    apt-get install -y ./quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    rm quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install Python dependencies using uv
RUN uv sync --frozen

# Install and register bash kernel for Jupyter
RUN uv run pip install bash_kernel && \
    uv run python -m bash_kernel.install

# Set environment variables
ENV QUARTO_PYTHON="/app/.venv/bin/python"
ENV PATH="/app/.venv/bin:$PATH"