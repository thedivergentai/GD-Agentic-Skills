# impulse_response_handler.gd
# Handling external forces (Knockback, Wind) with move_and_slide
extends CharacterBody2D

var _external_force := Vector2.ZERO

func apply_knockback(dir: Vector2, force: float):
	_external_force = dir.normalized() * force

func _physics_process(delta: float) -> void:
	velocity += _external_force
	# Decay external force over time (friction)
	_external_force = _external_force.lerp(Vector2.ZERO, 0.2)
	
	move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — knockback via CharacterBody velocity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — external forces vs solver bodies
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
