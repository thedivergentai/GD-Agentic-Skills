---
name: godot-resource-data-patterns
description: "Expert blueprint for data-oriented design using Resource/RefCounted classes (item databases, character stats, reusable data structures). Covers typed arrays, serialization, nested resources, and resource caching. Use when implementing data systems OR inventory/stats/dialogue databases. Keywords Resource, RefCounted, ItemData, CharacterStats, database, serialization, @export, typed arrays."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Resource & Data Patterns

Resource-based design, typed arrays, and serialization — decision tree + scripts, not Inspector tutorials.

## NEVER Do in Resource Design

- **NEVER modify resource instances directly** — Without `.duplicate()`, changing a value (like HP) modifies the shared `.tres` for everyone.
- **NEVER use untyped arrays in Resources** — `@export var items: Array` allows logic errors. Always use `Array[ResourceClass]` for type safety.
- **NEVER store Node references in Resources** — Objects that only exist in a specific SceneTree cannot be serialized. Store `NodePath` or `UID`.
- **NEVER perform heavy calculations in Resource getters/setters** — Resources should be data containers. Offload logic to Nodes or specialized RefCounted classes.
- **NEVER skip `ResourceSaver.save()` error checks** — Saving can fail due to permissions, disk space, or path issues. Always check the return code.
- **NEVER use Resources for high-frequency runtime data** — If a value changes 60 times a second (like velocity), a standard variable is faster than a Resource property.
- **NEVER allow circular Resource references** — If A.tres references B.tres and B.tres references A.tres, the engine may crash on load.
- **NEVER forget the `_init` defaults** — Resources created via `new()` or in the Inspector need default values in their constructor to be editable.
- **NEVER share a Resource between entities if they need unique state** — Use `resource_local_to_scene = true` or `duplicate()` for components.
- **NEVER use `.tres` for massive datasets** — If you have 10,000 items, a JSON or custom binary format might be more efficient than individualized Resource files.

---

## Decision Tree: Resource vs RefCounted vs Node

| Type | Use when | Disk / Inspector |
|------|----------|------------------|
| `Resource` | Shared definitions, saveable data, `@export` authoring | `.tres`/`.res`, Inspector ✅ |
| `RefCounted` | Temporary runtime calcs, non-persistent helpers | No disk / weak Inspector |
| `Node` | Scene entities with process/signals in the tree | Scene files |

**Use Resources for:** item defs, stats templates, abilities, dialogue tables, enemy configs.
**Use RefCounted for:** damage calc scratchpads, ephemeral state machines, non-saved utilities.

## Available Scripts — MANDATORY by Scenario

| Scenario | MANDATORY read |
|----------|----------------|
| Per-instance mutable stats (HP) sharing a base `.tres` | [resource_local_to_scene.gd](scripts/resource_local_to_scene.gd) |
| Nested Item → Weapon → StatusEffect trees / save whole graph | [nested_resource_serialization.gd](scripts/nested_resource_serialization.gd) |
| Many entities sharing one config (flyweight) | [resource_flyweight_caching.gd](scripts/resource_flyweight_caching.gd) / [flyweight_enemy_config.gd](scripts/flyweight_enemy_config.gd) |
| Custom `@export` data containers | [custom_data_resource.gd](scripts/custom_data_resource.gd) |
| Reactive stats with signals | [character_stats_resource.gd](scripts/character_stats_resource.gd) |
| Inventory arrays of Resources | [resource_based_inventory.gd](scripts/resource_based_inventory.gd) |
| Save Resource trees to disk | [resource_save_system.gd](scripts/resource_save_system.gd) — check `Error` |
| Preload / O(1) cache before play | [resource_preloading_strategy.gd](scripts/resource_preloading_strategy.gd) |
| Runtime `Resource.new()` loot | [dynamic_resource_generation.gd](scripts/dynamic_resource_generation.gd) |
| Validate / pool / factory | [resource_validator.gd](scripts/resource_validator.gd) / [resource_pool.gd](scripts/resource_pool.gd) / [data_factory_resource.gd](scripts/data_factory_resource.gd) |

## Expert Notes (no Pattern 1–5 dump)

- **`.res` vs `.tres`:** prefer binary `.res` in production for speed/size; keep `.tres` for design-time diffs. Nested sub-resources save with the parent via `ResourceSaver`.
- **Cache:** `ResourceLoader.CACHE_MODE_REPLACE` when you must bypass stale cache after external edits.
- **Local-to-scene / duplicate:** mandatory for Health/AI components that share a template but mutate at runtime — see [resource_local_to_scene.gd](scripts/resource_local_to_scene.gd).
- **Broken WeaponData paste-ups:** do not reconstruct nested weapon tutorials here — implement from [nested_resource_serialization.gd](scripts/nested_resource_serialization.gd).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Custom Resource scripts, `.tres`/`.res`, sharing vs `duplicate()`, and `resource_local_to_scene` for per-instance state.
- [Data preferences](https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html) — When to store data in Resources vs dictionaries, ConfigFile, or plain scripts for inspector and serialization needs.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — `duplicate`, `emit_changed`, `resource_path`, and local-to-scene flags used by every data container pattern here.
- [ResourceLoader](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html) — Cached `load` / threaded requests that power flyweight sharing and preload caches.
- [ResourceSaver](https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html) — Persist custom Resources to `user://` or `res://` and always check the returned `Error`.
- [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html) — Lightweight runtime objects when you need refcounting without disk serialization or Inspector exports.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Broader save strategies that pair with ResourceSaver for slot-based `.tres` state.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — Threaded `ResourceLoader` polling so databases and VFX packs do not hitch the main thread.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — Typed `@export` / `Array[T]` so item and quest Resources stay Inspector-safe.
- [Binary serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html) — Compact FileAccess packing when thousands of rows outgrow individualized `.tres` files.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Why shared Resources live outside scene trees and how component scenes compose exported data.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, import, and `res://` hygiene before authoring shared `.tres` databases.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — `class_name`, typed arrays, setters, and `@tool` discipline every custom Resource script depends on.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Ownership and fan-out for Resource `changed` / custom signals that drive reactive UI and stats.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Slot versioning, migration, and secure paths that wrap ResourceSaver/ResourceLoader save flows.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Packed scenes and threaded loads that consume preloaded Resource caches without hitch spikes.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Ability/buff definitions are Resource data; this skill owns the container and serialization patterns.
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Dialogue graphs and line tables are nested Resources that reuse typed-array and save patterns here.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Flyweight sharing, pooling RefCounted payloads, and when `.res` beats text `.tres` at scale.

#### Downstream / consumers
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Item stacks, equipment, and bags consume `ItemData` / inventory Resource arrays defined here.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Generators that instantiate loot, quests, and configs via `Resource.new()` at runtime.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — `.tres` stats and economy tables are the preferred extract source — build the data layer before regex farms.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
