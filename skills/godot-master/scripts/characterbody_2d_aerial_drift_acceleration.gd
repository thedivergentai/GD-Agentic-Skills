# aerial_drift_acceleration.gd
# Precise air control logic for feel-focused platformers
extends CharacterBody2D

@export var air_acceleration := 500.0
@export var max_air_speed := 300.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var dir = Input.get_axis("left", "right")
		# Only accelerate if we aren't at max air speed
		if abs(velocity.x) < max_air_speed or sign(dir) != sign(velocity.x):
			velocity.x += dir * air_acceleration * delta
	
	move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — air control feel tuning
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — move_toward acceleration units
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
