import json
import os
import re

def process_content(content):
    # Replace parentheses in text while preserving math expressions
    # First, temporarily replace math expressions
    math_pattern = r'\$\$(.*?)\$\$'
    math_expressions = []
    
    def save_math(match):
        math_expressions.append(match.group(0))
        return f"__MATH_{len(math_expressions)-1}__"
    
    # Save math expressions
    content = re.sub(math_pattern, save_math, content)
    
    # Remove parentheses from text
    content = content.replace('(', '').replace(')', '')
    
    # Restore math expressions
    for i, expr in enumerate(math_expressions):
        content = content.replace(f"__MATH_{i}__", expr)
    
    return content

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if 'markdownContent' in data:
        data['markdownContent'] = process_content(data['markdownContent'])
    
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def main():
    directory = os.path.dirname(os.path.abspath(__file__))
    for filename in os.listdir(directory):
        if filename.endswith('_content.json'):
            file_path = os.path.join(directory, filename)
            print(f"Processing {filename}...")
            process_file(file_path)
            print(f"Finished processing {filename}")

if __name__ == "__main__":
    main() 