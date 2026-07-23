# Signal implementation patterns

## Pattern 1: Typed signals

```gdscript
signal health_changed(new_health: int, max_health: int)
signal died()
```

## Pattern 2: Emit on setter

```gdscript
var health: int = 100:
    set(value):
        health = clamp(value, 0, max_health)
        health_changed.emit(health, max_health)
        if health <= 0:
            died.emit()
```

## Pattern 3: Parent connects child

```gdscript
func _ready() -> void:
    player.health_changed.connect(_on_player_health_changed)
    player.died.connect(_on_player_died)

func _on_player_health_changed(current: int, maximum: int) -> void:
    ui.update_health_bar(current, maximum)
```

## Pattern 4: AutoLoad bus

```gdscript
# events.gd (AutoLoad)
signal level_completed(level_number: int)
```

## Pattern 5: Signal chains

Enemy `died` → combat manager → score bus. Prefer typed payloads.

## Pattern 6: CONNECT_ONE_SHOT

```gdscript
timer.timeout.connect(_on_timer_timeout, CONNECT_ONE_SHOT)
```

## Pattern 7: Custom signal arguments (Dictionary payloads)

Use typed fields when possible; Dictionary only for prototype loot tables.

## Best practices

- Descriptive names: `enemy_defeated(enemy_type: String)` not `done()`.
- Mediator breaks A↔B circular graphs.
- Group related signals (combat / movement / inventory).

## Testing (GdUnit4)

Use signal monitors from peer skill [`godot-testing-patterns` / `signal_emission_test.gd`](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/scripts/signal_emission_test.gd) — not GUT `watch_signals`.

## Gotchas

| Issue | Fix |
|-------|-----|
| Silent no-op | Typo in connect; verify emit path runs |
| Double fire | Duplicate connect; use `is_connected` or ONE_SHOT |
| Null instance | Disconnect in `_exit_tree`; capturing lambdas need manual disconnect |

> [!CAUTION]
> `CONNECT_REFERENCE_COUNTED` stacks identical connects — it does **not** auto-clean capturing lambdas.
