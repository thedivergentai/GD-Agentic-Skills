---
name: godot-project-foundations
description: "Expert blueprint for Godot 4 project organization (feature-based folders, naming conventions, version control). Enforces snake_case files, PascalCase nodes, %SceneUniqueNames, and .gitignore best practices. Use when starting new projects or refactoring structure. Keywords project organization, naming conventions, snake_case, PascalCase, feature-based, .gitignore, .gdignore."
---

# Project Foundations

Feature-based organization, consistent naming, and version control hygiene define professional Godot projects.

## Available Scripts

### 🏛️ Core Scaffolding (Stateful / Persistent)
Stateful managers and controllers that persist in the SceneTree or handle global lifecycle events.

- **[project_bootstrapper.gd](scripts/project_bootstrapper.gd)**: Auto-generates feature folders and .gitignore.
- **[runtime_configurator.gd](scripts/runtime_configurator.gd)**: Applies high-performance profiles and saves `override.cfg`.
- **[managed_autoload.gd](scripts/managed_autoload.gd)**: Advanced Singleton pattern with `RefCounted` delegation.
- **[global_event_bus.gd](scripts/global_event_bus.gd)**: Strongly-typed global Signal Bus for system decoupling.
- **[node_pooling_system.gd](scripts/node_pooling_system.gd)**: Thread-safe Object Pool for high-frequency scene instantiation.
- **[async_resource_loader.gd](scripts/async_resource_loader.gd)**: Threaded non-blocking scene loading with progress status.

### 🛠️ Runtime Utilities (Stateless / Lightweight)
Stateless helper scripts, static libraries, and custom data containers (Resource/RefCounted).

- **[base_data_resource.gd](scripts/base_data_resource.gd)**: Reactive Resource foundation using `emit_changed()`.
- **[advanced_telemetry_logger.gd](scripts/advanced_telemetry_logger.gd)**: Custom OS-level `Logger` for crash reporting.
- **[threaded_task_worker.gd](scripts/threaded_task_worker.gd)**: Robust `WorkerThreadPool` implementation.
- **[action_buffer_input.gd](scripts/action_buffer_input.gd)**: Foundational `_unhandled_input` buffer.
- **[build_metadata_provider.gd](scripts/build_metadata_provider.gd)**: Native extraction of version and build metadata.

> **Do NOT Load** dependency_auditor.gd unless troubleshooting loading errors.


## NEVER Do (Expert Anti-Patterns)

### Global Architecture
- **NEVER group by file type** —  `/scripts`, `/sprites` folders. Nightmare maintainability. Use feature-based: `/player`, `/ui`.
- **NEVER mix snake_case and PascalCase in files** — Standard: snake_case for files, PascalCase for nodes.
- **NEVER use hardcoded get_node() paths** — Brittle on reparenting. Use `%SceneUniqueNames` for stable references.
- **NEVER use monolithic Autoloads** — Avoid managers that hold visual node references; keep singletons focused on pure data or RefCounted delegation.

### Resource Management
- **NEVER forget .gitignore**  — Committing `.godot/` folder = 100MB+ bloat + conflicts.
- **NEVER skip .gdignore for raw assets** — Design source files (`.psd`, `.blend`) in root will be imported unless ignored.
- **NEVER modify globally shared Resources directly** — Strictly call `duplicate(true)` for unique instances with independent state.

### Performance & Threading
- **NEVER block the main thread with `load()`** — Strictly use `ResourceLoader.load_threaded_request()` for async scene transitions.
- **NEVER modify the SceneTree from a background thread** — Strictly use `call_deferred()` for thread-to-main-thread synchronization.
- **NEVER skip Mutex locking during pooled access** — Strictly ensure thread-safety when using a shared `WorkerThreadPool` or Object Pool.
- **NEVER use `_process()` for precise input** — Tied to visual framerate. Strictly use `_unhandled_input()` to capture exact, frame-independent events.

---

### 1. Naming Conventions
- **Files & Folders**: Always use `snake_case`. (e.g., `player_controller.gd`, `main_menu.tscn`).
    - *Exception*: C# scripts use `PascalCase` for class-match.
- **Node Names**: Always use `PascalCase` (e.g., `PlayerSprite`, `CollisionShape2D`).
- **Exported Variables**: Use `snake_case`. (e.g., `@export var max_health: int`). The Inspector automatically converts this to Title Case ("Max Health").
- **Internal / Private Members**: Prepend a single underscore `_` to variables and methods that are internal to the class. (e.g., `var _current_health`, `func _calculate_damage()`). This also applies to virtual engine callbacks (e.g., `_ready`, `_process`).
- **Signals**: Use **past-tense** `snake_case` to represent events that have already occurred. (e.g., `signal health_changed`, `signal door_opened`).
- **Unique Names**: Use `%SceneUniqueNames` for frequently accessed nodes to avoid brittle `get_node()` paths.

