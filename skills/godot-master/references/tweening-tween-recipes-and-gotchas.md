# Tween recipes and gotchas

Expert scripts own interruptible UI — these are supporting recipes.

## Kill before recreate

```gdscript
var current_tween: Tween
func animate_to(pos: Vector2) -> void:
    if current_tween and current_tween.is_valid():
        current_tween.kill()
    current_tween = create_tween().bind_node(self)
    current_tween.tween_property(self, "position", pos, 1.0)
```

MANDATORY: [safe_tween_interruption.gd](../scripts/tweening_safe_tween_interruption.gd).

## finished signal

```gdscript
var tween := create_tween()
tween.tween_property($Sprite, "position", Vector2(100, 0), 1.0)
tween.finished.connect(_on_tween_finished)
```

## Chained fade-move-fade

```gdscript
var tween := create_tween()
tween.tween_property($Sprite, "modulate:a", 0.0, 0.5)
tween.tween_property($Sprite, "position", Vector2(200, 0), 0.0)
tween.tween_property($Sprite, "modulate:a", 1.0, 0.5)
```

## Bezier path

Tween `PathFollow2D.progress_ratio` — see Expert Patterns in SKILL.md.

## Gotchas

| Issue | Fix |
|-------|-----|
| Stops when node freed | `create_tween().bind_node(self)` |
| Conflicting tweens | Kill previous reference |
| Pause menu frozen | `set_ignore_time_scale(true)` — [time_scale_ignored_ui.gd](../scripts/tweening_time_scale_ignored_ui.gd) |
