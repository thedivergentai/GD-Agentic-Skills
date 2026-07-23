import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to project")
    parser.add_argument("res", help="Scene resource path")
    parser.add_argument("type", help="Node type to add")
    parser.add_argument("name", help="Node name")
    args = parser.parse_args()
    
    gb = GodotBase()
    code = f"extends SceneTree\nfunc _init():\n  var s = load('{args.res}')\n  if s:\n    var r = s.instantiate()\n    var n = {args.type}.new()\n    n.name = '{args.name}'\n    r.add_child(n)\n    n.owner = r\n    var p = PackedScene.new()\n    p.pack(r)\n    ResourceSaver.save(p, '{args.res}')\n  quit()"
    script = gb.write_worker(args.project, code)
    res = gb.run(["-s", gb.normalize(script)], project=args.project)
    print(res.stdout); print(res.stderr)
    os.remove(script)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — set owner or nodes vanish on save
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — prefer composition over deep hardcoded trees
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
