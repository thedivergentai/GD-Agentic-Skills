# player_haptic_feedback.gd
extends Node
class_name PlayerHapticFeedback

# Localized Haptic Feedback
# Triggers rumble strictly on the controller of the player who was hit.

func trigger_vibration(device_id: int, weak: float, strong: float, duration: float) -> void:
    # Pattern: Finite duration is mandatory to prevent infinite rumble on pause.
    if device_id != -1:
        Input.start_joy_vibration(device_id, weak, strong, duration)

func _on_eliminated(device_id: int) -> void:
    trigger_vibration(device_id, 1.0, 1.0, 0.5)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controller_features.html
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — per-device vibration duration
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — pair rumble with hit SFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
