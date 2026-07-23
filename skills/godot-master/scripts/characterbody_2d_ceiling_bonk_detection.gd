# ceiling_bonk_detection.gd
# Preventing 'sticky head' syndrome when hitting ceilings
extends CharacterBody2D

func _physics_process(delta: float) -> void:
	if is_on_ceiling() and velocity.y < 0:
		# Kill vertical momentum immediately to prevent 
		# hanging in the air against a ceiling.
		velocity.y = 0
	
	move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_kinematiccollision2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — ceiling contacts and shape sizing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — sticky-head collision debug
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md
# =============================================================================
