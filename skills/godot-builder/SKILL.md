---
name: godot-builder
description: "Expert-level toolkit for modular Godot 4.7+ CLI automation and headless build orchestration. Use when you need to: (1) Build complex scene trees or UI layouts programmatically, (2) Automate expert 3D asset pipelines (glTF -> Collision), (3) Optimize procedural geometry headlessly (CSG -> Static Mesh), or (4) Engineer production-grade CI/CD pipelines. Set GODOT_PATH env var for custom engine location. Keywords: Godot CLI, headless, CI, export, builder, 4.7."
---

# Godot Builder Skill

The `godot-builder` skill provides an expert-grade foundation for programmatic game development and headless automation using the Godot 4.7-stable CLI. Override paths via `GODOT_PATH` and `GODOT_CONSOLE_PATH` environment variables.

## Expert Automation Mindset

- **Headless Isolation via XDG**: When running multiple concurrent Godot instances, always override `XDG_DATA_HOME` and `XDG_CONFIG_HOME` to prevent cache corruption between instances.
- **Cache Invalidation (Force Import)**: Programmatically delete the `.godot/imported/` directory to force the engine to re-evaluate modified global import settings.
- **Explicit Ownership**: Scene nodes MUST have their `owner` property set to the scene root, or they will be discarded during serialization.
- **Latency-Sensitive Multi-threading**: GPU interactions (textures, image data) must stay on the main thread to avoid pipeline stalls and deadlocks.

## Hardened Anti-Patterns (NEVER List)

- **NEVER** save runtime-generated UIDs headlessly; `ResourceSaver.save()` does NOT serialize UIDs in headless mode. Invoke `godot -e --headless --import` as a post-process.
- **NEVER** use `Resource.duplicate(true)` in Godot 4.4+; use `duplicate_deep(Resource.DEEP_DUPLICATE_ALL)` to prevent procedural state-bleed.
- **NEVER** hardcode `.tscn` or `.tres` extensions; always load via `uid://` or without extensions to avoid failures in exported binary builds.
- **NEVER** execute GPU-bound calls on secondary threads. Use `RenderingServer.call_on_render_thread()`.
- **NEVER** enable the Shader Baker for Dedicated Server builds; the headless backend ignores it.
- **NEVER** call `ResourceUID.set_id()` without calling `has_id()` first; it causes a fatal CLI crash.
- **NEVER** skip `RenderingServer.canvas_item_reset_physics_interpolation()` when programmatically moving low-level CanvasItems on their first frame; failure causes visual desync between rendering and physics systems.

## Expert Automation Workflows

> **Do NOT Load** the full script catalog for a single task. Load only the MANDATORY scripts named in the active workflow. Thin process wrappers (`launch_editor.py`, `run_project.py`, `stop_project.py`, `get_*`, `list_projects.py`) live in the appendix — do not preload them unless that exact CLI action is required.

### Workflow #1: The Hardened 3D Asset Pipeline
**Purpose**: Automates the ingestion of raw 3D assets into production-ready scenes with accurate physics collisions.
- **MANDATORY — read before improvising CLI flags**: [gltf_processor.py](scripts/gltf_processor.py) → [collision_generator.py](scripts/collision_generator.py) → [save_scene.py](scripts/save_scene.py). Then run `godot -e --headless --import` (or [import_automator.py](scripts/import_automator.py)) — do not invent alternate flag orders.
- **Sequence**: `gltf_processor.py` -> `collision_generator.py` -> `save_scene.py` -> headless `--import`.
- **Expert Defense**: Sets explicit `owner` for every node. Forces a final headless import to fix the missing UID serialization.
- **Failure modes / fallbacks**:
  - **UID missing after headless save**: Expected — `ResourceSaver` does not serialize UIDs headless. Fallback: re-run `--import`; if UIDs still missing, run [update_project_uids.py](scripts/update_project_uids.py) after import completes.
  - **Import hangs / never exits**: Script omitted `quit()` or editor import is waiting on GPU. Fallback: ensure the post-process script calls `get_tree().quit()`; kill the PID via [stop_project.py](scripts/stop_project.py) and retry with `XDG_*` isolation.
  - **Collision mesh empty / wrong**: Source glTF had no mesh arrays or wrong node paths. Fallback: inspect [gltf_processor.py](scripts/gltf_processor.py) output scene before regenerating collisions.

