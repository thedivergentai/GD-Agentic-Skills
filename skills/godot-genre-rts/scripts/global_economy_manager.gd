extends Node

## Expert RTS Economy (Godot 4.7).
## Global Singleton for decoupled resource management.

signal budget_updated(res_id: String, new_total: int)

var _bank: Dictionary = {"gold": 1000, "iron": 500}

func try_spend(costs: Dictionary) -> bool:
	# 1. Verification Pass
	for id in costs:
		if _bank.get(id, 0) < costs[id]: return false
	
	# 2. Deduction Pass
	for id in costs:
		_bank[id] -= costs[id]
		budget_updated.emit(id, _bank[id])
	return true

func add_funds(id: String, amount: int) -> void:
	_bank[id] = _bank.get(id, 0) + amount
	budget_updated.emit(id, _bank[id])

## [SKILL NOTICE]: Use a 'Dictionary'-based cost system within an 'Autoload'. 
## This allows flexible multi-resource checkouts (e.g., Gold + Iron) for units.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — economy Autoload boot order
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md — multi-resource spend/ledger patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate cost curves vs gather rates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
