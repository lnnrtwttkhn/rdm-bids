import tomllib

def generate_install_commands():
    """Generate pip install commands from pyproject.toml dependencies."""
    # Read pyproject.toml
    with open("pyproject.toml", "rb") as f:
        data = tomllib.load(f)

    # Extract dependencies and create pip install command
    deps = " ".join(data["project"]["dependencies"])
    pip_command = f"pip install {deps}"

    # Write to markdown file
    markdown_content = f"""```python
!apt-get install tree
{pip_command}
```"""

    with open("_colab_install.md", "w") as f:
        f.write(markdown_content)

    print("Generated _colab_install.md")

if __name__ == "__main__":
    generate_install_commands()