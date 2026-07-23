class_name RuntimeConfigurator
extends Node

## Expert pattern for applying high-performance profiles and saving override.cfg.
## This allows dynamic adjustments to ticks, FPS, and window modes while persisting them.

static func apply_high_performance_profile() -> void:
	# High-tick physics for competitive/sports games
	Engine.max_fps = 144
	Engine.physics_ticks_per_second = 120
	
	# Window settings must be routed through the DisplayServer for immediate effect
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	# Setting persistence via override.cfg [Standard Godot startup override]
	ProjectSettings.set_setting("application/run/max_fps", 144)
	ProjectSettings.set_setting("physics/common/physics_ticks_per_second", 120)
	
	# Only call this in tools or at specific "Apply" moments to avoid I/O blocking
	ProjectSettings.save_custom("user://override.cfg")

static func apply_battery_saver_profile() -> void:
	Engine.max_fps = 30
	Engine.physics_ticks_per_second = 60
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	ProjectSettings.set_setting("application/run/max_fps", 30)
	ProjectSettings.save_custom("user://override.cfg")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — tick/FPS profiles feed deeper tuning
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — override.cfg vs export preset settings
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md
# =============================================================================
