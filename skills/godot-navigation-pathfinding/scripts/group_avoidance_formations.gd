# group_avoidance_formations.gd
# Coordinating RVO group behavior (logic overview)
extends Node

# Expert Strategy:
# Avoid giving every agent the same target. This causes "clumping".
# Instead, calculate an offset target for each agent in a formation.

func update_group_targets(leader_pos: Vector3, agents: Array[RID]) -> void:
	for i in range(agents.size()):
		var offset = calculate_formation_offset(i)
		var personal_target = leader_pos + offset
		# NavigationServer3D.agent_set_velocity(...)
		pass

func calculate_formation_offset(index: int) -> Vector3:
	# Grid or Wedge formation logic
	return Vector3.ZERO
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md — formation offsets prevent clumping
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — crowd spacing affects engagement timing
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md
# =============================================================================
