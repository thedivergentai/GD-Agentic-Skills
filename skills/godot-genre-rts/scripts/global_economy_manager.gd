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
