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

### Workflow #1: The Hardened 3D Asset Pipeline
**Purpose**: Automates the ingestion of raw 3D assets into production-ready scenes with accurate physics collisions.
- **Sequence**: `gltf_processor.py` -> `collision_generator.py` -> `save_scene.py`.
- **Expert Defense**: Sets explicit `owner` for every node. Forces a final headless import to fix the missing UID serialization.

### Workflow #2: Procedural Level Optimization & 4.4+ Scaling
**Purpose**: Generates optimized procedural level chunks without shared resource state corruption between instances.
- **Sequence**: `csg_optimizer.py` -> `duplicate_deep(ALL)` -> `navmesh_baker.py`.
- **Expert Defense**: Uses `duplicate_deep` to isolate materials/resources. Bakes CSG to static geometry before triggering NavMesh pathfinding.

### Workflow #3: Production CI/CD & Force-Import Validation
**Purpose**: Validates cross-platform builds and ensures global project settings (VRAM compression) are strictly applied.
- **Sequence**: `rm -rf .godot/imported` -> `test_runner.py` -> `profile_generator.py` -> `ci_exporter.py`.
- **Expert Defense**: Forces full re-import to validate asset compression. Isolates CI runs via XDG variables. Injects secure keystore paths from environment variables.

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

## Full Modular Skill Index (25 Scripts)

### Project & Process Management
1. **launch_editor.py**: Opens the Godot visual editor for the project.
2. **run_project.py**: Launches the game project in debug or release mode.
3. **get_debug_output.py**: Captures and redirects engine logs to the terminal.
4. **stop_project.py**: Safely terminates a running Godot instance via its PID.
5. **get_godot_version.py**: Retrieves the specific engine version and build info.
6. **list_projects.py**: Recursively scans directories to identify Godot project roots.
7. **get_project_info.py**: Parses `project.godot` to retrieve metadata (display, features).
8. **ci_exporter.py**: Orchestrates multi-platform release exports headlessly.
9. **ci_export_prepper.gd**: Headless versioning script for `export_presets.cfg`.
10. **profile_generator.py**: Generates feature profiles for module-stripping optimization.

### Scene & Dynamic Building
11. **create_scene.py**: Programmatically creates new `.tscn` resource files.
12. **add_node.py**: Instantiates and appends nodes to an existing scene tree.
13. **load_sprite.py**: Dynamically assigns and configures textures for Sprite2D nodes.
14. **save_scene.py**: Safely packs and persists the current node tree to disk.
15. **gltf_processor.py**: Headlessly converts raw `.glb/.gltf` assets into Godot Scenes.
16. **csg_optimizer.py**: Bakes procedural CSG boolean operations into static meshes.
17. **tilemap_generator.py**: Procedurally builds TileMapLayer grids from JSON data.
18. **ui_assembler.py**: Constructs complex GUI layouts from standardized JSON structures.
19. **navmesh_baker.py**: Executes asynchronous headless NavMesh pathfinding baking.
20. **collision_generator.py**: Generates `ConcavePolygonShape3D` physics from mesh data.
21. **orphan_asset_scanner.gd**: Recursive dependency tracer for identifying unused resources.

### Automation & Utilities
22. **get_uid.py**: Retrieves the `uid://` identifier for a specific resource path.
23. **update_project_uids.py**: Re-scans and synchronizes all project resource UIDs.
24. **config_compiler.py**: Compiles JSON/CSV data into optimized `.cfg` config files.
25. **import_automator.py**: Programmatically configures import settings for directory batches.
26. **asset_reimport_utility.gd**: Expert batch re-importer for enforcing project-wide settings.
27. **test_runner.py**: Executes headless unit and integration tests (GUT/doctest).
28. **export_mesh_library.py**: Converts 3D scenes into `.meshlib` resources for GridMaps.

## Reference
- Related: Headless CLI + test_runner calibrate [godot-monte-carlo-balancer](../godot-monte-carlo-balancer/SKILL.md) Phase 7.

