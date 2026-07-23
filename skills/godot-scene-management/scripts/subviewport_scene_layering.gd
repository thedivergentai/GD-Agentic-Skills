# subviewport_scene_layering.gd
# Running two different scenes in parallel using Viewports
extends SubViewportContainer

# EXPERT NOTE: Use SubViewports for Mini-maps, Split-screen, 
# or 3D UI elements rendered in a 2D world.

func _ready() -> void:
	# Ensure the viewport is correctly capturing its own world
	$SubViewport.own_world_3d = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewport.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — cameras inside SubViewports for minimaps/split-screen
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — SubViewportContainer layout in HUD trees
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
