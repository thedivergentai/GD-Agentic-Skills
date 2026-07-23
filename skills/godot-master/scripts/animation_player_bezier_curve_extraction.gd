# bezier_curve_extraction.gd
# Extracting Bezier track data for custom physics/logic [115]
extends Node

func get_bezier_at_runtime(anim: Animation, track_path: String, time: float) -> float:
	var track_idx = anim.find_track(track_path, Animation.TYPE_BEZIER)
	if track_idx == -1: return 0.0
	
	# Expert: bezier_track_interpolate returns the exact value at 'time'
	# accounting for handle lengths and angles.
	return anim.bezier_track_interpolate(track_idx, time)

# Example: Use Bezier to drive a custom particle emission rate
func _process(delta: float) -> void:
	if $AnimationPlayer.is_playing():
		var anim = $AnimationPlayer.get_animation($AnimationPlayer.current_animation)
		var t = $AnimationPlayer.current_animation_position
		var rate = get_bezier_at_runtime(anim, ".:emission_rate", t)
		$GPUParticles3D.amount_ratio = clamp(rate, 0.0, 1.0)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html
# - https://docs.godotengine.org/en/stable/classes/class_animation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — drive emission rate from bezier samples
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — when a Tween curve is enough vs baked bezier
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md
# =============================================================================
