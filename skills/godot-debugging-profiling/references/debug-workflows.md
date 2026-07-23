# Debug & Profiler Workflows (load on demand)

> Official docs cover print/breakpoint basics. Load this when you need workflow depth beyond the symptom → script table in SKILL.md.

## Print debugging contract

```gdscript
print("Player health:", health)  # labeled context
push_warning("Deprecated API path")
push_error("Recoverable fault")
assert(health > 0, "Health cannot be negative!")  # debug only
```

Wrap dev prints: `if OS.is_debug_build():`

## Breakpoints

Editor gutter or `breakpoint` keyword in suspicious functions. Conditional: `if player.health <= 0: breakpoint`

## Remote debug

Run game (F5) → Debug → Remote Debug → inspect live SceneTree.

## Common patterns

### Null-safe nodes

```gdscript
var node := get_node_or_null("MaybeExists")
if node:
	node.do_thing()
```

### Track property changes

```gdscript
var _health: int = 100
var health: int:
	get: return _health
	set(value):
		print("Health changed: %d → %d" % [_health, value])
		print_stack()
		_health = value
```

## Profiler usage

- **Time profiler:** target < 16.67 ms/frame at 60 FPS
- **Monitor tab:** FPS, memory, draw calls, `OBJECT_ORPHAN_NODE_COUNT` (debug only)
- Profile **release** exports with V-Sync off

## Expert workflows (scripts)

| Workflow | Script |
|----------|--------|
| Headless CI exit codes | [automated_qa_suite.gd](../scripts/automated_qa_suite.gd) |
| Microbenchmarks | [high_precision_benchmarker.gd](../scripts/high_precision_benchmarker.gd) |
| GPU draw-call overlay | RenderingServer `RENDERING_INFO_*` — see baseline expert § Visual Profiler Extensions |
| Thread safety enforcement | `Thread.set_thread_safety_checks_enabled(true)` + [thread_safety_assert.gd](../scripts/thread_safety_assert.gd) |
| Orphan growth | [orphan_node_detector.gd](../scripts/orphan_node_detector.gd) |
| ObjectDB snapshots | Godot ObjectDB profiler docs + [memory_usage_threshold_alert.gd](../scripts/memory_usage_threshold_alert.gd) |

## File I/O error handling template

```gdscript
func load_save() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		push_warning("No save file found")
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save: %s" % FileAccess.get_open_error())
		return {}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		push_error("JSON parse error: %s" % json.get_error_message())
		return {}
	return json.data
```

## Debug flags pattern

```gdscript
const DEBUG := true
func debug_log(message: String) -> void:
	if DEBUG:
		print("[DEBUG] ", message)
```
