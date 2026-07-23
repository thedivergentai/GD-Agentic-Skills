# ledge_grab_sensor.gd
extends Node2D
class_name LedgeGrabSensor

# Ledge Grabbing using ShapeCast2D logic
# Performs a nodeless shape query to detect precise ledge geometry.

@export var body: CharacterBody2D

func check_ledge() -> bool:
    var space_state := get_world_2d().direct_space_state
    
    # Create an on-demand circle shape for detection.
    var shape := CircleShape2D.new()
    shape.radius = 4.0
    
    var query := PhysicsShapeQueryParameters2D.new()
    query.shape = shape
    query.transform = global_transform
    query.exclude = [body.get_rid()]
    
    var hits := space_state.intersect_shape(query)
    return not hits.is_empty()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — shape queries for ledge volumes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — climb/grab after air control
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
