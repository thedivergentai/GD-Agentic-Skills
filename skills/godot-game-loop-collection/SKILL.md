---
name: godot-game-loop-collection
description: Use when implementing collection quests, scavenger hunts, or "find all X" objectives.
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Collection Game Loops

## Overview
This skill provides a standardized framework for "Collection Loops" – gameplay objectives where the player must find and gather a specific set of items (e.g., hidden eggs, data logs, coins).

## NEVER Do

- **NEVER use free() to destroy an active state node or level** — This can cause crashes if the node is still processing. Always use `queue_free()` to safely dispose of it at the end of the frame.
- **NEVER calculate physics-dependent game state in _process()** — Movement and precise collisions must happen in `_physics_process()` to stay synced with the engine's fixed timestep.
- **NEVER execute heavy state transitions (like loading massive levels) synchronously** — Calling `load()` on a huge scene stalls the main thread. Use `ResourceLoader.load_threaded_request()`.
- **NEVER use exact floating-point equality (==) for time-based states** — Floating-point errors will eventually cause missed triggers. Use `is_equal_approx()` or relative comparisons.
- **NEVER manipulate the active SceneTree from a background thread** — The SceneTree is not thread-safe. Use `call_deferred()` to push results back to the main thread.
- **NEVER rely on a monolithic "GameManager" with hardcoded absolute paths** — This creates tight coupling. Use groups, signals, and exported references for a modular architecture.
- **NEVER assume child nodes are ready before their parent** — `_ready()` executes from bottom-to-top. If you need child references, use `@onready` or `await ready`.
- **NEVER use string-based signals for critical state transitions** — Avoid `connect("signal", _on_func)`. Use the Signal object syntax (`signal.connect(_on_func)`) for compile-time validation.
- **NEVER poll for input state every frame for discrete menu events** — Use the `_unhandled_input()` callback to cleanly intercept events without wasting CPU cycles in `_process()`.
- **NEVER crash the engine intentionally via CRASH_NOW_MSG** — Regular state handling should always recover gracefully. Crashing is for unrecoverable internal engine failures.
- **NEVER hardcode spawn positions in code** — Always use `Marker3D` or `CollisionShape3D` nodes in the scene so designers can adjust layout without touching code.
- **NEVER neglect "juice" before an item disappears** — Immediate `queue_free()` feels dry. Always spawn particles or play a sound before removal.
- **NEVER use global variables for local collection progress** — Keep counts encapsulated within the `CollectionManager` and emit signals to update the UI.
- **NEVER leave orphaned nodes in the tree during state swaps** — Always ensure the previous level/state is properly queued for deletion before instantiating the new one.
- **NEVER scale collision shapes non-uniformly for collectibles** — This breaks collision detection math. Adjust the internal shape resource properties instead.

---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [collection_loop_patterns.gd](scripts/collection_loop_patterns.gd)
Collection of 10 expert patterns: Custom MainLoop extensions, deferred scene switching, threaded loading, and frame throttling.

### [collection_manager.gd](scripts/collection_manager.gd)
The central brain of the hunt. Tracks progress and manages completion signals.

### [collection_compass.gd](scripts/collection_compass.gd)
Spatial radar for pointing towards the nearest collectible using vector math.

---

## Expert Collection Patterns

### 1. Persistent Collection (Save/Load)
To ensure progress survives restarts, use `FileAccess` to store data in `user://`.

```gdscript
func save_progress(data: Dictionary):
    var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
    file.store_var(data) # Binary serialization for performance

func load_progress() -> Dictionary:
    if not FileAccess.file_exists("user://save.dat"): return {}
    var file = FileAccess.open("user://save.dat", FileAccess.READ)
    return file.get_var()
```

### 2. Collection Archive UI (Silhouettes)
Display uncollected items as silhouettes without extra textures by using `modulate`.

- **Technique**: Use an `ItemList` or `TextureRect` grid.
- **Silhouette**: Set `modulate = Color(0, 0, 0, 0.5)` for locked items.
- **Reveal**: Set `modulate = Color(1, 1, 1, 1)` once collected.

## Reference
- Master Skill: [godot-master](../godot-master/SKILL.md)
