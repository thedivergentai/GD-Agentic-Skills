class_name MobileSensorFusion
extends Node

## Expert usage of mobile hardware sensors for motion controls.
## Fuses Accelerometer and Gravity for stable gameplay input.

func get_tilt_input() -> Vector3:
	var accel := Input.get_accelerometer()
	var gravity := Input.get_gravity()
	
	# Compute stable tilt by subtracting gravity from raw accelerometer
	var tilt := accel - gravity
	return tilt.normalized()

func get_device_rotation() -> Vector3:
	return Input.get_gyroscope()

## Rule: Always normalize sensor data to account for varying hardware sensitivity.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — normalize / deadzone sensor axes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — tilt controls beside touch HUD
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md
# =============================================================================
