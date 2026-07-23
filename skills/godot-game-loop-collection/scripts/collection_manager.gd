class_name CollectionManager
extends Node

## Authoritative hunt progress: stable per-item IDs grouped by collection_id.
## Tracks which item_ids are collected — not a blind increment counter.

# Emitted when a specific item is newly collected: (collection_id, item_id)
signal item_collected(collection_id: String, item_id: String)

# Emitted when progress changes: (collection_id, collected_count, total_count)
signal collection_updated(collection_id: String, collected_count: int, total_count: int)

# Emitted when every item_id in a collection is collected
signal collection_completed(collection_id: String)

# { collection_id: { "collected": PackedStringArray, "all_ids": PackedStringArray } }
var _collections: Dictionary = {}


func _ready() -> void:
	add_to_group(&"collection_manager")


func start_collection(collection_id: String, item_ids: PackedStringArray) -> void:
	_collections[collection_id] = {
		"collected": PackedStringArray(),
		"all_ids": item_ids.duplicate(),
	}
	collection_updated.emit(collection_id, 0, item_ids.size())


func register_item(collection_id: String, item_id: String) -> bool:
	if not _collections.has(collection_id):
		return false

	var data: Dictionary = _collections[collection_id]
	if item_id in data["collected"]:
		return false
	if item_id not in data["all_ids"]:
		push_warning(
			"CollectionManager: unknown item_id '%s' for collection '%s'"
			% [item_id, collection_id]
		)
		return false

	data["collected"].append(item_id)
	item_collected.emit(collection_id, item_id)

	var collected_count: int = data["collected"].size()
	var total_count: int = data["all_ids"].size()
	collection_updated.emit(collection_id, collected_count, total_count)

	if collected_count >= total_count:
		collection_completed.emit(collection_id)

	return true


func is_item_collected(collection_id: String, item_id: String) -> bool:
	if not _collections.has(collection_id):
		return false
	return item_id in _collections[collection_id]["collected"]


func get_collected_ids(collection_id: String) -> PackedStringArray:
	if not _collections.has(collection_id):
		return PackedStringArray()
	return _collections[collection_id]["collected"].duplicate()


func get_remaining_ids(collection_id: String) -> PackedStringArray:
	if not _collections.has(collection_id):
		return PackedStringArray()

	var data: Dictionary = _collections[collection_id]
	var remaining := PackedStringArray()
	for id in data["all_ids"]:
		if id not in data["collected"]:
			remaining.append(id)
	return remaining


func get_progress(collection_id: String) -> Dictionary:
	if not _collections.has(collection_id):
		return {"collected": 0, "total": 0}

	var data: Dictionary = _collections[collection_id]
	return {"collected": data["collected"].size(), "total": data["all_ids"].size()}


func restore_collected_ids(collection_id: String, collected_ids: PackedStringArray) -> void:
	if not _collections.has(collection_id):
		return

	_collections[collection_id]["collected"] = collected_ids.duplicate()
	var data: Dictionary = _collections[collection_id]
	var collected_count: int = data["collected"].size()
	var total_count: int = data["all_ids"].size()
	collection_updated.emit(collection_id, collected_count, total_count)

	if collected_count >= total_count:
		collection_completed.emit(collection_id)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — connect many collectibles to one manager
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist collection dictionaries
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — promote completed collections to quest rewards
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-collection/SKILL.md
# =============================================================================
