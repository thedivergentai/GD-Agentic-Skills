extends CharacterBody2D
class_name OneWayDropHandler

## Expert One-Way Drop Logic (Godot 4.7).
## Down + Jump intentionally drops through platforms.

const PLATFORM_LAYER = 4 # Example layer for one-way platforms

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("jump"):
		_drop_through()

func _drop_through() -> void:
	# Temporarily disable the collision mask for the platform layer
	set_collision_mask_value(PLATFORM_LAYER, false)
	
	# Restore after a short delay
	await get_tree().create_timer(0.2).timeout
	set_collision_mask_value(PLATFORM_LAYER, true)

## [SKILL NOTICE]: Use 'set_collision_mask_value()' to temporarily ignore 
## one-way platform layers. Use 'await' for precise, non-blocking timing.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilesets.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — one-way platform layers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — down+jump drop-through chord
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
