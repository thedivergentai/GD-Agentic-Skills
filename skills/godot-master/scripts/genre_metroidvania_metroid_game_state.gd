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
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — doors/items/visited-cell persistence
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — global world-state Autoload
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
