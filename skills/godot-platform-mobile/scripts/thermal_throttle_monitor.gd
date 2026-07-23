class_name ThermalThrottleMonitor
extends Node

## Expert thermal and battery manager for Mobile.
## Throttles logic/rendering when app is backgrounded or device is hot.

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED:
			# Drop FPS to minimal to save battery and reduce heat
			Engine.max_fps = 1
			AudioServer.set_bus_mute(0, true)
		NOTIFICATION_APPLICATION_RESUMED:
			# Restore performance
			Engine.max_fps = 60
			AudioServer.set_bus_mute(0, false)

func apply_thermal_throttle(is_hot: bool) -> void:
	# Expert: Dynamic FPS scaling based on device temperature signal
	Engine.max_fps = 30 if is_hot else 60
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — battery saver pairing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — mute master bus while backgrounded
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — PROCESS_MODE_ALWAYS thermal Autoload
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md
# =============================================================================
