# array_preallocation_perf.gd
# Avoiding reallocation spikes by pre-sizing large arrays
extends Node

# EXPERT NOTE: Calling append() 10,000 times triggers hundreds of 
# expensive memory reallocations. Always resize() first.

func fast_generate_lattice(size: int) -> PackedVector3Array:
	var lattice := PackedVector3Array()
	# Pre-allocate memory instantly
	lattice.resize(size * size)
	
	for i in size:
		for j in size:
			# Index-based assignment is significantly faster than append()
			lattice[i * size + j] = Vector3(i, 0, j)
			
	return lattice
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — resize before append storms
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — pre-size lattices/meshes in generators
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
