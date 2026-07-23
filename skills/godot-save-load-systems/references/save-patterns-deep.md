# Save/Load Patterns Deep Dive (load on demand)

> **MANDATORY** when implementing JSON Autoloads, PERSIST groups, binary snapshots, encrypted slots, or integrity checks beyond Golden Path bullets in SKILL.md. Do not paste these tutorials into scenes from memory.

## Pattern 1: JSON Save System

### Step 1 — SaveManager Autoload

```gdscript
# save_manager.gd
extends Node

const SAVE_PATH := "user://savegame.save"

func save_game(data: Dictionary) -> void:
    var save_file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if save_file == null:
        push_error("Failed to open save file: " + str(FileAccess.get_open_error()))
        return
    save_file.store_line(JSON.stringify(data, "\t"))
    save_file.close()

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}
    var save_file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if save_file == null:
        return {}
    var json_string := save_file.get_as_text()
    save_file.close()
    var json := JSON.new()
    if json.parse(json_string) != OK:
        push_error("JSON Parse Error: " + json.get_error_message())
        return {}
    return json.data as Dictionary
```

### Step 2 — Player serialize hooks

```gdscript
func save_data() -> Dictionary:
    return {
        "health": health,
        "score": score,
        "level": level,
        "position": {"x": global_position.x, "y": global_position.y}
    }

func load_data(data: Dictionary) -> void:
    health = data.get("health", 100)
    score = data.get("score", 0)
    level = data.get("level", 1)
    if data.has("position"):
        global_position = Vector2(data.position.x, data.position.y)
```

### Step 3 — Trigger save/load

Always include `"version"` and migrate before applying player state — see [save_migration_manager.gd](../scripts/save_migration_manager.gd).

## Pattern 2: Binary `store_var`

> **CAUTION:** Baseline examples used `store_var(data, true)`. Production saves must use **`false`** unless the payload is trusted-local tooling you control. See SKILL.md `allow_objects` trust boundary.

```gdscript
func save_game_binary(data: Dictionary) -> void:
    var save_file := FileAccess.open("user://savegame.dat", FileAccess.WRITE)
    if save_file:
        save_file.store_var(data, false)
        save_file.close()
```

## Pattern 3: PERSIST group collect

Nodes in group `persist` / `Persist` implement `save()` / `load()`. Manager walks `get_nodes_in_group` — see [save_load_patterns.gd](../scripts/save_load_patterns.gd).

## Best practices (WHY)

| Rule | WHY |
|------|-----|
| `user://` only | OS maps to correct app-data folder per platform |
| Version field | Enables [save_migration_manager.gd](../scripts/save_migration_manager.gd) |
| Validate on load | Users edit JSON; `data.get("field", default)` prevents crashes |
| Save on menu/checkpoint | Mid-physics write + crash = corruption |
| `data.duplicate()` when iterating keys | Erasing during iteration errors |
| Strip `set_meta` noise | Shrinks save size |

## Vector3 / resource path gotchas

```gdscript
# Store components, not Variant blobs that JSON mangles
"position": {"x": pos.x, "y": pos.y, "z": pos.z}
"texture_path": texture.resource_path  # reload with load(path)
```

## Elite: encrypted + rolling backup + SHA-256

Scripts: [save_system_encryption.gd](../scripts/save_system_encryption.gd), [save_integrity_validator.gd](../scripts/save_integrity_validator.gd).

1. **Backup before overwrite** — `DirAccess.copy_absolute` to `.bak`
2. **Encrypt sensitive slots** — `FileAccess.open_encrypted_with_pass`
3. **Integrity** — compare `FileAccess.get_sha256(path)`; fall back to backup on mismatch

## Auto-save timer pattern

Use explicit game events first; if auto-save is required, drive a `Timer` (e.g. 300s) that calls the same `save_game_state()` as manual saves — never per-frame.

## Debug self-test

```gdscript
func test_save_load() -> void:
    var test_data := {"test_key": "test_value", "number": 42}
    save_game(test_data)
    var loaded := load_game()
    assert(loaded.test_key == "test_value")
    assert(loaded.number == 42)
```
