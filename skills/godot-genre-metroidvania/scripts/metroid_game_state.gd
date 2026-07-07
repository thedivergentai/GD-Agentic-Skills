extends Node

## Expert Metroidvania Persistence (Godot 4.7).
## Global state for doors, items, and save rooms.

var opened_doors: Dictionary = {} # StringName -> bool
var collected_items: Array[StringName] = []
var visited_cells: Dictionary = {} # Vector2i -> bool

const SAVE_PATH = "user://savestate.json"

func register_door(id: StringName, open: bool) -> void:
	opened_doors[id] = open

func is_door_open(id: StringName) -> bool:
	return opened_doors.get(id, false)

func save_world() -> void:
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"doors": opened_doors,
		"items": collected_items,
		"fog": visited_cells
	}
	f.store_line(JSON.stringify(data))

## [SKILL NOTICE]: Use 'StringName' for IDs to minimize memory 
## and 'JSON' for human-readable save-game debugging.
