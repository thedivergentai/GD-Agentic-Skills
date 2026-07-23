---
name: godot-project-foundations
description: "Expert blueprint for Godot 4 project organization (feature-based folders, naming conventions, version control). Enforces snake_case files, PascalCase nodes, %SceneUniqueNames, and .gitignore best practices. Use when starting new projects or refactoring structure. Keywords project organization, naming conventions, snake_case, PascalCase, feature-based, .gitignore, .gdignore."
---

# Project Foundations

Feature-based organization, consistent naming, and version control hygiene define professional Godot projects.

## Available Scripts

### Core Scaffolding (Stateful / Persistent)
- **[project_bootstrapper.gd](scripts/project_bootstrapper.gd)**: Auto-generates feature folders and .gitignore.
- **[runtime_configurator.gd](scripts/runtime_configurator.gd)**: Applies high-performance profiles and saves `override.cfg`.
- **[managed_autoload.gd](scripts/managed_autoload.gd)**: Advanced Singleton pattern with `RefCounted` delegation.
- **[global_event_bus.gd](scripts/global_event_bus.gd)**: **MANDATORY** for decoupled global signals — do not re-inline EventBus samples in chat.
- **[node_pooling_system.gd](scripts/node_pooling_system.gd)**: Thread-safe Object Pool for high-frequency scene instantiation.
- **[async_resource_loader.gd](scripts/async_resource_loader.gd)**: **MANDATORY** for threaded scene transitions — do not re-inline SceneManager samples.

### Runtime Utilities (Stateless / Lightweight)
- **[base_data_resource.gd](scripts/base_data_resource.gd)**: Reactive Resource foundation using `emit_changed()`.
- **[advanced_telemetry_logger.gd](scripts/advanced_telemetry_logger.gd)**: Custom OS-level `Logger` for crash reporting.
- **[threaded_task_worker.gd](scripts/threaded_task_worker.gd)**: Robust `WorkerThreadPool` implementation.
- **[action_buffer_input.gd](scripts/action_buffer_input.gd)**: Foundational `_unhandled_input` buffer.
- **[build_metadata_provider.gd](scripts/build_metadata_provider.gd)**: Native extraction of version and build metadata.
- **[feature_scaffolder.gd](scripts/feature_scaffolder.gd)** / **[scene_naming_validator.gd](scripts/scene_naming_validator.gd)**: Feature folder + naming gates.

> **Do NOT Load** `dependency_auditor.gd` unless troubleshooting loading errors.

## NEVER Do (Expert Anti-Patterns)

### Global Architecture
- **NEVER group by file type** — `/scripts`, `/sprites` folders. Nightmare maintainability. Use feature-based: `/player`, `/ui`.
- **NEVER mix snake_case and PascalCase in files** — Standard: snake_case for files, PascalCase for nodes.
- **NEVER use hardcoded get_node() paths** — Brittle on reparenting. Use `%SceneUniqueNames` for stable references.
- **NEVER use monolithic Autoloads** — Avoid managers that hold visual node references; keep singletons focused on pure data or RefCounted delegation.

### Resource Management
- **NEVER forget .gitignore** — Committing `.godot/` folder = 100MB+ bloat + conflicts.
- **NEVER skip .gdignore for raw assets** — Design source files (`.psd`, `.blend`) in root will be imported unless ignored.
- **NEVER modify globally shared Resources directly** — Strictly call `duplicate(true)` for unique instances with independent state.

### Performance & Threading
- **NEVER block the main thread with `load()`** — Strictly use `ResourceLoader.load_threaded_request()` for async scene transitions.
- **NEVER modify the SceneTree from a background thread** — Strictly use `call_deferred()` for thread-to-main-thread synchronization.
- **NEVER skip Mutex locking during pooled access** — Strictly ensure thread-safety when using a shared `WorkerThreadPool` or Object Pool.
- **NEVER use `_process()` for precise input** — Tied to visual framerate. Strictly use `_unhandled_input()` to capture exact, frame-independent events.

---

## Ownership decision tree

| Need | Prefer | Avoid |
|------|--------|-------|
| Everything for one feature (player, HUD panel) | **Feature folder** scene module | Type folders (`/scripts`, `/sprites`) |
| Cross-scene service with lifecycle (save, audio bus) | **Autoload** via `managed_autoload.gd` | Stuffing UI nodes into singletons |
| Many publishers/subscribers, no ownership | **EventBus** → **MANDATORY** `global_event_bus.gd` | Autoload that imports half the game |
| One scene's private wiring | **Scene-local node** + `%UniqueName` | Global bus for parent→child calls |

