class_name VRHeadsetFocusGuard
extends Node

## Expert handler for VR headset focus events.
## Prevents the game from running while the user is in the system menu.

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			# Headset removed or system overlay (Meta menu) opened
			get_tree().paused = true
			_silence_audio(true)
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			get_tree().paused = false
			_silence_audio(false)

func _silence_audio(muted: bool) -> void:
	AudioServer.set_bus_mute(0, muted)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/xr/a_better_xr_start_script.html
# - https://docs.godotengine.org/en/stable/classes/class_xrinterface.html
# - https://docs.godotengine.org/en/stable/classes/class_audioserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — pause tree on focus loss / system menu
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — mute master bus while headset is off
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
