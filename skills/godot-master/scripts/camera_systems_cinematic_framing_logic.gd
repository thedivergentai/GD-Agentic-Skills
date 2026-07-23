# cinematic_framing_logic.gd
# Implementing Rule of Thirds and Lead Room in code [31]
extends Camera2D

@export var target: Node2D
@export var look_ahead_factor: float = 0.2
@export var vertical_offset_ratio: float = -0.1 # Move up for Rule of Thirds

func _process(delta: float) -> void:
	if not target: return
	
	# Rule of Thirds: Offset the target slightly above center
	var v_offset = get_viewport_rect().size.y * vertical_offset_ratio
	
	# Lead Room: Shift camera in direction of target velocity
	var velocity = Vector2.ZERO
	if "velocity" in target:
		velocity = target.velocity
	
	var lead_offset = velocity * look_ahead_factor
	
	var goal_pos = target.global_position + lead_offset + Vector2(0, v_offset)
	
	# Smoothly interpolate to the framed goal
	global_position = global_position.lerp(goal_pos, 5.0 * delta)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_camera2d.html
# - https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
# - https://docs.godotengine.org/en/stable/classes/class_pathfollow2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — lead room from target.velocity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — cutscene framing blends
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — framing fairness when multiple actors share a view
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# =============================================================================
