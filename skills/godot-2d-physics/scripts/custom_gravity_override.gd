# Custom Physics Body Gravity Override
extends CharacterBody2D

## Pattern for localized gravity overrides (Space, Water, Wind).
## Bypasses global physics settings for specialized character movement.

@export var local_gravity := Vector2(0, 400)
@export var drag_factor := 0.95

func _physics_process(delta: float) -> void:
	# Ignore default project settings gravity
	velocity += local_gravity * delta
	
	# Apply fluid drag/friction
	velocity *= pow(drag_factor, delta * 60.0)
	
	move_and_slide()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — local gravity with move_and_slide
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — fluid/anti-grav feel tuning
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
