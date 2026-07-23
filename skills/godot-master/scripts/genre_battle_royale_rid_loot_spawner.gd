# rid_loot_spawner.gd
# Bypassing Nodes for massive loot quantity
extends Node

# EXPERT NOTE: Rendering thousands of loot items as nodes 
# is slow. Use RenderingServer directly for CPU efficiency.

func spawn_loot_render_only(pos: Vector3, mesh_rid: RID):
	var instance = RenderingServer.instance_create()
	RenderingServer.instance_set_base(instance, mesh_rid)
	RenderingServer.instance_set_scenario(instance, get_world_3d().scenario)
	RenderingServer.instance_set_transform(instance, Transform3D(Basis(), pos))
	return instance
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# - https://docs.godotengine.org/en/stable/classes/class_renderingserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — RID/instance density without nodes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — loot identity when interactables need authority
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
