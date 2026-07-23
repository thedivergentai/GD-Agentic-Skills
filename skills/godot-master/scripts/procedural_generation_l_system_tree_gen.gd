# l_system_tree_gen.gd
# Procedural tree/plant growth using L-Systems
extends Node3D

# Turtle graphics approach to plant generation.

func draw_lsystem(axiom: String, rules: Dictionary, iterations: int):
	var current = axiom
	for i in range(iterations):
		var next = ""
		for char in current:
			next += rules.get(char, char)
		current = next
	# Then iterate characters to draw lines/branches
	return current
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — bark/leaf materials on generated branch meshes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — MultiMesh forests instead of per-tree nodes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
