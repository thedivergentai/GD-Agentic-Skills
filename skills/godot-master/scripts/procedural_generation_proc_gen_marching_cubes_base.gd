class_name ProcGenMarchingCubesBase
extends MeshInstance3D

## Base class for 3D terrain generation using ArrayMesh.
## Provides the foundation for Marching Cubes or Voxel geometry.

func update_geometry(vertices: PackedVector3Array, normals: PackedVector3Array, indices: PackedInt32Array) -> void:
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	surface_array[Mesh.ARRAY_VERTEX] = vertices
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	var arr_mesh = ArrayMesh.new()
	# PRIMITIVE_TRIANGLES is the standard for 3D surfaces
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	self.mesh = arr_mesh
	
	# Optimization: Generate collision if needed
	# create_trimesh_collision()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html
# - https://docs.godotengine.org/en/stable/classes/class_arraymesh.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — create_trimesh_collision only for active chunks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — hand off voxel meshes into level streaming
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
