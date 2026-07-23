# Dynamic Light LOD and Culling
extends OmniLight3D

## Optimization pattern for scenes with many lights.
## Dynamically toggles shadows and visibility based on distance.

@export var shadow_cutoff_distance := 15.0
@export var visibility_cutoff_distance := 30.0

func _process(_delta: float) -> void:
	var camera = get_viewport().get_camera_3d()
	if !camera: return
	
	var dist = global_position.distance_to(camera.global_position)
	
	# Discrete lod steps
	shadow_enabled = (dist < shadow_cutoff_distance)
	visible = (dist < visibility_cutoff_distance)
	
	# Architecture Tip: Distance fading is smoother than binary visibility.
	distance_fade_enabled = true
	distance_fade_begin = 25.0
	distance_fade_length = 5.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
# - https://docs.godotengine.org/en/stable/classes/class_omnilight3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — distance fade budgets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — count shadow casters live
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — LOD distance from active camera
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
