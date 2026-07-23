class_name VRSafetyGuardianWarner
extends Node

## Expert guardian/chaperone proximity warner.
## Uses the XRServer to fetch reference bounds and warns if player is too close.

@export var camera: XRCamera3D

func _process(_delta: float) -> void:
	# Reference frame 2D bounds (square/rectangle area)
	var bounds := XRServer.get_reference_frame_bounds_2d()
	if bounds.size == Vector2.ZERO: return # No boundary set
	
	var cam_pos_2d := Vector2(camera.position.x, camera.position.z)
	if not bounds.has_point(cam_pos_2d):
		_warn_player_out_of_bounds()

func _warn_player_out_of_bounds() -> void:
	# Trigger visual/haptic warning
	pass

## Rule: Respecting real-world physical space is a safety requirement for VR.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/xr/xr_room_scale.html
# - https://docs.godotengine.org/en/stable/classes/class_xrserver.html
# - https://docs.godotengine.org/en/stable/classes/class_xrcamera3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — headset pose vs play-area bounds checks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — warn with spatial SFX near guardian edges
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
