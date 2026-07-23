---
name: godot-scene-management
description: "Expert blueprint for scene loading, transitions, async (background) loading, instance management, and caching. Covers fade transitions, loading screens, dynamic spawning, and scene persistence. Use when implementing level changes OR dynamic content loading. Keywords scene, loading, transition, async, ResourceLoader, change_scene, preload, PackedScene, fade."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Scene Management

Async loading, transitions, instance pooling, and caching define smooth scene workflows.

## Available Scripts

> **MANDATORY triggers below** — read the matching script; do not paste incomplete Autoload loaders.

- [async_scene_manager.gd](scripts/async_scene_manager.gd) — **MANDATORY** before loading screens / threaded level swaps (`THREAD_LOAD_FAILED` included).
- [background_resource_loader.gd](scripts/background_resource_loader.gd) — **MANDATORY** when preloading the *next* level during gameplay (hitch avoidance).
- [scene_transition_manager.gd](scripts/scene_transition_manager.gd) — Fade/wipe Tweens wrapping a safe change.
- [scene_pool.gd](scripts/scene_pool.gd) — **MANDATORY** before frequent spawn/despawn (bullets, enemies, VFX).
- [scene_instancing_pooling.gd](scripts/scene_instancing_pooling.gd) — Pool fill / reclaim patterns.
- [additive_ui_layering.gd](scripts/additive_ui_layering.gd) — Menus/overlays without destroying the world scene.
- [subviewport_scene_layering.gd](scripts/subviewport_scene_layering.gd) — Parallel worlds / minimaps (`SubViewport` input plan required).
- [persistent_data_preservation.gd](scripts/persistent_data_preservation.gd) — Autoload / root holders across swaps.
- [scene_state_manager.gd](scripts/scene_state_manager.gd) — Persist-group save/restore across transitions.
- [node_unparent_reparent.gd](scripts/node_unparent_reparent.gd) — Transform-preserving reparent (never mid-physics blindly).
- [node_path_safe_retrieval.gd](scripts/node_path_safe_retrieval.gd) — `%UniqueName` / guarded `@onready`.
- [dynamic_script_attachment.gd](scripts/dynamic_script_attachment.gd) — Runtime script attach for mods/dynamic entities.

## NEVER Do in Scene Management

- **NEVER load large scenes synchronously** — `load("res://large_scene.tscn")` on the Main Thread causes "hiccups" or full freezes during level transitions. Use `ResourceLoader.load_threaded_request()` for async loading with a progress bar.
- **NEVER use `get_tree().change_scene_to_file()` for transient state** — This method purges the current scene and all its local variables. Use an **Autoload (Singleton)** or a persistent 'Game' node to store state across levels.
- **NEVER instance 100+ identical nodes per frame** — Use **Object Pooling** to reuse bullets, debris, or enemies. Constant `instantiate()` and `queue_free()` calls spike CPU and trigger the Garbage Collector too often.
- **NEVER hardcode `get_node("../../Path/To/Node")`** — These paths break as soon as you move a node in the editor. Use **Scene Unique Names** (`%NodeName`) or `@export var target_node: Node` for robust references.
- **NEVER reparent nodes mid-physics-step without care** — Reparenting can cause one-frame transform "teleports". Always store the `global_transform` and re-apply it after the `add_child()` call.
- **NEVER rely on the SceneTree for 10,000+ objects** — If you don't need SceneTree features (signals, per-node scripts), use `PhysicsServer` and `RenderingServer` directly for raw performance.
- **NEVER forget to handle `NOTIFICATION_WM_CLOSE_REQUEST`** — On desktop, if you don't handle the close request in a persistent node, the game may close during a critical save operation.
- **NEVER use deep recursion for node cleanup** — `queue_free()` is natively recursive in Godot 4. Freeing the root node automatically cleans up all children. Manual loops are redundant and inefficient.
- **NEVER mix `SubViewport` and main world inputs without a plan** — By default, input events bubble up. Use `set_input_as_handled()` to prevent UI clicks in a subviewport from triggering gameplay in the main world.
- **NEVER use `change_scene` to "Reset" a level** — It reloads everything from disk. For a quick respawn, just reset the variables and move the player to the start position.

---

## Decision Tree: How to Change Content

