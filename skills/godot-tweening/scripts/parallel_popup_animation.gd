# parallel_popup_animation.gd
# Simultaneous property animations with set_parallel()
extends Control

# EXPERT NOTE: Use set_parallel(true) for UI popups to move, fade, 
# and scale all at once, then chain() for sequential cleanup.

func show_popup():
	pivot_offset = size / 2
	scale = Vector2.ZERO
	modulate.a = 0
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	# Transition back to sequential mode to run a callback at the end
	tween.chain().tween_callback(_on_show_complete)

func _on_show_complete():
	print("Popup fully visible")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_callbacktweener.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — pivot_offset and layout before scale popups
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — theme-aligned popup motion
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
