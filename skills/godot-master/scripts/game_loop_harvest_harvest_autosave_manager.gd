class_name HarvestAutoSaveManager
extends Node

## Manages interval-based auto-saving for harvest progress.
## Uses FileAccess and JSON for serialization to user://.

@export var save_interval: float = 60.0 # Seconds
@export var save_path: String = "user://harvest_progress.json"

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = save_interval
	_timer.autostart = true
	add_child(_timer)
	_timer.timeout.connect(execute_save)

## Collects data from the game and saves to disk.
func execute_save() -> void:
	# Note: In a real project, pull this from a global Inventory or Stats manager
	var data_to_save = _gather_harvest_data()
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data_to_save)
		file.store_line(json_string)
		print_rich("[color=cyan][Harvest] Progress auto-saved to %s[/color]" % save_path)
	else:
		push_error("Failed to open save file at %s" % save_path)

func _gather_harvest_data() -> Dictionary:
	# Placeholder for actual data gathering logic
	return {
		"timestamp": Time.get_datetime_dict_from_system(),
		"resources": {} # Populate with actual inventory counts
	}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html — user:// JSON autosave writes
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html — serialize harvest progress safely
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html — user:// path semantics
# - https://docs.godotengine.org/en/stable/classes/class_timer.html — interval Timer child for execute_save
# - https://docs.godotengine.org/en/stable/classes/class_time.html — timestamp field in save blob
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — production save schema beyond interval JSON
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — autosave manager as Autoload
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md
# =============================================================================
