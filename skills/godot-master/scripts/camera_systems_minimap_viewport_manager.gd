# minimap_viewport_manager.gd
# Setting up 2D/3D Mini-maps using SubViewports [156]
extends SubViewportContainer

# EXPERT NOTE: SubViewports are expensive. Use a low render_target_update_mode 
# for UI elements that don't need 60FPS updates (like world maps).

@onready var minimap_cam: Camera2D = $SubViewport/Camera2D
@export var player: Node2D

func _ready() -> void:
	# Optimization: Only update the minimap if the player moves significantly
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE

func _process(_delta: float) -> void:
	if player:
		# Mini-map follows player but ignores rotation
		minimap_cam.global_position = player.global_position
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewport.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_camera2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — UPDATE_WHEN_VISIBLE / lower update rates
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — SubViewportContainer layout in HUD
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — world/minimap camera ownership across scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# =============================================================================
