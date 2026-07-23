# move_and_collide_precision.gd
# Using move_and_collide for custom bounce and friction logic
extends CharacterBody2D

# EXPERT NOTE: move_and_slide is for PLATFORMERS. 
# Use move_and_collide for BILLIARDS, PINBALL, or high-speed projectiles 
# where you need the exact KinematicCollision2D object.

@export var bounce_factor: float = 0.8

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Bounce velocity off the normal
		velocity = velocity.bounce(collision.get_normal()) * bounce_factor
		
		# Slide slightly along the surface for 'greasy' feel
		velocity += collision.get_remainder().slide(collision.get_normal())

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_kinematiccollision2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — move_and_slide vs move_and_collide choice
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md — precision bounce/friction puzzles
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
