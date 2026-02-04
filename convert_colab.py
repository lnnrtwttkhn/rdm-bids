import re

def replace_bash_chunk(match):
    """Convert bash chunk to python with jupyter magics."""
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

def process_exercise_file(input_file, output_file):
    """Process exercise file to convert bash chunks to python with jupyter magics."""
    with open(input_file, "r") as f:
        content = f.read()

    # Update the YAML header to specify python kernel
    content = re.sub(r'jupyter: bash', 'jupyter: python3', content)

    # Find and replace all bash chunks
    content = re.sub(r'```\{bash\}\n(.*?)\n```', replace_bash_chunk, content, flags=re.DOTALL)

    # Write the modified content to a new file
    with open(output_file, "w") as f:
        f.write(content)

    print(f"Generated {output_file} with bash chunks converted to python with jupyter magics")

def convert_all_exercises():
    """Convert all exercise files for Colab compatibility."""
    # Process both exercise files
    process_exercise_file("exercise1.qmd", "exercise1_colab.qmd")
    process_exercise_file("exercise2.qmd", "exercise2_colab.qmd")

if __name__ == "__main__":
    convert_all_exercises()