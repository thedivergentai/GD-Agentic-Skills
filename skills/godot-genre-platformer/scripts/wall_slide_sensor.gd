# wall_slide_sensor.gd
extends Node2D
class_name WallSlideSensor

# Wall Sliding via Nodeless Physics Raycast
# Direct query using PhysicsServer2D for zero-latency detection without nodes.

@export var body: CharacterBody2D

func check_wall(look_direction: float) -> bool:
    var space_state := get_world_2d().direct_space_state
    
    # Cast ray slightly outside the collision shape.
    var ray_end := global_position + Vector2(look_direction * 15.0, 0)
    var query := PhysicsRayQueryParameters2D.create(global_position, ray_end)
    query.exclude = [body.get_rid()]
    
    var result := space_state.intersect_ray(query)
    return not result.is_empty()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — nodeless wall ray queries
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — wall slide / wall jump from normals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
