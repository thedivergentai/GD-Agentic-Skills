# terrain_cost_manager.gd
# Controlling agent preference using enter_cost and travel_cost
extends Node

func set_region_cost(region_rid: RID, is_swamp: bool) -> void:
	if is_swamp:
		# Enter cost: Flat penalty to even consider this region.
		NavigationServer3D.region_set_enter_cost(region_rid, 10.0)
		# Travel cost: Distance multiplier (2.0 = twice as far in path weight).
		NavigationServer3D.region_set_travel_cost(region_rid, 2.5)
	else:
		# Reset to default
		NavigationServer3D.region_set_enter_cost(region_rid, 0.0)
		NavigationServer3D.region_set_travel_cost(region_rid, 1.0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationregions.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md — path preference via enter/travel costs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — cost weights affect simulated travel time
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md
# =============================================================================
