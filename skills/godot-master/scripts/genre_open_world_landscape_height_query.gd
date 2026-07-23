# landscape_height_query.gd
extends Node3D
class_name LandscapeHeightQuery

# Grid-Based Raycast Floor Query
# Uses PhysicsDirectSpaceState for high-performance height checks for object placement.

func get_height_at(pos_x: float, pos_z: float) -> float:
    var space_state := get_world_3d().direct_space_state
    
    # Query from skyward downwards.
    var ray_start := Vector3(pos_x, 5000.0, pos_z)
    var ray_end := Vector3(pos_x, -1000.0, pos_z)
    
    var query := PhysicsRayQueryParameters3D.create(ray_start, ray_end)
    var result := space_state.intersect_ray(query)
    
    if not result.is_empty():
        return result.position.y
    return 0.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — nodeless height sampling for prop placement
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — stamp props onto streamed terrain heights
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md
# =============================================================================
