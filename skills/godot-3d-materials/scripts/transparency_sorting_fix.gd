# Transparency Sorting Fix Logic
extends MeshInstance3D

## Resolves artifacts where back surfaces appear in front of closer ones.
## Covers Alpha Scissor vs Alpha Hash vs Depth Draw strategies.

func use_cutout_transparency() -> void:
	var mat = material_override as StandardMaterial3D
	# Best performance, writes to depth buffer, casts shadows
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	mat.alpha_scissor_threshold = 0.5

func use_dithered_transparency() -> void:
	var mat = material_override as StandardMaterial3D
	# Perceptually smooth fade, no sorting artifacts, slower than scissor
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_HASH

func enforce_depth_prepass() -> void:
	var mat = material_override as StandardMaterial3D
	# Resolves overlapping alpha-blended sorting issues
	mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — transparency overdraw cost
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — alpha pipelines for soft FX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
