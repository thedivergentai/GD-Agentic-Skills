# networked_interpolator.gd
# Smoothing remote entity movement
extends CharacterBody2D

# EXPERT NOTE: Use lerp to smooth the transition between 
# received network packets to avoid jitter.

var target_position: Vector2

func _physics_process(delta):
	if not is_multiplayer_authority():
		# Smoothly move remote proxy towards verified position
		global_position = global_position.lerp(target_position, 0.4)
	else:
		# Local authority logic
		target_position = global_position
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — remote puppet motion smoothing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — optional tween blends vs per-frame lerp
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
