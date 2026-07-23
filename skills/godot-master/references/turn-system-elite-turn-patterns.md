# Elite turn-based patterns

Full queue math lives in MANDATORY scripts — these are expert deltas agents miss.

## ATB gauge fill

Per-actor gauges advance in `_process(delta)` by `speed`; pause combat when any gauge hits 100 — [active_time_battle.gd](../scripts/turn_system_active_time_battle.gd).

```gdscript
func _process(delta: float) -> void:
    if not is_combat_active:
        return
    for actor in combatants:
        if actor.atb_gauge < 100.0:
            actor.atb_gauge += actor.speed * delta
            if actor.atb_gauge >= 100.0:
                actor.atb_gauge = 100.0
                is_combat_active = false
                turn_ready.emit(actor)
                break
```

## Timeline prediction (UI)

Simulate gauge ticks in a copied array to preview next N actors — **MANDATORY** [turn_predictor.gd](../scripts/turn_system_turn_predictor.gd) (pairs with [timeline_turn_manager.gd](../scripts/turn_system_timeline_turn_manager.gd)).

## Combat prediction helper

**MANDATORY** [combat_stats_resource.gd](../scripts/turn_system_combat_stats_resource.gd) — `get_expected_damage(target)` for hover previews; deterministic `attack - defense`, clamped ≥ 0.

## TurnManager contract

Keep Autoload thin — signals only; implement sort/AP in [turn_system_patterns.gd](../scripts/turn_system_turn_system_patterns.gd).

> [!CAUTION]
> Recalculate initiative only when speed stats change, not every action.
