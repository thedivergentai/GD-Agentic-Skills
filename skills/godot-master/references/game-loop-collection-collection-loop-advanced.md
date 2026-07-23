# Collection Loop Advanced (load on demand)

> **MANDATORY** for threaded level loads, MainLoop extensions, and archive UI depth beyond [collection_manager.gd](../scripts/game_loop_collection_collection_manager.gd).

## Persistent progress (binary)

```gdscript
func save_progress(data: Dictionary) -> void:
	var file := FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_var(data)

func load_progress() -> Dictionary:
	if not FileAccess.file_exists("user://save.dat"):
		return {}
	var file := FileAccess.open("user://save.dat", FileAccess.READ)
	return file.get_var()
```

Prefer ID sets via manager `get_collected_ids()` / `restore_collected_ids()` — not node paths.

## Archive silhouettes

- Uncollected: `modulate = Color(0, 0, 0, 0.5)`
- Collected: `modulate = Color.WHITE`
- UI mirrors manager signals — never authoritative

## Threaded loading (WHY)

> **CAUTION:** Synchronous `load()` on huge scenes stalls the main thread. Use `ResourceLoader.load_threaded_request()` + poll status; SceneTree changes only on main thread via `call_deferred`.

See [collection_loop_patterns.gd](../scripts/game_loop_collection_collection_loop_patterns.gd).

## General loop NEVER (collection-adjacent)

These apply when collection hunts span level transitions:

- **NEVER** use `free()` on active state nodes — `queue_free()` only
- **NEVER** load massive levels synchronously on collection complete
- **NEVER** manipulate SceneTree from worker threads — `call_deferred`
- **NEVER** use exact float `==` for time gates — `is_equal_approx`
- **NEVER** poll discrete menu input in `_process` — `_unhandled_input`

## Compass edge case

> **CAUTION:** Compass logic must handle **one** remaining item — soft-locking the last pickup is a common regression. Test `get_remaining_ids().size() == 1`.

## Hidden spawns

[hidden_item_spawner.gd](../scripts/game_loop_collection_hidden_item_spawner.gd) — Marker3D anchors + chance; fixed hunts skip this script.
