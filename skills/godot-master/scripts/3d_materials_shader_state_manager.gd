# Shader Variant State Manager
extends MeshInstance3D

## Architectural pattern for swapping material states
## (e.g., Frozen, Burnt, Dissolved) without resource duplication.

func set_dissolve_strength(v: float) -> void:
	var mat = get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("dissolve_amount", v)

func set_frozen_state(enabled: bool) -> void:
	var mat = get_active_material(0)
	if mat is ShaderMaterial:
		# Using a float uniform as a boolean for efficiency
		mat.set_shader_parameter("is_frozen", 1.0 if enabled else 0.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_shadermaterial.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — shader parameter state machines
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — avoid per-entity material duplication
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
