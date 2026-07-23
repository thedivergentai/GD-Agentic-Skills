# Character Rotation via DirectSpaceState2D
extends Node2D

## Using an Area2D for simple ground detection? Overkill.
## Use a PhysicsDirectSpaceState2D query for a more lightweight, code-driven approach.

func is_grounded() -> bool:
    var space_state = get_world_2d().direct_space_state
    
    # Cast a small segment below the player
    var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2.DOWN * 5.0)
    query.exclude = [get_parent().get_rid()] # Exclude self
    
    var result = space_state.intersect_ray(query)
    return !result.is_empty()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — lightweight ground/LOS queries
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — grounding without extra Area2D nodes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
