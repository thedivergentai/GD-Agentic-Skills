# mesh_gen_infinite_terrain.gd
# Dynamic Mesh generation for 3D terrain [ArrayMesh]
extends MeshInstance3D

# EXPERT NOTE: For infinite 3D terrain, generating a custom ArrayMesh 
# is better than tiling StaticBody3D planes.

func generate_plane(width: int, depth: int):
	var am = ArrayMesh.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Generate vertices with noise height
	for z in range(depth):
		for x in range(width):
			var y = 0 # noise.get_noise_2d(x, z)
			st.add_vertex(Vector3(x, y, z))
	
	# Generate indices...
	st.generate_normals()
	am = st.commit()
	mesh = am
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html
# - https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — LOD / visibility ranges around generated chunks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — trimesh/convex collision after mesh commit
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
