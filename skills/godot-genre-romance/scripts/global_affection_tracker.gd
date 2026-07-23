extends Node

## Expert Affection Tracker (Godot 4.7).
## Global Singleton for decoupled relationship management.

signal affection_updated(npc_id: String, new_val: int, change: int)

var _npc_data: Dictionary = {} # npc_id: current_affection

func modify_affection(npc_id: String, amount: int) -> void:
	var current = _npc_data.get(npc_id, 0)
	_npc_data[npc_id] = current + amount
	
	# Expert Pattern: Decouple from UI using Signals
	affection_updated.emit(npc_id, _npc_data[npc_id], amount)

func get_affection(npc_id: String) -> int:
	return _npc_data.get(npc_id, 0)

## [SKILL NOTICE]: Use 'Signals' inside an 'Autoload' to notify the UI 
## of affection changes without the dialogue system needing to know it exists.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — singleton ownership for global affection
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — affection_updated UI decoupling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md
# =============================================================================
