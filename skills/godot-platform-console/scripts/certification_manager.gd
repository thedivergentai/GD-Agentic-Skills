class_name ConsoleCertificationManager
extends Node

## Expert handler for TRC/TCR certification compliance.
## Automatically manages focus transitions and controller disconnections.

signal focus_lost
signal focus_gained
signal controller_disconnected(device_id: int)

func _ready() -> void:
	# TCR: Monitor joypad connectivity changes during runtime
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			# TRC: System menu opened (Overlay). Must pause immediately.
			_enforce_system_pause()
			focus_lost.emit()
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focus_gained.emit()

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if not connected:
		# TRC: Controller disconnect must trigger a pause/overlay
		_enforce_system_pause()
		controller_disconnected.emit(device)

func _enforce_system_pause() -> void:
	if not get_tree().paused:
		get_tree().paused = true
		print("Console: Forced system pause due to focus loss or disconnect.")

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controller_features.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — joy_connection_changed and pause UX
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — save indicators during forced pauses
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