### 2. Feature-Based Organization
Instead of grouping by *type* (e.g., `/scripts`, `/sprites`), group by *feature* (the "What", not the "How").

**Correct Structure:**
```
/project.godot
/common/           # Global resources, themes, shared scripts
/entities/
    /player/       # Everything related to player
        player.tscn
        player.gd
        player_sprite.png
    /enemy/
/ui/
    /main_menu/
/levels/
/addons/           # Third-party plugins
```

### 3. Version Control
- Always include a `.gitignore` tailored for Godot (ignoring `.godot/` folder and import artifacts).
- Use `.gdignore` in folders that Godot should not scan/import (e.g., raw design source files).

## Godot 4.7: Foundations

- **Asset Store** replaces Asset Library for third-party content discovery.
- New projects use `canvas_items` + `expand` stretch defaults — account for in UI layout tests.

## Workflow: Scaffolding a New Project

When asked to "Setup a project" or "Start a new game":

1. **Initialize Root**: Ensure `project.godot` exists.
2. **Create Core Folders**:
   - `entities/`
   - `ui/`
   - `levels/`
   - `common/`
3. **Setup Git**: Create a comprehensive `.gitignore`.
4. **Documentation**: Create a `README.md` explaining the feature-based structure.

## 🔄 Migration Guide: Typed GDScript 2.0

Transitioning from untyped GDScript or C# to strictly-typed GDScript 2.0.

### 1. The Inference Operator (`:=`)
Use `:=` when the type is obvious from the right-hand side.
- **Good**: `var pos := Vector2(10, 10)`
- **Redundant**: `var pos: Vector2 = Vector2(10, 10)`

### 2. Typed Collections
Godot 4 introduces statically typed arrays and dictionaries.
- **Array**: `var enemies: Array[Enemy] = []`
- **Dictionary**: `var spawn_rates: Dictionary[StringName, float] = {}`

### 3. Explicit Return Types
Always specify the return type, even if it is `void`.
- `func take_damage(amount: int) -> void:`

### 4. Safe Casting (`as`)
Use the `as` keyword to guarantee a type and get "safe lines" (green line numbers in the editor).
- `var timer := $Timer as Timer`

### 5. Enforce Strictness
In **Project Settings > Debug > GDScript**, set **Untyped Declaration** to `Warn` or `Error`.

## Expert Foundation Architectures

### 1. Scene Transition Manager (Threaded)
Avoid blocking the main thread during scene changes by using `ResourceLoader.load_threaded_request()`. This allows you to show an animated loading screen while the background thread parses the next level.

```gdscript
class_name SceneManager extends Node
## Autoload: Manages threaded scene transitions.

signal progress_updated(percent: float)
var _target_path: String = ""

func load_scene(path: String) -> void:
    _target_path = path
    if ResourceLoader.load_threaded_request(path) == OK:
        set_process(true)

func _process(_delta: float) -> void:
    var progress := []
    var status := ResourceLoader.load_threaded_get_status(_target_path, progress)
    
    match status:
        ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            progress_updated.emit(progress[0] * 100)
        ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(_target_path) as PackedScene
            get_tree().change_scene_to_packed(scene)
            set_process(false)
```

### 2. Global Event Bus (Decoupled)
Maintain strict decoupling by using a global "Event Bus" Autoload. This allows distant systems (e.g., UI and Boss AI) to communicate without knowing each other's existence.

```gdscript
class_name EventBus extends Node
## Autoload: Central hub for global signals.

signal player_died
signal quest_completed(quest_id: String)
signal boss_phase_changed(new_phase: int)

# Usage (Publisher):
# EventBus.player_died.emit()

# Usage (Subscriber):
# EventBus.player_died.connect(_on_player_death)
```

### 3. Project Metadata (Resource-Based)
Centralize project info like versioning, build dates, and feature flags in a dedicated `Resource`. This is type-safe and more performant than parsing raw JSON/TXT files.

```gdscript
class_name ProjectMetadata extends Resource
## Data container for project-wide configuration.

@export var version: String = "1.0.0"
@export var build_date: String = "2026-04-30"
@export var debug_mode: bool = false

func save_metadata(path: String = "user://metadata.res") -> void:
    ResourceSaver.save(self, path)

static func load_metadata(path: String = "user://metadata.res") -> ProjectMetadata:
    if ResourceLoader.exists(path):
        return ResourceLoader.load(path) as ProjectMetadata
    return ProjectMetadata.new()
```

## Reference
- Official Docs: `tutorials/best_practices/project_organization.rst`
- Official Docs: `tutorials/best_practices/scene_organization.rst`


### Related
- Master Skill: [godot-master](../godot-master/SKILL.md)
