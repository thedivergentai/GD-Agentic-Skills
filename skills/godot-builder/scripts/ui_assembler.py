import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to project")
    parser.add_argument("json", help="JSON layout string")
    parser.add_argument("out", help="Output .tscn path")
    args = parser.parse_args()
    
    gb = GodotBase()
    code = f"""extends SceneTree\nfunc _init():\n  var root = Control.new()\n  var packed = PackedScene.new()\n  packed.pack(root)\n  ResourceSaver.save(packed, "{args.out}")\n  quit()"""
    script = gb.write_worker(args.project, code)
    res = gb.run(["-s", gb.normalize(script)], project=args.project)
    print(res.stdout); print(res.stderr)
    os.remove(script)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — emit Containers not absolute Control coords
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — theme inheritance on assembled UI trees
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