| Goal | Prefer | MANDATORY script |
|------|--------|------------------|
| Full level swap with progress UI | Threaded load → swap when `THREAD_LOAD_LOADED` | [async_scene_manager.gd](scripts/async_scene_manager.gd) |
| Hide hitch before a door/trigger | Start threaded request early during play | [background_resource_loader.gd](scripts/background_resource_loader.gd) |
| Fade / wipe around a swap | Transition Autoload wraps the manager | [scene_transition_manager.gd](scripts/scene_transition_manager.gd) |
| Keep world; show pause/map/inventory | Additive UI layer (do not `change_scene`) | [additive_ui_layering.gd](scripts/additive_ui_layering.gd) |
| Manual root swap / deferred free | Own current_scene lifecycle | Peer docs + `safe` patterns in `godot-autoload-architecture` |
| Spawn many identical actors | Pool, never raw instantiate/free storms | [scene_pool.gd](scripts/scene_pool.gd) / [scene_instancing_pooling.gd](scripts/scene_instancing_pooling.gd) |
| Minimap / split render | `SubViewport` + update mode + input isolation | [subviewport_scene_layering.gd](scripts/subviewport_scene_layering.gd) |
| Survive scene purge | Autoload / persist group — not locals | [persistent_data_preservation.gd](scripts/persistent_data_preservation.gd) / [scene_state_manager.gd](scripts/scene_state_manager.gd) |
| Quick respawn | Reset state + teleport — **not** `change_scene` | — |
| DLC / hot patch scenes | `ProjectSettings.load_resource_pack` then load path | (PCK) see Official Docs |

## Expert Patterns (staging / integrity)

- **Pool pre-fill** during loading screens (`PROCESS_MODE_DISABLED` + hide) — absorb instantiate cost up front via `scene_pool.gd`.
- **Background staging** — `load_threaded_request` mid-gameplay; transition only when loaded (`background_resource_loader.gd`).
- **PCK overrides** — mount pack, then `change_scene`/`load` the same `res://` path for patched content.
- **Orphan audit** — after swaps, check `Performance.OBJECT_ORPHAN_NODE_COUNT` / `Node.print_orphan_nodes()`.
- **Cleanup** — `queue_free()` on a root is recursive; no manual child loops.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_request` / status polling for hitch-free level loads and progress bars.
- [Change scenes manually](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html) — Deferred free + root reparent patterns behind safe switchers (prefer over blind `change_scene_to_file` for staged transitions).
- [Using SceneTree](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — `current_scene`, pause, groups, and how the tree relates to Autoload root children across swaps.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Ownership edges so loaders/UI layers do not become God Objects when nesting sub-scenes.
- [Nodes and scene instances](https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html) — `PackedScene.instantiate()`, ownership, and when to preload vs load at runtime.
- [Scene unique nodes](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_unique_nodes.html) — `%Name` references that survive hierarchy edits better than brittle `get_node("../../…")` paths.
- [Autoloads versus regular nodes](https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html) — Keep cross-scene state in singletons; keep level content in scenes the tree can unload.
- [Using Viewports](https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html) — `SubViewport` worlds for minimaps, split-screen, and layered rendering without swapping the main scene.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — Persist-group save/restore and bulk cleanup across scene transitions.
- [Exporting packs, patches, and mods](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html) — `ProjectSettings.load_resource_pack` for DLC/mod scene overrides on `res://` paths.
- [ResourceLoader](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html) — Threaded load API surface (`load_threaded_*`, `exists`) used by async managers.
- [PackedScene](https://docs.godotengine.org/en/stable/classes/class_packedscene.html) — Scene resource type for pooling, `change_scene_to_packed`, and instance caches.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, scene tree basics, and import paths loaders and Autoload registries assume.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed signals, `await`, and process-frame polling required by threaded load loops and transition staging.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Singleton boot order and ownership so Game/state holders survive `change_scene` without becoming God Objects.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Reconnect or bus-emit after swaps so loaders do not leave ghost listeners on freed scenes.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Level registries and payload Resources that map IDs to `.tscn` paths instead of hardcoded strings.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Serialize persist-group / Autoload state; scene swaps must not invent a second save path.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Fade and wipe Tweens that wrap scene changes without blocking the load thread.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Loading screens and additive menu layers parented under persistent UI roots.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Pool budgets, orphan-node monitors, and when SceneTree should yield to servers for dense spawns.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Component scenes and ownership edges that keep instanced gameplay pieces swappable without path coupling.

#### Downstream / consumers
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — Chunk streaming and background preloads built on threaded `ResourceLoader` queues from this skill.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — PCK/patch packaging that supplies the runtime packs scene patchers mount.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Authority-aware scene spawns and late-join sync that reuse pooling and safe change patterns.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns loading vs persistence vs UI.
