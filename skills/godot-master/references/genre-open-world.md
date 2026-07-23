---
name: godot-genre-open-world
description: "Expert blueprint for open world games including chunk-based streaming (load/unload regions dynamically), floating origin (prevent precision jitter beyond 5000 units), HLOD (hierarchical LOD for distant meshes), persistent state (track entity changes across unloaded chunks), POI discovery systems (compass, markers), and threaded loading (prevent stutters). Use for RPGs, sandboxes, or exploration games. Trigger keywords: open_world, chunk_streaming, floating_origin, HLOD, persistent_state, POI_discovery, threaded_loading."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Open World

Expert blueprint for open worlds balancing scale, performance, and player engagement.

## NEVER Do (Expert Anti-Patterns)

### World & Persistence
- NEVER prioritize Map Size over Density; empty landscapes are poor design. Strictly focus on **Points of Interest (POIs)** within every 30 seconds of travel.
- NEVER save the entire world state; strictly use **Delta Persistence** to record only unique changes (chopped trees, looted chests) to prevent massive save files.
- NEVER load large chunks or scenes synchronously; strictly use **`ResourceLoader.load_threaded_request()`** to prevent "Loading Hitches" and frame freezes.
- NEVER manipulate the active SceneTree directly from a background thread; strictly use **`call_deferred()`** to safely apply background thread chunk instantiations back to the main thread.
- NEVER keep distant, unloaded chunks in memory; strictly `queue_free()` and nullify references to prevent Out-Of-Memory (OOM) crashes.
- NEVER bake massive collision into one mesh; strictly break the world into chunks with local collision regions for efficient physics queries.
- NEVER save high-volume entity states in text formats (.tscn/.json); strictly use **Binary Serialization** (`store_var`) for high-speed I/O.

### Physics & Performance
- NEVER ignore the "Floating Origin" jitter beyond 8,192 units; strictly implement a **World-Shift system** or enable **Large World Coordinates (Double Precision)** in project settings.
- NEVER process physics or AI at extreme distances; strictly use **Spatial Partitioning** to disable logic for entities in far-away, inactive chunks.
- NEVER calculate physics-sensitive state in `_process()`; strictly use `_physics_process()` for deterministic interaction at fluctuating framerates.
- NEVER spawn individual `MeshInstance3D` nodes for massive foliage; strictly use **MultiMeshInstance3D** to batch hundreds of thousands of meshes into a single GPU draw call.
- NEVER move `OccluderInstance3D` nodes at runtime; this forces a CPU BVH rebuild and causes severe micro-stuttering.
- NEVER leave `CSGShape3D` nodes active in exported builds; strictly bake them into static `ArrayMesh` geometry before shipping.
- NEVER compile complex shaders during gameplay; strictly perform "warm-up" during loading or enable project-wide caching.
- NEVER rely solely on automatic mesh decimation; strictly use **VisibilityRange (HLOD)** to substitute complex materials with cheap imposters or completely hide objects at extreme distances.

### Logic & Architecture
- NEVER perform global A* searches across the entire massive world; strictly use `NavigationPathQueryParameters3D` to limit pathfinding to localized active regions.
- NEVER use `find_child()` or deep tree iteration for global state (e.g., Time of Day); strictly use **Scene Groups** (`call_group()`) for optimized broadcasting.
- NEVER synchronize complex Resource types over the network; strictly serialize world changes into primitive Dictionaries or PackedByteArrays.
- NEVER spawn raw `Thread.new()` for chunk I/O when `ResourceLoader.load_threaded_request()` already covers scene streaming — prefer ResourceLoader; custom threads only for non-Resource work with deferred SceneTree apply.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY** by concern (read before implementing):
> - Streaming → [world_streamer.gd](../scripts/genre_open_world_world_streamer.gd) + [async_chunk_loader.gd](../scripts/genre_open_world_async_chunk_loader.gd)
> - Origin → choose one shifter (see decision tree) — [floating_origin_shifter.gd](../scripts/genre_open_world_floating_origin_shifter.gd) or [world_origin_shifter.gd](../scripts/genre_open_world_world_origin_shifter.gd)
> - HLOD → [hlod_visibility_config.gd](../scripts/genre_open_world_hlod_visibility_config.gd) only (no phantom configurator)
> - Far logic gate → [lod_logic_enabler.gd](../scripts/genre_open_world_lod_logic_enabler.gd)

### Original Expert Patterns
- [world_streamer.gd](../scripts/genre_open_world_world_streamer.gd) - Professional-grade chunk management and streaming engine with background threading.
- [floating_origin_shifter.gd](../scripts/genre_open_world_floating_origin_shifter.gd) - Group-based world-offset correction for float precision jitter.

### Modular Components
- [async_chunk_loader.gd](../scripts/genre_open_world_async_chunk_loader.gd) - Background world streaming system using threaded resource loading.
- [world_origin_shifter.gd](../scripts/genre_open_world_world_origin_shifter.gd) - Root+player shift with `reset_physics_interpolation` + shader `world_offset` uniform.
- [hlod_visibility_config.gd](../scripts/genre_open_world_hlod_visibility_config.gd) - Distance-based geometry swapping using VisibilityRange (HLOD).
- [lod_logic_enabler.gd](../scripts/genre_open_world_lod_logic_enabler.gd) - Enable/disable AI/physics processing by distance/chunk activity.
- [multimesh_foliage_manager.gd](../scripts/genre_open_world_multimesh_foliage_manager.gd) - Server-side GPU batching for thousands of landscape entities.
- [binary_save_manager.gd](../scripts/genre_open_world_binary_save_manager.gd) - High-performance serialization for large-scale world persistence.
- [chunk_limited_pathfinder.gd](../scripts/genre_open_world_chunk_limited_pathfinder.gd) - NavigationServer-level query limits to optimize AI in dense worlds.
- [server_prop_spawner.gd](../scripts/genre_open_world_server_prop_spawner.gd) - Extreme optimization using RenderingServer RIDs to bypass SceneTree.
- [dynamic_lod_adjuster.gd](../scripts/genre_open_world_dynamic_lod_adjuster.gd) - Real-time adaptive performance scaling for global mesh LOD.
- [group_weather_broadcaster.gd](../scripts/genre_open_world_group_weather_broadcaster.gd) - Efficient decoupled environmental updates using SceneTree grouping.
- [landscape_height_query.gd](../scripts/genre_open_world_landscape_height_query.gd) - Nodeless physics floor-height queries for large-scale landscapes.

