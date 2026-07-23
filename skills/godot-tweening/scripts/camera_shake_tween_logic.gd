# camera_shake_tween_logic.gd
# Procedural screen shake using randomized tweens
extends Camera2D

func apply_shake(intensity: float, duration: float):
	var tween = create_tween().set_loops(5) # Shake 5 times
	
	var offset_v = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * intensity
	tween.tween_property(self, "offset", offset_v, duration / 10.0)
	tween.tween_property(self, "offset", Vector2.ZERO, duration / 10.0)
	
	# Ensure the camera returns to 0,0 at the very end
	tween.finished.connect(func(): offset = Vector2.ZERO)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_camera2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — shake vs follow ownership on Camera2D
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — finished reset of offset
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