### Workflow #2: Procedural Level Optimization & 4.4+ Scaling
**Purpose**: Generates optimized procedural level chunks without shared resource state corruption between instances.
- **MANDATORY — read before improvising**: [csg_optimizer.py](scripts/csg_optimizer.py) → [navmesh_baker.py](scripts/navmesh_baker.py). Apply `duplicate_deep(Resource.DEEP_DUPLICATE_ALL)` between bake steps — do not use `duplicate(true)`.
- **Sequence**: `csg_optimizer.py` -> `duplicate_deep(ALL)` -> `navmesh_baker.py`.
- **Expert Defense**: Uses `duplicate_deep` to isolate materials/resources. Bakes CSG to static geometry before triggering NavMesh pathfinding.
- **Failure modes / fallbacks**:
  - **NavMesh bake on live CSG**: Pathfinding holes / empty regions. Fallback: confirm CSG→static mesh bake finished before [navmesh_baker.py](scripts/navmesh_baker.py).
  - **Material/state bleed across chunks**: Used shallow duplicate. Fallback: re-bake with `DEEP_DUPLICATE_ALL` per instance.
  - **Headless bake hang**: Missing `quit()` after bake. Fallback: add explicit quit; isolate via `XDG_DATA_HOME` / `XDG_CONFIG_HOME`.

### Workflow #3: Production CI/CD & Force-Import Validation
**Purpose**: Validates cross-platform builds and ensures global project settings (VRAM compression) are strictly applied.
- **MANDATORY — read before improvising export flags**: [test_runner.py](scripts/test_runner.py) → [profile_generator.py](scripts/profile_generator.py) → [ci_export_prepper.gd](scripts/ci_export_prepper.gd) → [ci_exporter.py](scripts/ci_exporter.py).
- **Sequence**: `rm -rf .godot/imported` -> `test_runner.py` -> `profile_generator.py` -> `ci_exporter.py`.
- **Expert Defense**: Forces full re-import to validate asset compression. Isolates CI runs via XDG variables. Injects secure keystore paths from environment variables.
- **Failure modes / fallbacks**:
  - **Export preset missing / wrong platform**: `export_presets.cfg` not mutated for the target. Fallback: run [ci_export_prepper.gd](scripts/ci_export_prepper.gd) headlessly before `--export-release`; verify preset name matches CI matrix.
  - **Hung headless CI (no exit)**: Script never called `quit()`. Fallback: always end `-s` scripts with `quit()`; treat non-zero hang as kill + retry with XDG isolation.
  - **UID / import validation fail after cache wipe**: Re-import incomplete. Fallback: re-run `--import`, then [update_project_uids.py](scripts/update_project_uids.py); do not export until import finishes cleanly.

---

## Automation & CI/CD Pipelines (Godot 4.7)

Professional Godot building requires a "Zero-Touch" philosophy for assets and binary exports.

### 1. Programmatic Asset Re-import
- **NEVER** manually select 500 textures to change their compression.
- Use `ConfigFile` to mutate `.import` files and `EditorFileSystem.reimport_files()` to trigger a batch update on the main thread safely.

### 2. Orphan Asset Detection (Slop Scan)
- **NEVER** trust `res://` is clean. Over time, deleted scenes leave behind orphaned textures and sounds that bloat the final build.
- Use `ResourceLoader.get_dependencies()` to recursively trace exactly which assets are linked to your "Main Scene" and flag anything else as slop.

### 3. Headless CI/CD Context
- Use `--headless --script` for versioning tasks (mutating `export_presets.cfg`) before running the final `--export-release`.
- **Tip**: Always call `quit()` at the end of a headless script, or your CI runner will hang indefinitely.

---

## Expert Pipeline Scripts (load on demand)

Primary automation scripts — open only when the matching workflow requires them.

### Scene & Asset Pipelines
- **gltf_processor.py**: Headlessly converts raw `.glb/.gltf` assets into Godot Scenes.
- **collision_generator.py**: Generates `ConcavePolygonShape3D` physics from mesh data.
- **save_scene.py**: Safely packs and persists the current node tree to disk (set `owner` first).
- **csg_optimizer.py**: Bakes procedural CSG boolean operations into static meshes.
- **navmesh_baker.py**: Executes asynchronous headless NavMesh pathfinding baking.
- **tilemap_generator.py**: Procedurally builds TileMapLayer grids from JSON data.
- **ui_assembler.py**: Constructs complex GUI layouts from standardized JSON structures.
- **create_scene.py** / **add_node.py** / **load_sprite.py**: Programmatic scene tree builders.
- **export_mesh_library.py**: Converts 3D scenes into `.meshlib` resources for GridMaps.
- **orphan_asset_scanner.gd**: Recursive dependency tracer for identifying unused resources.

