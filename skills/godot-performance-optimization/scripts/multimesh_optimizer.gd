# multimesh_optimizer.gd
# Rendering thousands of instances with MultiMeshInstance
extends MultiMeshInstance3D

# EXPERT NOTE: MultiMesh uses hardware instancing. It is 
# significantly faster than spawning thousands of 
# individual nodes for grass, debris, or particles.

func setup(count: int):
	multimesh.instance_count = count
	for i in range(count):
		var trans = Transform3D(Basis(), Vector3(randf(), 0, randf()) * 10)
		multimesh.set_instance_transform(i, trans)
		multimesh.set_instance_color(i, Color(randf(), randf(), randf()))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_multimeshinstance3d.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — prop density and spatial MultiMesh partitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md — foliage/crowd instancing at world scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
