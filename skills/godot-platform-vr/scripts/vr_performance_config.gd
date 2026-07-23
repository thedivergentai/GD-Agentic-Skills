class_name VRPerformanceConfig
extends Node

## Expert VR performance configurations (Foveation, VRS).
## Optimizes frame-time for 90/120Hz targets on standalone headsets.

func _ready() -> void:
	var xr_interface := XRServer.primary_interface
	if xr_interface:
		# Set foveation level (0 = Off, 4 = High)
		if "foveation_level" in xr_interface:
			xr_interface.foveation_level = 3 # High foveation for Quest 2
			xr_interface.foveation_dynamic = true

func set_supersampling(multiplier: float) -> void:
	# Multiplying render target size improves clarity at high GPU cost
	XRServer.primary_interface.render_target_size_multiplier = multiplier

## Rule: 90/120Hz is mandatory for comfort; favor resolution over post-effects.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/xr/openxr_settings.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/variable_rate_shading.html
# - https://docs.godotengine.org/en/stable/classes/class_openxrinterface.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — 90/120 Hz budgets vs supersampling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — thermal/resolution tradeoffs on standalone HMDs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
