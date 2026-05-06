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

### Preview server

Run `make preview` to start a local Quarto preview server.

### Notebook files (`.ipynb`)

The website navbar includes download links for `.ipynb` versions of each exercise (plain and Google Colab variants).
Quarto's HTML render does not produce these files automatically, so `_quarto.yml` configures a `post-render` hook that runs `make ipynb` after every render.
`make ipynb` uses `quarto convert` to convert the `.qmd` source files to `.ipynb`, runs `convert_colab.py` to produce Colab-compatible variants, and copies all four notebooks into `_site/` so the download links resolve correctly.

## Contents

- `rdm-bids.qmd` - Main documentation about BIDS
- `references.qmd` - Reference materials
- `.pre-commit-config.yaml` - Code quality hooks

