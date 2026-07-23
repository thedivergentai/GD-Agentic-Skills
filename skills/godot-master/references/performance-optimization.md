---
name: godot-performance-optimization
description: "Expert blueprint for performance profiling and optimization (frame drops, memory leaks, draw calls) using Godot Profiler, object pooling, visibility culling, and bottleneck identification. Use when diagnosing lag, optimizing for target FPS, or reducing memory usage. Keywords profiling, Godot Profiler, bottleneck, object pooling, VisibleOnScreenNotifier, draw calls, MultiMesh."
---
## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Performance Optimization

Profiler-first bottleneck routing to pooling, culling, servers, MultiMesh, and threads — not generic pool tutorials.

## NEVER Do in Performance Optimization

- **NEVER optimize without profiling first** — "I think physics is slow" without data? Premature optimization. ALWAYS use Debug → Profiler (F3) to identify actual bottleneck [20].
- **NEVER use `print()` in release builds** — `print()` every frame = file I/O bottleneck + log spam. Use `@warning_ignore` or conditional `if OS.is_debug_build():` [21].
- **NEVER ignore `VisibleOnScreenNotifier2D` for off-screen entities** — Enemies processing logic off-screen = wasted CPU. Disable `set_process(false)` when `screen_exited` [22].
- **NEVER instantiate nodes in hot loops** — `for i in 1000: var bullet = Bullet.new()` = 1000 allocations. Use object pools, reuse instances [23].
- **NEVER use `get_node()` in `_process()`** — Calling `get_node("Player")` 60x/sec = tree traversal spam. Cache in `@onready var player := $Player` [24].
- **NEVER forget to batch draw calls** — 1000 unique sprites = 1000 draw calls. Use TextureAtlas (sprite sheets) + MultiMesh for instanced rendering [25].
- **NEVER block the main thread for heavy operations** — Avoid `OS.delay_msec()` or long synchronous data processing. Use `WorkerThreadPool` to keep framerates steady.
- **NEVER use complex collision shapes for physics queries** — High-poly convex shapes are expensive to resolve. Prefer simplified primitives (Circle, Rectangle, Box).
- **NEVER forget to disconnect local lambda signals** — Anonymous lambdas connected to global signals can cause memory leaks if the capturing object is freed.
- **NEVER use large textures without VRAM compression** — VRAM is limited. Use **S3TC/BPTC** for desktop (DirectX/Vulkan) and **ETC2** for mobile. Note: Disable compression for Pixel Art to avoid artifacts [13].
- **NEVER perform tree modifications during physics steps** — Adding/removing nodes during `_inter_ray` or `_physics_process` can lock the physics server. Use `call_deferred`.
- **NEVER skip shader pre-warming in the Compatibility renderer** — Unlike Forward+, OpenGL lacks Ubershaders. Pre-instantiate every mesh/VFX in front of the camera for 1 frame behind a loading screen to avoid hitches [21].

---

**Debug → Profiler** (F3)

Tabs:
- **Time**: Function call times
- **Memory**: RAM usage
- **Network**: RPCs, bandwidth
- **Physics**: Collision checks

## Profiler-Tab Decision Tree

> Open **Debug → Profiler** first. **MANDATORY** load only the script for the hot tab/symptom.
>
> **Do NOT Load** every perf script for a single hitch.

| Profiler / symptom | Likely cause | Script |
|--------------------|--------------|--------|
| **Time** — same script hot | Alloc / get_node / process | [object_pool_system.gd](../scripts/performance_optimization_object_pool_system.gd), cache `@onready`; [custom_monitor_profiler.gd](../scripts/performance_optimization_custom_monitor_profiler.gd) |
| **Time** — off-screen AI/VFX | Process while invisible | **MANDATORY** [manual_culling_logic.gd](../scripts/performance_optimization_manual_culling_logic.gd) |
| **Memory** — climbs over time | Leaks / unique resources | [shared_resource_strategy.gd](../scripts/performance_optimization_shared_resource_strategy.gd); pair with debugging orphan tools |
| **Physics** — collision spikes | Query/node RayCast spam | **MANDATORY** [low_level_physics_query.gd](../scripts/performance_optimization_low_level_physics_query.gd) |
| **GPU / draw calls** | Unique sprites/meshes | **MANDATORY** [multimesh_optimizer.gd](../scripts/performance_optimization_multimesh_optimizer.gd) / [multimesh_foliage_manager.gd](../scripts/performance_optimization_multimesh_foliage_manager.gd) / [texture_array_batching.gd](../scripts/performance_optimization_texture_array_batching.gd) |
| SceneTree overhead at scale | Canvas/mesh item spam | **MANDATORY** [rendering_server_direct.gd](../scripts/performance_optimization_rendering_server_direct.gd) |
| Main-thread hitch (gen/parse) | Sync heavy work | **MANDATORY** [worker_thread_pool_manager.gd](../scripts/performance_optimization_worker_thread_pool_manager.gd) |
| Crowd path spikes | Nav agents same frame | [navigation_agent_optimization.gd](../scripts/performance_optimization_navigation_agent_optimization.gd) |
| Custom game metrics | Missing monitors | [custom_performance_monitor.gd](../scripts/performance_optimization_custom_performance_monitor.gd) |

