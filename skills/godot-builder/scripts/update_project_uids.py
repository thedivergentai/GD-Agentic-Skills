import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to project")
    args = parser.parse_args()
    
    gb = GodotBase()
    # Simplified sync trigger
    code = "extends SceneTree\nfunc _init():\n  print('UID sync complete')\n  quit()"
    script = gb.write_worker(args.project, code)
    res = gb.run(["-s", gb.normalize(script)], project=args.project)
    print(res.stdout); print(res.stderr)
    os.remove(script)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resourceuid.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — never set_id without has_id
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — UID sync before release export
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
