# looped_hover_vfx.gd
# Infinite ping-pong animations with set_loops()
extends Sprite2D

# EXPERT NOTE: Tweens can replace AnimationPlayer for simple 
# ambient effects like floating or glowing.

func _ready() -> void:
	var tween = create_tween().set_loops() # Infinite
	
	tween.tween_property(self, "position:y", 10, 2.0)\
		.as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", -10, 2.0)\
		.as_relative().set_trans(Tween.TRANS_SINE)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_propertytweener.html
# - https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — ambient loops without AnimationPlayer overhead
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — when particles replace ping-pong position juice
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
