# quest_conflict_resolver.gd
extends Node
class_name QuestConflictResolver

## Mutex-guarded objective progress for concurrent updates (network / parallel logic).
## Defer UI/signal fan-out to the main thread.

signal progress_committed(objective_id: StringName, total: int)

var _mutex := Mutex.new()
var _progress_map: Dictionary = {}


func safely_add_progress(objective_id: StringName, amount: int) -> void:
	_mutex.lock()
	_progress_map[objective_id] = int(_progress_map.get(objective_id, 0)) + amount
	var current: int = _progress_map[objective_id]
	_mutex.unlock()
	call_deferred("_emit_progress", objective_id, current)


func _emit_progress(objective_id: StringName, total: int) -> void:
	progress_committed.emit(objective_id, total)
