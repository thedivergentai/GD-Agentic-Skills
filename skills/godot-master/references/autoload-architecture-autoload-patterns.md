# AutoLoad registration (basic)

> **Do NOT Load** this file for expert architecture work — Project Settings → AutoLoad
> registration and typed-var hygiene are covered by official docs. Open only when a
> teammate needs a beginner checklist.

## Register a Node Autoload

1. Create `res://autoloads/game_manager.gd` extending `Node`.
2. Project → Project Settings → Autoload → Add → name `GameManager`.
3. Verify `project.godot`:

```ini
[autoload]
GameManager="*res://autoloads/game_manager.gd"
```

## Access

```gdscript
func _ready() -> void:
    GameManager.game_started.connect(_on_started)
```

Prefer signals for state changes; do not reach into Autoload children from gameplay
scenes. For boot-order, service locator, and safe scene switch — return to SKILL.md
and the scripts under `scripts/`.