### CI / Import / Export Pipelines
- **ci_exporter.py**: Orchestrates multi-platform release exports headlessly.
- **ci_export_prepper.gd**: Headless versioning script for `export_presets.cfg`.
- **profile_generator.py**: Generates feature profiles for module-stripping optimization.
- **test_runner.py**: Executes headless unit and integration tests (GUT/doctest).
- **import_automator.py** / **asset_reimport_utility.gd**: Batch import enforcement.
- **update_project_uids.py** / **get_uid.py**: UID sync after headless saves.
- **config_compiler.py**: Compiles JSON/CSV data into optimized `.cfg` config files.

### Appendix: Thin Process Wrappers (Do NOT preload)

Convenience CLI only — not expert pipeline prose. Load when you need that exact process action.

- **launch_editor.py** / **run_project.py** / **stop_project.py**: Editor/game process lifecycle.
- **get_debug_output.py** / **get_godot_version.py** / **get_project_info.py** / **list_projects.py**: Read-only project/process introspection.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — `--headless`, `--path`, `-s`/`--script`, `--import`, and `--export-*` flags that every builder wrapper invokes.
- [Exporting projects](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html) — Export presets, CLI release/debug export flow, and why CI must mutate `export_presets.cfg` before `--export-release`.
- [Feature tags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html) — Custom/feature-profile tags used when stripping modules or gating CI smoke paths with `OS.has_feature`.
- [Exporting for dedicated servers](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html) — Headless/server export constraints (no GPU bake assumptions) that pair with CI isolation via XDG vars.
- [Import process](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html) — `.import` + `.godot/imported` lifecycle; why deleting imported cache forces project-wide revalidation.
- [Importing 3D scenes](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html) — glTF→scene pipeline entry before `GLTFDocument`/`ResourceSaver` automation.
- [Available 3D formats](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) — glTF/GLB expectations for headless converters and collision generation.
- [Using CSG tools](https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html) — Why procedural CSG must bake to static meshes before shipping or NavMesh baking.
- [Using NavigationMeshes](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html) — Headless NavMesh bake ownership and region setup after CSG/static geometry lands.
- [ResourceUID](https://docs.godotengine.org/en/stable/classes/class_resourceuid.html) — Safe `has_id`/`set_id`/`uid://` sync after headless saves (UIDs are not serialized by `ResourceSaver` headless).
- [ResourceSaver](https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html) — Pack/save API for programmatic `.tscn` writes; ownership must be set before `PackedScene.pack`.
- [EditorFileSystem](https://docs.godotengine.org/en/stable/classes/class_editorfilesystem.html) — `reimport_files()` for batch import enforcement from `@tool` EditorScripts.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Feature folders, `project.godot` metadata, and VCS ignores must exist before CLI launch/import/export automation.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Headless `SceneTree` workers, typed Resources, and `quit()` lifecycle patterns used by every `-s` script.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — `PackedScene`, UID paths, and deep-duplicate rules that prevent procedural state-bleed across builder runs.

#### Complements
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Platform templates, codesign/keystore, and filter rules that sit on top of `ci_exporter.py` orchestration.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — CSG/GridMap/MeshLibrary authoring that this skill bakes and exports headlessly.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Runtime agents and layer costs that consume NavMeshes produced by `navmesh_baker.py`.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileSet/TileMapLayer conventions for scenes generated by `tilemap_generator.py`.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Container layout rules that `ui_assembler.py` should emit instead of absolute Control positions.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — Collision layers/shapes for trimesh bodies created by `collision_generator.py`.

#### Downstream / consumers
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — GUT/integration suites launched through `test_runner.py` in CI after import/export steps.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when orphan scans, import compression, or export size still miss budgets.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Headless `test_runner` calibration loops for balance sims after builder CI smoke passes.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Consume `get_debug_output.py` logs when headless imports/exports fail without a GUI.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting build/automation concern.

