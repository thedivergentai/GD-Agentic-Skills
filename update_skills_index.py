import os
import json
import re
import sys
import argparse

# Use relative paths for portability, or absolute if preferred
SKILLS_DIR = os.path.join(os.path.dirname(__file__), "skills")
OUTPUT_FILE = os.path.join(os.path.dirname(__file__), "skills_index.json")

def get_frontmatter(content):
    match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return {}
    
    data = {}
    for line in match.group(1).split('\n'):
        if ':' in line:
            key, val = line.split(':', 1)
            data[key.strip()] = val.strip()
    return data

def get_keywords(description):
    # Try to find "Trigger keywords: ..." or "Keywords ..."
    match = re.search(r'(?:Trigger keywords|Keywords)[:\s]+(.*?)(?:\.|$)', description, re.IGNORECASE)
    if match:
        # Split by comma
        return [k.strip() for k in match.group(1).split(',') if k.strip()]
    
    # Fallback to simple extraction if no explicit keywords found in prose
    desc_words = re.findall(r'\b\w{4,}\b', description.lower())
    return list(set(desc_words))

def update_index():
    print(f"Scanning skills in {SKILLS_DIR}...")
    
    if not os.path.exists(SKILLS_DIR):
        print("Skills directory not found!")
        exit(1)

    skills_list = []
    
    # Iterate through all directories
    for item in sorted(os.listdir(SKILLS_DIR)):
        item_path = os.path.join(SKILLS_DIR, item)
        
        # Filter out hidden folders
        if os.path.isdir(item_path) and not item.startswith("."):
            skill_md_path = os.path.join(item_path, "SKILL.md")
            
            if os.path.exists(skill_md_path):
                try:
                    with open(skill_md_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        
                        fm = get_frontmatter(content)
                        name = fm.get('name', item)
                        description = fm.get('description', '')
                        
                        # Get keywords from description or frontmatter (if someone added it there)
                        keywords = get_keywords(description)


                        skill_data = {
                            "name": name,
                            "description": description,
                            "keywords": keywords
                        }
                        
                        skills_list.append(skill_data)
                        
                except Exception as e:
                    print(f"Error reading {skill_md_path}: {e}")
            else:
                 print(f"Skipping {item} - No SKILL.md found")

    print(f"Found {len(skills_list)} skills.")

    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(skills_list, f, indent=2)
        print(f"Successfully wrote {len(skills_list)} skills to {OUTPUT_FILE}")
    except Exception as e:
        print(f"Error writing output file: {e}")

def validate_index():
    """Warn about descriptions missing trigger keywords or stale Godot version strings."""
    warnings = 0
    if not os.path.exists(OUTPUT_FILE):
        print("skills_index.json not found. Run without --validate first.")
        sys.exit(1)
    with open(OUTPUT_FILE, encoding="utf-8") as f:
        skills = json.load(f)
    for skill in skills:
        name = skill.get("name", "")
        desc = skill.get("description", "")
        keywords = skill.get("keywords", [])
        if not re.search(r"(?:Trigger keywords|Keywords|Use when)", desc, re.I):
            print(f"WARN [{name}]: description lacks trigger keywords / 'Use when'")
            warnings += 1
        if not keywords:
            print(f"WARN [{name}]: no keywords extracted")
            warnings += 1
        if re.search(r"4\.[0-5](?:\+)?", desc) and "4.7" not in desc:
            print(f"WARN [{name}]: description may reference stale Godot version")
            warnings += 1
    print(f"Validation complete: {warnings} warning(s) across {len(skills)} skills.")
    return warnings

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--validate", action="store_true", help="Validate existing skills_index.json")
    args = parser.parse_args()
    if args.validate:
        validate_index()
    else:
        update_index()
