# Research Data Management with BIDS

Educational materials and exercises for learning about Brain Imaging Data Structure (BIDS) and research data management best practices.

## Setup

This project uses [uv](https://github.com/astral-sh/uv) for Python dependency management.

### Installation

1. Clone the repository
2. Install dependencies:

   ```bash
   uv sync --extra dev
   ```

3. Install pre-commit hooks:

   ```bash
   uv run pre-commit install
   ```

## Development

- Use `uv run` to execute commands in the project environment
- Pre-commit hooks automatically check for trailing whitespace and other issues
- Build documentation with Quarto: `quarto render`

## Contents

- `rdm-bids.qmd` - Main documentation about BIDS
- `references.qmd` - Reference materials
- `.pre-commit-config.yaml` - Code quality hooks
