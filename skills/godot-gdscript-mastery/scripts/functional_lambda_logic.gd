# functional_lambda_logic.gd
# Advanced list processing using reduce(), all(), and any()
extends Node

func get_best_target(targets: Array[Node3D]) -> Node3D:
	if targets.is_empty(): return null
	
	# 'reduce' implementation for finding the closest target
	return targets.reduce(
		func(best: Node3D, current: Node3D): 
			var d1 = global_position.distance_to(best.global_position)
			var d2 = global_position.distance_to(current.global_position)
			return current if d2 < d1 else best
	)

func is_room_clear(entities: Array[Node]) -> bool:
	# 'all' returns true if the condition matches every element
	return entities.all(func(e): return e.is_in_group("friendly"))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_advanced.html
# - https://docs.godotengine.org/en/stable/classes/class_array.html
# - https://docs.godotengine.org/en/stable/classes/class_callable.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md — reduce/closest-target patterns in AI queries
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
