extends Node
class_name EconomyGraphManager

## Expert Economy Simulation (Godot 4.7).
## Manages resource stocks and production recipes as a data-driven DAG.

var stocks: Dictionary = {} # Store resource counts
var recipes: Dictionary = {} # Define inputs/outputs

func register_recipe(id: StringName, inputs: Dictionary, outputs: Dictionary) -> void:
	recipes[id] = {"in": inputs, "out": outputs}

func process_production(refinery_id: StringName) -> bool:
	var recipe = recipes.get(refinery_id)
	if not recipe: return false
	
	# Expert Pattern: Atomic check-before-deduct to ensure consistency
	for res in recipe.in:
		if stocks.get(res, 0) < recipe.in[res]: return false
	
	for res in recipe.in: stocks[res] -= recipe.in[res]
	for res in recipe.out: stocks[res] = stocks.get(res, 0) + recipe.out[res]
	return true

## [SKILL NOTICE]: Use data-driven Dictionaries for economy logic 
## instead of physical nodes. This allows for massive, high-speed simulations.
