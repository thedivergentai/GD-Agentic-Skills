import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse, json

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to Godot project")
    args = parser.parse_args()
    print(json.dumps(GodotBase().get_project_info(args.project)))

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — parse display/features from project.godot
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — feature list informs export presets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
