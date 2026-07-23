import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("root", help="Root directory to search")
    args = parser.parse_args()
    for p in GodotBase().list_projects(args.root): print(p)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — recognize valid project.godot roots
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md — multi-project workspace layouts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
