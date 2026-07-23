import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to project")
    parser.add_argument("gltf", help="GLTF/GLB path")
    parser.add_argument("out", help="Output .tscn path")
    args = parser.parse_args()
    
    gb = GodotBase()
    code = f"""extends SceneTree
func _init():
    var doc = GLTFDocument.new()
    var state = GLTFState.new()
    var err = doc.append_from_file("{args.gltf}", state)
    if err == OK:
        var root = doc.generate_scene(state)
        var packed = PackedScene.new()
        packed.pack(root)
        ResourceSaver.save(packed, "{args.out}")
        print("Converted glTF to tscn")
    quit()"""
    script = gb.write_worker(args.project, code)
    res = gb.run(["-s", gb.normalize(script)], project=args.project)
    print(res.stdout); print(res.stderr)
    os.remove(script)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
# - https://docs.godotengine.org/en/stable/classes/class_gltfdocument.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — place converted scenes into levels
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — material import expectations on glTF
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — follow with collision_generator
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
