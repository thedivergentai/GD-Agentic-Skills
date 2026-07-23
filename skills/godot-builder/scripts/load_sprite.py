import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to project")
    parser.add_argument("res", help="Scene resource path")
    parser.add_argument("name", help="Node name to target")
    parser.add_argument("sprite", help="Sprite resource path (res://...)")
    args = parser.parse_args()
    
    gb = GodotBase()
    code = f"extends SceneTree\nfunc _init():\n  var s = load('{args.res}')\n  if s:\n    var r = s.instantiate()\n    var n = r.find_child('{args.name}', true, false)\n    if n and n is Sprite2D:\n      n.texture = load('{args.sprite}')\n      var p = PackedScene.new()\n      p.pack(r)\n      ResourceSaver.save(p, '{args.res}')\n  quit()"
    script = gb.write_worker(args.project, code)
    res = gb.run(["-s", gb.normalize(script)], project=args.project)
    print(res.stdout); print(res.stderr)
    os.remove(script)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
# - https://docs.godotengine.org/en/stable/classes/class_sprite2d.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — sprite frames after texture assign
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — load via uid:// not hardcoded extensions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
