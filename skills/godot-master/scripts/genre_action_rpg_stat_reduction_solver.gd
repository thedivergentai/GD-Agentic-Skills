# stat_reduction_solver.gd
# Calculating complex modifier chains using C++ performance loops
extends Node

# EXPERT NOTE: Using reduce() is faster than manual GDScript loops 
# for calculating total damage from a list of multipliers.

func calculate_total_damage(base_dmg: float, modifiers: Array[float]) -> float:
	# Optimized reduction in the engine's internal VM
	return modifiers.reduce(func(accum, val): return accum * val, base_dmg)

func apply_defense(dmg: float, def_res: BaseStats) -> float:
	return max(0, dmg - def_res.defense)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — BaseStats defense input
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html — Array.reduce modifier chains
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — diminishing returns / modifier order
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — sim modifier stacks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
