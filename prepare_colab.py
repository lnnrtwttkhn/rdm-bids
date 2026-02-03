import tomllib
import re

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

print("Generated pip_install_command.md")

# Process exercise1.qmd - convert bash chunks to python with jupyter magics
with open("exercise1.qmd", "r") as f:
    content = f.read()

# Update the YAML header to specify python kernel
content = re.sub(r'jupyter: bash', 'jupyter: python3', content)

# Replace bash code chunks with python chunks and add ! magic
def replace_bash_chunk(match):
    # Extract the command content
    command_content = match.group(1)
    # Add ! magic to each line that isn't empty
    lines = command_content.split('\n')
    python_lines = []
    for line in lines:
        if line.strip():  # If line is not empty
            python_lines.append(f"!{line}")
        else:
            python_lines.append(line)

    return f"```{{python}}\n{chr(10).join(python_lines)}\n```"

# Find and replace all bash chunks
content = re.sub(r'```\{bash\}\n(.*?)\n```', replace_bash_chunk, content, flags=re.DOTALL)

# Write the modified content to a new file
with open("exercise1_colab.qmd", "w") as f:
    f.write(content)

print("Generated exercise1_colab.qmd with bash chunks converted to python with jupyter magics")