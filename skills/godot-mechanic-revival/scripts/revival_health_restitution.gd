class_name RevivalHealthRestitution
extends Node

## Expert Health Restitution Logic.
## Handles 'Revive' item effects with temporary invincibility.

@export var i_frame_duration: float = 2.0

func apply_revive(target: Node) -> void:
	if target.has_method("set_invincible"):
		target.set_invincible(true)
		
		# Visual Feedback: Pulsing opacity
		var tween = target.create_tween().set_loops(4)
		tween.tween_property(target, "modulate:a", 0.2, 0.25)
		tween.tween_property(target, "modulate:a", 1.0, 0.25)
		
		await target.get_tree().create_timer(i_frame_duration).timeout
		target.set_invincible(false)

## Rule: Invincibility frames (I-frames) are mandatory after revival to prevent 'Death Loops'.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html — I-frame modulate pulse loops
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html — i_frame_duration timeout
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — set_invincible / health restore through stats
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — interruptible revive VFX tweens
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — prove I-frame TTK impact
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