---

## Core Loop
Traverse → Discover POIs → Quest/travel → Persist deltas → Weather/day cycle immersion.

## Decision Tree: Streamer / Origin / HLOD

| Concern | Choose | Script |
|---------|--------|--------|
| Chunk load/unload around player | ResourceLoader threaded + deferred add_child | **MANDATORY** [world_streamer.gd](../scripts/genre_open_world_world_streamer.gd), [async_chunk_loader.gd](../scripts/genre_open_world_async_chunk_loader.gd) |
| Origin: gameplay entities in a group, custom shift policy | Group `"world_entities"` shift | [floating_origin_shifter.gd](../scripts/genre_open_world_floating_origin_shifter.gd) |
| Origin: single world_root + player warp + physics interp + shader offset | Root shifter | [world_origin_shifter.gd](../scripts/genre_open_world_world_origin_shifter.gd) |
| Origin: planetary / >~few×10k units, physics-heavy | **Large World Coordinates** (double-precision build) | Project setting — may still use a shifter for shader/audio sync |
| Distant mesh swap / impostor | VisibilityRange HLOD | **MANDATORY** [hlod_visibility_config.gd](../scripts/genre_open_world_hlod_visibility_config.gd) |
| Disable far AI/physics | Distance/chunk gate | [lod_logic_enabler.gd](../scripts/genre_open_world_lod_logic_enabler.gd) |
| Persist only changes | Binary delta | [binary_save_manager.gd](../scripts/genre_open_world_binary_save_manager.gd) |

**Pick one origin strategy** — do not dual-own `floating_origin_shifter` and `world_origin_shifter` on the same world root.

---

## Architecture (no duplicated Elite dumps)

1. **Streamer** — Active chunk set from player cell; unload with `queue_free`; load via threaded ResourceLoader; instantiate with `call_deferred`. Do not re-inline streamer pseudocode — read the MANDATORY scripts.
2. **Delta state** — Dictionary keyed by chunk id for dead entities / looted chests; write with binary saver when chunks unload.
3. **HLOD** — Proxy mesh `visibility_range_begin`; detail children use `visibility_parent` — configure via [hlod_visibility_config.gd](../scripts/genre_open_world_hlod_visibility_config.gd).
4. **POI / compass** — Density > size; angle map UI from player forward to POI; no need for a second floating-origin code block.

## Common Pitfalls

1. Empty world — density over km² vanity
2. Save bloat — delta-only persistence
3. Far physics — [lod_logic_enabler.gd](../scripts/genre_open_world_lod_logic_enabler.gd)
4. Phantom `hlod_configurator.gd` — does not exist; use [hlod_visibility_config.gd](../scripts/genre_open_world_hlod_visibility_config.gd)

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — ResourceLoader threaded chunk requests so streaming never hitch-stalls the main thread.
- [Large world coordinates](https://docs.godotengine.org/en/stable/tutorials/physics/large_world_coordinates.html) — when floating-origin shifts vs double-precision builds for maps beyond ~8k units.
- [Visibility ranges](https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html) — GeometryInstance3D begin/end + hysteresis for HLOD impostor swaps.
- [Mesh level of detail (LOD)](https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html) — importer auto-LOD and Viewport mesh_lod_threshold for adaptive outdoor quality.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — batching foliage/props into one draw call with spatial partitions for culling.
- [Occlusion culling](https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html) — baked OccluderInstance3D for cities; why not to move occluders at runtime.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — delta persistence patterns for entity changes across unloaded chunks.
- [Binary serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html) — FileAccess.store_var/get_var for compact high-volume world state.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — Thread/Mutex/Semaphore worker patterns used by custom streamers.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — what may run off-thread vs what must be call_deferred onto the SceneTree.
- [Using NavigationPathQueryObjects](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationpathqueryobjects.html) — region-limited NavigationServer3D queries for chunk-scoped AI.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — PhysicsDirectSpaceState3D height/placement queries without per-tile nodes.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, resources, and project settings before streaming PackedScenes and groups.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — GridMap/CSG/occlusion/LOD primitives that open-world chunks and HLOD build on.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — collision layers, space queries, and origin-shift-safe physics for large maps.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed Resources, signals, and deferred/thread handoffs used by streamers and saves.

#### Complements
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — scene packing and load queues that pair with chunk streamers.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — draw-call budgets, MultiMesh partitions, and process throttling at world scale.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationRegion3D baking and path queries limited to active chunks.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — camera distance drives load radii, visibility ranges, and floating-origin thresholds.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — durable delta saves for POI/quest flags when chunks are unloaded.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — origin-shift and weather broadcasts without find_child tree walks.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — POI density, encounter/loot pacing, and travel-time balance across the streamed map.

#### Downstream / consumers
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — quests that reference chunk-scoped entities and discovery markers.
- [godot-genre-sandbox](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md) — player-built worlds that reuse streaming, MultiMesh, and persistence patterns.
- [godot-genre-survival](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md) — exploration/survival loops that inherit open-world streaming and delta state.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
