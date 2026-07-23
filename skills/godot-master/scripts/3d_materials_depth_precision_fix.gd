# Floating Point Precision Fix (Z-fighting)
extends Camera3D

## Flickering textures (Z-fighting) occur when surfaces are too close.
## Compressing the Viewport precision range fixes this for distant terrain.

func optimize_depth_precision() -> void:
	# Architecture Tip: Increase Near as much as usable, 
	# and decrease Far as much as possible.
	near = 0.5  # Default 0.05 is too small for large scenes
	far = 500.0 # Default 4000 is way too high for standard indoor/limited outdoor
	
	# This compresses the depth buffer range and grants 
	# significantly more precision per unit of distance.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — near/far and large-world camera setup
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md — scale where Z-fighting appears
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
