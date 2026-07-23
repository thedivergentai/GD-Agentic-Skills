extends CSGShape3D

# Safe CSG Baking
# Because CSG mesh data updates are deferred to the end of the frame, 
# you must wait before extracting the baked meshes to avoid empty data.
func extract_optimized_mesh() -> void:
    # Wait for the engine to finish the deferred CSG boolean calculations
    await get_tree().process_frame
    
    var optimized_mesh: ArrayMesh = bake_static_mesh()
    var collision_shape: ConcavePolygonShape3D = bake_collision_shape()
    
    # You can now assign these to a standard MeshInstance3D and StaticBody3D
    # and safely queue_free() the heavy CSG node hierarchy.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html
# - https://docs.godotengine.org/en/stable/classes/class_csgshape3d.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — await process_frame before reading deferred CSG meshes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — bake_collision_shape handoff to StaticBody3D
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md
# =============================================================================
