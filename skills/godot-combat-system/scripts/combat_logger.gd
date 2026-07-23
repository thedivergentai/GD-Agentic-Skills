# combat_logger.gd
class_name CombatLogger
extends Node

const LOG_FILE := "user://combat_log.json"
var _session_log: Array[Dictionary] = []

func log_damage_event(source: String, target: String, amount: int) -> void:
	_session_log.append({"source": source, "target": target, "damage": amount})
	if _session_log.size() >= 10:
		_flush_to_disk()

func _flush_to_disk() -> void:
	var file := FileAccess.open(LOG_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_session_log))
		file.close()
