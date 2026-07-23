# navigation_agent_optimization.gd
# Staggering paths for massive AI crowds
extends NavigationAgent3D

# EXPERT NOTE: Recalculating hundreds of paths per frame 
# kills performance. Stagger updates using a global counter.

static var global_update_tick: int = 0

func _process(_delta):
	global_update_tick += 1
	# Only update path every 10 frames, staggered by this agent's ID
	if (global_update_tick + get_instance_id()) % 10 == 0:
		# target_position = ...
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — agent APIs and async bake pairing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md — crowd AI that consumes staggered path budgets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
