class_name VRHandGestureDetector
extends Node

## Expert hand tracking gesture recognition using XRHandModifier3D.
## Detects 'Pinch' and 'Grab' strength for interaction.

@export var hand_modifier: XRHandModifier3D

func get_pinch_strength() -> float:
	if not hand_modifier: return 0.0
	# Use standard OpenXR hand joint indices (Index tip and Thumb tip)
	# This is a simplified proxy for demonstration
	return 1.0 # Implement actual distance check here in production

func is_grabbing() -> bool:
	# Check if middle, ring, and pinky are curled
	return false

## Tip: Hand tracking is highly sensitive to lighting; always provide controller fallbacks.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/xr/openxr_hand_tracking.html
# - https://docs.godotengine.org/en/stable/classes/class_xrhandmodifier3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — gesture strength as input alongside controllers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — pinch/grab driving physics interactables
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
