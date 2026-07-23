# custom_gravity_area.gd
# Implementing custom gravity wells and directional zones
extends Area2D

# Expert: Using Area2D 'Priority' and 'Gravity' overrides.

func _ready() -> void:
	# High priority ensures this gravity overrides the global world gravity
	gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
	gravity_point = true
	gravity_point_unit_distance = 100.0
	gravity = 980.0 # Attraction force
	
	# For directional gravity (e.g. anti-gravity lift)
	# gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
	# gravity_direction = Vector2.UP

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — characters reacting to gravity overrides
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — water/space gravity zones in levels
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