---

### 1. Naming Conventions
- **Files & Folders**: `snake_case` (C# exception: PascalCase class-match).
- **Node Names**: `PascalCase`.
- **Exports**: `snake_case`; Inspector Title-Cases them.
- **Private**: leading `_` on members and virtuals (`_ready`, `_process`).
- **Signals**: past-tense `snake_case` (`health_changed`).
- **Unique Names**: `%SceneUniqueNames` over brittle `get_node()` paths.

### 2. Feature-Based Organization
Group by feature (`/entities/player`, `/ui/main_menu`), not by file type. Keep `/common`, `/levels`, `/addons`.

### 3. Version Control
Godot-aware `.gitignore` (ignore `.godot/`) + `.gdignore` on raw design sources.

## Godot 4.7: Foundations

- **Asset Store** replaces Asset Library for third-party content discovery.
- New projects use `canvas_items` + `expand` stretch defaults — account for in UI layout tests.

## Workflow: Scaffolding a New Project

1. Ensure `project.godot` exists → run `project_bootstrapper.gd` / create `entities/`, `ui/`, `levels/`, `common/`.
2. Setup Git `.gitignore` + document feature-based layout in `README.md`.
3. Register lean Autoloads only after the ownership decision tree says so.

## Typed GDScript strictness (foundations-only)

Full typed-GDScript migration lives in [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md).
For new foundations projects: **Project Settings → Debug → GDScript → Untyped Declaration** = `Warn` or `Error`.

## Expert Foundation Architectures

### Scene transitions
**MANDATORY** load [`async_resource_loader.gd`](scripts/async_resource_loader.gd) — threaded `ResourceLoader` with progress. Do not paste SceneManager samples here.

### Global Event Bus
**MANDATORY** load [`global_event_bus.gd`](scripts/global_event_bus.gd) for typed global signals. Do not paste EventBus samples here.

### Project Metadata
Use [`build_metadata_provider.gd`](scripts/build_metadata_provider.gd) / [`base_data_resource.gd`](scripts/base_data_resource.gd) for version/build flags instead of ad-hoc JSON.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Project organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html) — Feature-based folders, `.gdignore`, and VCS hygiene that keep imports and repos maintainable.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Ownership boundaries and why `%SceneUniqueNames` beat brittle `get_node()` paths.
- [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) — Canonical snake_case files / PascalCase nodes / past-tense signals used by this skill’s validators.
- [GDScript warning system](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/warning_system.html) — Enforce typed declarations (`Untyped Declaration` → Warn/Error) when migrating foundations to GDScript 2.0.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — How to register lean global services that survive scene changes.
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — When a Managed Autoload / EventBus is justified vs scene-local ownership.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_*` patterns for non-blocking scene transitions.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Shared vs duplicated Resource instances and why global mutation breaks feature modules.
- [Nodes and scene instances](https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html) — Instantiation, pooling, and scene-as-module boundaries for feature folders.
- [Using SceneTree](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — Tree lifetime, deferred calls, and thread→main synchronization rules.
- [File paths in Godot projects](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — `res://` / `user://` conventions for scaffolded folders and saved `override.cfg` / metadata.
- [ProjectSettings](https://docs.godotengine.org/en/stable/classes/class_projectsettings.html) — Runtime profiles, version strings, and settings keys used by configurators and build metadata.

### Related Skills

#### Prerequisites
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed GDScript, style, and warning-system fluency before enforcing naming and scaffold conventions.

#### Complements
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Boot order and ownership rules for Managed Autoload / EventBus singletons registered from a clean project root.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Feature folders become composable scene modules; parents wire children instead of growing monolithic managers.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Extends `BaseDataResource`-style reactive Resources into full data-driven catalogs without shared mutation.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Typed EventBus signals and connect lifetime once Autoloads and scene ownership are in place.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Threaded loaders and scene swaps build on this skill’s async ResourceLoader boilerplate.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Deepens `_unhandled_input` buffering into full action maps and device routing.

#### Downstream / consumers
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Export presets and feature tags assume a clean folder layout, `.gitignore`, and build metadata hooks.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — Feature-based scenes and deterministic Autoloads make unit/integration harnesses easier to mount.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Custom Logger telemetry and dependency audits feed editor-time diagnostics once structure is stable.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Node pools, WorkerThreadPool, and runtime profiles escalate here when foundations hit CPU/memory ceilings.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting architecture concern.
