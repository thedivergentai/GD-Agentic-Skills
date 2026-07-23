# Harvest Elite Patterns (load on demand)

> **MANDATORY** for offline UNIX gains, worker-thread batching, popup pools, and noise vein placement beyond [harvestable_node.gd](../scripts/game_loop_harvest_harvestable_node.gd).

## Offline progress (UNIX)

> **WHY `Time.get_unix_time_from_system()`:** `OS.get_ticks_msec()` tracks uptime, not real-world absence.

Persist last-exit UNIX timestamp in [harvest_autosave_manager.gd](../scripts/game_loop_harvest_harvest_autosave_manager.gd) / [harvest_loop_patterns.gd](../scripts/game_loop_harvest_harvest_loop_patterns.gd).

## Proc-gen veins (FastNoiseLite)

```gdscript
var noise := FastNoiseLite.new()

func _should_spawn(pos: Vector2) -> bool:
	return noise.get_noise_2dv(pos) > 0.5
```

Persist depleted node IDs + world seed via [harvest_respawn_manager.gd](../scripts/game_loop_harvest_harvest_respawn_manager.gd) — do not re-roll veins every load without a fixed seed.

## Tool durability

Keep durability on [harvest_tool_data.gd](../scripts/game_loop_harvest_harvest_tool_data.gd) Resource — emit `durability_changed` / `tool_broken`. `duplicate(true)` before runtime mutation.

## WorkerThreadPool for bulk sim

> **CAUTION:** Never touch SceneTree off main thread. Batch math on workers; apply results with `call_deferred`.

## Popup pool (WHY)

> **CAUTION:** Instantiating Labels per hit fragments memory. Pool damage/harvest popups; see [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md).

## Idle / UI-heavy harvest games

`OS.low_processor_usage_mode` reduces battery drain when simulation is light.

## Mutex on shared inventory

Background gather sims must lock shared warehouse data — [harvest_inventory_manager.gd](../scripts/game_loop_harvest_harvest_inventory_manager.gd).

## Deplete without killing juice

Hide mesh + disable collision layer → play VFX/SFX → `queue_free` on completion signal. Never immediate free on first hit.

## Rates in `_process`

Multiply passive gather rates by `delta` (prefer `_physics_process` for fixed-step economy).
