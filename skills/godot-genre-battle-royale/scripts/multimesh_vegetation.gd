# multimesh_vegetation.gd
# Drawing thousands of environment assets in one draw call
extends MultiMeshInstance3D

# EXPERT NOTE: Battle Royale terrain requires dense foliage. 
# MultiMeshInstance3D is essential for 100k+ instances.

func populate_grass(count: int, area: Rect2):
	multimesh.instance_count = count
	for i in range(count):
		var pos = Transform3D(Basis(), Vector3(randf_range(area.position.x, area.end.x), 0, randf_range(area.position.y, area.end.y)))
		multimesh.set_instance_transform(i, pos)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_multimeshinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — foliage density on BR terrain
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — draw-call batching budgets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
