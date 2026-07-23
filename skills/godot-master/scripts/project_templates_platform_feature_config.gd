class_name PlatformFeatureConfig
extends Node

## Use Godot's built-in Feature Tags to conditionally execute logic.
## Strips server logic from client builds and manages mobile-specific overrides.

@export var mobile_max_fps: int = 60
@export var desktop_max_fps: int = 144

func _ready() -> void:
	_apply_platform_overrides()

func _apply_platform_overrides() -> void:
	if OS.has_feature("dedicated_server"):
		# Start headless multiplayer server
		_initialize_server_logic()
	elif OS.has_feature("mobile"):
		# Lower rendering overhead for Android/iOS
		_apply_mobile_profile()
	elif OS.has_feature("pc"):
		_apply_desktop_profile()

func _apply_mobile_profile() -> void:
	# Disable heavy post-processing
	get_viewport().use_taa = false
	Engine.max_fps = mobile_max_fps

func _apply_desktop_profile() -> void:
	Engine.max_fps = desktop_max_fps

func _initialize_server_logic() -> void:
	# Disable visual processing in headless mode
	set_process(false)
	set_physics_process(true)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — custom feature tags on export presets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — mobile FPS and rendering downgrades
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
