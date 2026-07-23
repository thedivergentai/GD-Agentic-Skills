# Material Batching and Override logic
extends Node

## Efficiently sharing materials across multiple meshes
## to ensure GPU draw call batching.

func apply_global_material(group_name: String, mat: Material) -> void:
	for node in get_tree().get_nodes_in_group(group_name):
		if node is MeshInstance3D:
			# Override ensures we don't modify the base .mesh file
			node.material_override = mat
			
	# Result: All meshes in group now draw in a single state-locked batch.


## HLOD: swap detailed ↔ distant meshes and strip expensive shading at range.
## Prefer Pixel Dither distance fade over alpha blend (opaque pipeline).
func setup_lod_materials(detailed_node: GeometryInstance3D, distant_node: GeometryInstance3D, swap_distance: float = 50.0) -> void:
	detailed_node.visibility_range_end = swap_distance
	detailed_node.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
	distant_node.visibility_range_begin = swap_distance
	distant_node.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
	var dist_mat := distant_node.get_surface_override_material(0) as StandardMaterial3D
	if dist_mat == null:
		return
	# Mutate only after ensuring a unique override if the resource is shared.
	dist_mat = dist_mat.duplicate(true) as StandardMaterial3D
	distant_node.set_surface_override_material(0, dist_mat)
	dist_mat.normal_enabled = false
	dist_mat.rim_enabled = false
	dist_mat.clearcoat_enabled = false
	dist_mat.subsurf_scatter_enabled = false
	dist_mat.distance_fade_mode = BaseMaterial3D.DISTANCE_FADE_PIXEL_DITHER
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# - https://docs.godotengine.org/en/stable/classes/class_standardmaterial3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — draw-call / state batching
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — environment mesh material overrides
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
