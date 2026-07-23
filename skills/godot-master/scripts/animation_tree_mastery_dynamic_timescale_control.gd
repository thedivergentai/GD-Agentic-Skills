# dynamic_timescale_control.gd
# Expert control of playback speed via AnimationNodeTimeScale
extends AnimationTree

# TimeScale nodes allow independent speed control for specific sub-trees
# (e.g., slowing down feet while keeping upper body fast).

func apply_movement_haste(multiplier: float) -> void:
	# multiplier = 1.0 (Normal), 2.0 (Double Speed), 0.5 (Slow Mo)
	set("parameters/MovementTime/scale", multiplier)

func bullet_time_transition(target_scale: float, duration: float) -> void:
	var tween = create_tween()
	# Tweens can target AnimationTree parameters directly!
	tween.tween_property(self, "parameters/GlobalTime/scale", target_scale, duration)\
		.set_trans(Tween.TRANS_SINE)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_animationnodetimescale.html
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — interruptible scale ramps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — stun / haste presentation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md
# =============================================================================
