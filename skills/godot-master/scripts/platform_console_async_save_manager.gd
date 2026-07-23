class_name AsyncSaveManager
extends Node

## Expert Threaded Save System for Console certification.
## Prevents main-thread stutters and implements atomic file writing.

var _save_mutex := Mutex.new()
var _is_saving := false

func execute_save(data: Dictionary, slot: int = 1) -> void:
	_save_mutex.lock()
	if _is_saving:
		_save_mutex.unlock()
		return
	_is_saving = true
	_save_mutex.unlock()
	
	# Offload I/O to background thread pooled workers
	WorkerThreadPool.add_task(_write_to_disk.bind(data, slot))

func _write_to_disk(data: Dictionary, slot: int) -> void:
	var json_str = JSON.stringify(data)
	var final_path = "user://save_slot_%d.dat" % slot
	var temp_path = final_path + ".tmp"
	
	var file = FileAccess.open(temp_path, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()
		
		# Atomic rename to protect against power-loss corruption
		DirAccess.rename_absolute(temp_path, final_path)
	
	_save_mutex.lock()
	_is_saving = false
	_save_mutex.unlock()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — atomic rename and slot schema
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — serializing Dictionary/JSON payloads
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
