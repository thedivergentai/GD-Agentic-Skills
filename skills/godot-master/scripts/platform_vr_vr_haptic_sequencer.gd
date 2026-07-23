class_name VRHapticSequencer
extends Node

## Expert haptic sequencer for VR controllers.
## Uses trigger_haptic_pulse to create distinct tactile patterns (Success, Impact).

func play_haptic_vibration(controller: XRController3D, amplitude: float = 0.5, duration: float = 0.1) -> void:
	if controller:
		# frequency, amplitude, duration, delay
		controller.trigger_haptic_pulse("haptic", 100.0, amplitude, duration, 0.0)

func play_triple_echo(controller: XRController3D) -> void:
	for i in range(3):
		play_haptic_vibration(controller, 0.2 + (i * 0.1), 0.05)
		await get_tree().create_timer(0.1).timeout

## Rule: Always use the 'haptic' action name defined in OpenXR settings.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_xrcontroller3d.html
# - https://docs.godotengine.org/en/stable/tutorials/xr/xr_action_map.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — haptic action names from the Action Map
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — pair tactile pulses with UI/event SFX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
