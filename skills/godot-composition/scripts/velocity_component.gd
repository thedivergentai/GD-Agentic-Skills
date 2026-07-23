# velocity_component.gd
# Encapsulating movement logic for reuse across entities
class_name VelocityComponent extends Node

# EXPERT NOTE: Use a velocity component to share movement code 
# between Player and Enemies without deep inheritance.

@export var max_speed: float = 300.0
@export var acceleration: float = 1000.0

var velocity: Vector2 = Vector2.ZERO

func accelerate_in_direction(direction: Vector2, delta: float) -> void:
	var target_velocity = direction * max_speed
	velocity = velocity.move_toward(target_velocity, acceleration * delta)

func apply_velocity(character: CharacterBody2D) -> void:
	character.velocity = velocity
	character.move_and_slide()
	# Update local velocity based on actual movement (e.g., collisions)
	velocity = character.velocity
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/node_alternatives.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — apply_velocity calls move_and_slide on injected body
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — orchestrator passes Input direction into accelerate_in_direction
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
