extends Node
class_name ComboTracker

## Combo chain registry — windowed ability sequences that unlock finisher abilities.
## Attach as child of scene-scoped AbilityManager; call register_ability_use() after each cast.

@export var combo_window: float = 2.0

var combo_chain: Array[StringName] = []
var _last_ability_time: float = 0.0

## Map serialized combo keys (e.g. "slash,slash,spin") to finisher ability_id.
@export var combo_recipes: Dictionary = {}

signal combo_triggered(combo_id: StringName, chain: Array)


func register_ability_use(ability_id: StringName) -> void:
	var current_time := Time.get_ticks_msec() * 0.001
	if current_time - _last_ability_time > combo_window:
		combo_chain.clear()
	combo_chain.append(ability_id)
	_last_ability_time = current_time
	_check_combos()


func _check_combos() -> void:
	for recipe_key: Variant in combo_recipes.keys():
		var required: Array = combo_recipes[recipe_key]
		if combo_chain.size() < required.size():
			continue
		var tail := combo_chain.slice(-required.size())
		if tail == required:
			combo_triggered.emit(StringName(str(recipe_key)), combo_chain.duplicate())
			combo_chain.clear()
			return
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/classes/class_time.html — window timing via ticks
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — combo_triggered for UI/VFX
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — scene-scoped manager policy
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — animation lock during combo chains
# ---
