# fog_visibility_check.gd
extends Node2D
class_name FogVisibilityCheck

# Fast Physics-Server Raycasting for Fog of War
# Nodeless raycasting for instant, high-performance line-of-sight checks.

func can_see_target(target: Node2D) -> bool:
    if not is_instance_valid(target): return false
    
    var space_state := get_world_2d().direct_space_state
    
    # Create query from observer to target.
    var query := PhysicsRayQueryParameters2D.create(global_position, target.global_position)
    
    # EXTREMELY IMPORTANT: Exclude self and allies to prevent self-blocking vision.
    if get_parent() is CollisionObject2D:
        query.exclude = [get_parent().get_rid()]
    
    var result := space_state.intersect_ray(query)
    
    # Visible if the ray hit nothing (clear path) or hit the target directly.
    return result.is_empty() or result.collider == target
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — nodeless LOS query recipes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md — fog vision patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
