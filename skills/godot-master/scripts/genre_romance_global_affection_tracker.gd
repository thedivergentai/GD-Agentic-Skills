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
