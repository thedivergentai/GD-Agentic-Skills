# subpixel_movement_rounding.gd
# Ensuring clean visuals at low resolutions [Pixel Art]
extends CharacterBody2D

# EXPERT NOTE: Physics usually uses floats. Pixel art needs integers.
# Rounding global_position directly causes jitter.
# SOLUTION: Keep physics high-precision, but round the Sprite's position.

func _process(_delta: float) -> void:
	var sprite = $Sprite2D
	# Round to nearest pixel for display only
	sprite.global_position = global_position.round()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — pixel-art visuals vs physics precision
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — sub-pixel jitter diagnosis
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
