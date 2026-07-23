# variable_jump_height.gd
# Implementing 'Short Hop' vs 'Full Jump' logic
extends CharacterBody2D

@export var jump_velocity := -400.0
@export var min_jump_velocity := -200.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		# If player releases jump mid-air, cut vertical velocity
		if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — release-to-cut jump height
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — short-hop vs full-jump balance
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