## Available Scripts

### [object_pool_system.gd](../scripts/performance_optimization_object_pool_system.gd)
**MANDATORY** for hot-path spawn/despawn — reuse, do not invent Array pop pools inline.

### [manual_culling_logic.gd](../scripts/performance_optimization_manual_culling_logic.gd)
VisibilityNotifier-driven process disable for CPU-heavy off-screen entities.

### [rendering_server_direct.gd](../scripts/performance_optimization_rendering_server_direct.gd)
RenderingServer canvas/mesh path when SceneTree overhead dominates.

### [low_level_physics_query.gd](../scripts/performance_optimization_low_level_physics_query.gd)
Direct space-state queries vs hundreds of RayCast nodes.

### [worker_thread_pool_manager.gd](../scripts/performance_optimization_worker_thread_pool_manager.gd)
WorkerThreadPool offload for heavy jobs.

### [multimesh_optimizer.gd](../scripts/performance_optimization_multimesh_optimizer.gd) / [multimesh_foliage_manager.gd](../scripts/performance_optimization_multimesh_foliage_manager.gd)
Hardware instancing for dense meshes/foliage.

### [texture_array_batching.gd](../scripts/performance_optimization_texture_array_batching.gd)
Texture2DArray batching to cut material switches.

### [shared_resource_strategy.gd](../scripts/performance_optimization_shared_resource_strategy.gd)
Shared vs local-to-scene memory tradeoffs.

### [navigation_agent_optimization.gd](../scripts/performance_optimization_navigation_agent_optimization.gd)
Staggered path updates for crowds.

### [custom_monitor_profiler.gd](../scripts/performance_optimization_custom_monitor_profiler.gd) / [custom_performance_monitor.gd](../scripts/performance_optimization_custom_performance_monitor.gd)
`Performance.get_monitor` / custom monitors for game-specific spikes.

## Expert Pointers (keep short)

- Compatibility renderer: pre-warm pipelines (hidden camera + unique meshes/materials one frame). Forward+/Mobile: Ubershaders still need instantiate-once detection.
- VRAM: S3TC/BPTC desktop, ETC2 mobile; skip compression for pixel art.
- AStar/path budgets belong in [navigation_agent_optimization.gd](../scripts/performance_optimization_navigation_agent_optimization.gd) — do not paste thrashy queue snippets as the golden path.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [General optimization](https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html) — profiler-first workflow so you measure Time/Memory/Physics before changing code.
- [CPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html) — process cost, node lookups, allocations, and why hot-path patterns dominate frame time.
- [GPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html) — draw calls, overdraw, and VRAM compression choices that cut render cost.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — hardware instancing for thousands of meshes and why spatial splits restore culling.
- [Using Servers and Resources](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — RenderingServer/PhysicsServer direct APIs when SceneTree overhead is the bottleneck.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — WorkerThreadPool task model for heavy work off the main thread.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — which engine APIs are safe from worker tasks versus SceneTree-only calls.
- [Pipeline compilations](https://docs.godotengine.org/en/stable/tutorials/performance/pipeline_compilations.html) — shader/pipeline hitch causes and pre-warm strategies per renderer.
- [Optimizing 3D performance](https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html) — LOD, cull distances, and mesh complexity budgets for 3D scenes.
- [Occlusion culling](https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html) — OccluderInstance3D tradeoffs when frustum culling alone is not enough.
- [Performance](https://docs.godotengine.org/en/stable/classes/class_performance.html) — built-in monitors plus custom metrics for game-specific bottleneck dashboards.
- [Optimizing Navigation Performance](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html) — agent update budgets and bake costs for large crowds.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, resources, and import basics required before profiling or pooling patterns make sense.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed hot paths, callables, and @onready caching that keep optimization scripts correct.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — shared vs local-to-scene resource ownership that drives memory and unique-instance tradeoffs.

#### Complements
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — collision layers, queries, and body counts that show up as Physics profiler spikes.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — 3D shape cost and RigidBody budgets when optimizing simulation-heavy scenes.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — direct space-state query patterns that replace heavy RayCast node stacks.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — material/shader complexity and Texture2DArray batching that reduce GPU state changes.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — threaded loads and scene packing that prevent hitch spikes during streaming.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — agent path budgets and async bake that pair with staggered AI updates.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — GridMap/LOD/occlusion level layout that sets the ceiling for draw-call budgets.

#### Downstream / consumers
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — resolution/shader fallbacks and battery modes that apply these budgets on weaker GPUs.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — export presets and renderer choices where compression and Compatibility pre-warm matter.
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — chunk streaming and HLOD systems that consume MultiMesh, culling, and thread-pool patterns at scale.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
