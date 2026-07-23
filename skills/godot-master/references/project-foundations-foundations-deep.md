# Project Foundations Deep Dive (load on demand)

> **MANDATORY** for naming tables, typed-GDScript migration, and architecture samples beyond bundled scripts. Do not re-inline EventBus / SceneManager code in chat.

## Naming conventions (full)

| Artifact | Convention | Example |
|----------|------------|---------|
| Files / folders | `snake_case` | `player_controller.gd` |
| Nodes | `PascalCase` | `PlayerSprite` |
| Exports | `snake_case` | `@export var max_health` |
| Private members | `_` prefix | `var _current_health` |
| Signals | past-tense `snake_case` | `signal health_changed` |
| Stable refs | `%SceneUniqueNames` | `%Hitbox` |

C# exception: PascalCase class/file match.

## Feature folder layout

```
/project.godot
/common/
/entities/player/
/ui/main_menu/
/levels/
/addons/
```

## Version control

- `.gitignore` — ignore `.godot/` (use [project_bootstrapper.gd](../scripts/project_foundations_project_bootstrapper.gd); starter ignore file: [`godot.gitignore`](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/godot.gitignore) beside this skill’s `SKILL.md`).
- `.gdignore` on raw `.psd` / `.blend` source drops.

## Typed GDScript 2.0 migration

1. `:=` when RHS type is obvious.
2. `Array[Enemy]`, `Dictionary[StringName, float]`.
3. Explicit `-> void` return types.
4. `as Timer` for safe casts.
5. **Project Settings → Debug → GDScript → Untyped Declaration** = `Warn` or `Error`.

Full guide: [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md).

## Expert: threaded scene manager

**MANDATORY** [async_resource_loader.gd](../scripts/project_foundations_async_resource_loader.gd) — do not paste duplicate SceneManager samples.

```gdscript
func load_scene(path: String) -> void:
    if ResourceLoader.load_threaded_request(path) == OK:
        set_process(true)

func _process(_delta: float) -> void:
    var progress := []
    match ResourceLoader.load_threaded_get_status(_target_path, progress):
        ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            progress_updated.emit(progress[0] * 100.0)
        ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(_target_path) as PackedScene
            get_tree().change_scene_to_packed(scene)
            set_process(false)
```

## Expert: global event bus

**MANDATORY** [global_event_bus.gd](../scripts/project_foundations_global_event_bus.gd).

```gdscript
# Publisher: EventBus.player_died.emit()
# Subscriber: EventBus.player_died.connect(_on_player_death)
```

## Expert: project metadata Resource

[build_metadata_provider.gd](../scripts/project_foundations_build_metadata_provider.gd) / [base_data_resource.gd](../scripts/project_foundations_base_data_resource.gd):

```gdscript
class_name ProjectMetadata extends Resource
@export var version: String = "1.0.0"

static func load_metadata(path: String = "user://metadata.res") -> ProjectMetadata:
    if ResourceLoader.exists(path):
        return ResourceLoader.load(path) as ProjectMetadata
    return ProjectMetadata.new()
```

## Godot 4.7 foundations

- Asset Store replaces Asset Library for third-party discovery.
- Default stretch `canvas_items` + `expand` — test UI on new projects.

## Workflow: new project

1. `project.godot` + [project_bootstrapper.gd](../scripts/project_foundations_project_bootstrapper.gd) folders.
2. Godot-aware `.gitignore`.
3. README documenting feature-based layout.
4. Register Autoloads only after ownership decision tree (SKILL.md).
