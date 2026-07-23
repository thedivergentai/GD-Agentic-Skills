# force_feedback_router.gd
extends Node
class_name ForceFeedbackRouter

# Force-Feedback and Rumble Coordination
# Manages controller vibration based on collisions and track surface.

func trigger_impact(intensity: float, duration: float) -> void:
    # Pattern: Use Input.start_joy_vibration for localized haptics.
    var device_id = 0 # Assume first controller
    Input.start_joy_vibration(device_id, intensity * 0.5, intensity, duration)

func shake_on_surface(surface_type: StringName) -> void:
    match surface_type:
        &"grass":
            Input.start_joy_vibration(0, 0.1, 0.1, 0.1)
        &"rough":
            Input.start_joy_vibration(0, 0.3, 0.3, 0.1)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controller_features.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — rumble/haptic device routing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — collision/terrain impulse sources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
