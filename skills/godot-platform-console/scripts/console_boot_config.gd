class_name ConsoleBootConfig
extends Node

## Expert hardware-aware boot configuration.
## Disables expensive PC-only rendering features on initialization.

func _ready() -> void:
	if OS.has_feature("mobile") or OS.has_feature("switch"):
		_optimize_for_low_end()
	
	# TRC Requirement: Always enable VSync for consoles
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _optimize_for_low_end() -> void:
	# Disable real-time global illumination for performance
	RenderingServer.gi_set_use_half_resolution(true)
	# Lock FPS to prevent heating
	Engine.max_fps = 30

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/pipeline_compilations.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — feature tags that select boot profiles
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — max_fps / VSync / GI half-res tradeoffs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
