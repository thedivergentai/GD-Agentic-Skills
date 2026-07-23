# aoe_group_broadcaster.gd
# Rapidly applying damage to groups of entities
extends Node

# EXPERT NOTE: call_group is an optimized engine-level broadcast 
# that avoids Python-style loop overhead for thousands of entities.

func cast_fireball(pos: Vector2, radius: float, damage: int):
	# Assuming enemies are added to the "enemies" group
	get_tree().call_group("enemies", "take_aoe_damage", pos, radius, damage)

# The individual enemy script would implement:
# func take_aoe_damage(origin: Vector2, r: float, dmg: int):
#     if global_position.distance_to(origin) < r:
#         _take_damage(dmg)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html — call_group AoE broadcast
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html — avoid SceneTree scans
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — take_aoe_damage resolve
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — group calls vs signal buses
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
