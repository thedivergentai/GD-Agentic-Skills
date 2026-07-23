import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to project")
    parser.add_argument("mesh", help="Mesh resource path")
    parser.add_argument("out", help="Output .tscn path")
    args = parser.parse_args()
    
    gb = GodotBase()
    code = f"""extends SceneTree
func _init():
    var m = load("{args.mesh}")
    if m is Mesh:
        var body = StaticBody3D.new()
        var collision = CollisionShape3D.new()
        collision.shape = m.create_trimesh_shape()
        body.add_child(collision)
        var packed = PackedScene.new()
        packed.pack(body)
        ResourceSaver.save(packed, "{args.out}")
    quit()"""
    script = gb.write_worker(args.project, code)
    res = gb.run(["-s", gb.normalize(script)], project=args.project)
    print(res.stdout); print(res.stderr)
    os.remove(script)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_concavepolygonshape3d.html
# - https://docs.godotengine.org/en/stable/classes/class_mesh.html
# - https://docs.godotengine.org/en/stable/classes/class_staticbody3d.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — trimesh vs convex tradeoffs and layers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — attach generated bodies to level scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
