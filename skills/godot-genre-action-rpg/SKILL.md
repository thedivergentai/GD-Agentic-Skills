---
name: godot-genre-action-rpg
description: "Comprehensive blueprint for Action RPGs including real-time combat (hitbox/hurtbox, stat-based damage), character progression (RPG stats, leveling, skill trees), loot systems (procedural item generation, affixes, rarity tiers), equipment systems (gear slots, stat modifiers), and ability systems (cooldowns, mana cost, AOE). Based on expert ARPG design from Diablo, Path of Exile, Souls-like developers. Trigger keywords: action_rpg, loot_generator, rpg_stats, skill_tree, hitbox_combat, item_affixes, equipment_slots, ability_cooldown, stat_scaling."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Action RPG

Expert blueprint for action RPGs emphasizing real-time combat, character builds, loot, and progression.

## NEVER Do (Expert Anti-Patterns)

### Combat & Progression
- NEVER use linear damage scaling for progression; strictly use an **exponential curve** (e.g., `base * pow(1.15, level)`) to maintain the power fantasy.
- NEVER allow defense stats to stack linearly to 100%; strictly use a **Diminishing Returns** formula (e.g., `armor / (armor + 100.0)`) to prevent invincibility.
- NEVER skip Hit Recovery (Stagger); strictly implement a brief stagger state (0.2s - 0.5s) on significant hits to prevent "floaty" combat.
- NEVER hide critical stats from the player; strictly provide a detailed character sheet for theory-crafting (Crit Chance, Resistance, etc.).
- NEVER make loot drops visually identical; strictly differentiate rarities with color-coded beams (purple/gold) and distinct sound cues.
- NEVER calculate hitboxes, knockbacks, or combat movement in `_process()`; strictly use `_physics_process()` for deterministic results.
- NEVER evaluate exact floating-point equality (==) for combat thresholds; strictly use `is_equal_approx()`.
- NEVER use the ! (NOT) operator in AnimationTree Advance Condition expressions; strictly use explicit boolean equality (`is_walking == false`).

### Technical & Architecture
- NEVER store character stats or massive inventories as Nodes; strictly use **Resource-based data containers** for lightweight memory overhead.
- NEVER forget to call `duplicate()` on shared Resources; modifying one goblin's stats must not affect all other instances.
- NEVER rigidly couple combat detection to specific classes; strictly use **Duck-Typing** (e.g., `if body.has_method(&"take_damage")`) for interaction.
- NEVER rely on the UI SceneTree as the source of truth for inventory; strictly separate data logic from visualization.
- NEVER recalculate stats every frame; strictly trigger recalculation only on gear changes or level-ups.
- NEVER parse massive RPG save files synchronously; strictly offload heavy parsing to the `WorkerThreadPool`.
- NEVER synchronize complex Resource types over the network; strictly serialize changes into primitive Dictionaries or PackedByteArrays.
- NEVER manage character state by coupling child nodes to parent existence; strictly use signals for loose coupling ("Signal Up, Call Down").
- NEVER use standard Strings for high-frequency AI state identifiers; strictly use `StringName` for optimized hash comparisons.

### Performance & AI
- NEVER instantiate/destroy hundreds of objects (projectiles, damage text) per second; strictly use **Object Pooling**.
- NEVER delete active combat entities via `free()`; strictly use `queue_free()` for safe deferred disposal.
- NEVER calculate complex loot drops or parse massive late-game inventories on the main thread; strictly offload heavy RNG rolls and array iterations to the **WorkerThreadPool**.
- NEVER use nested if/elif blocks for complex Boss AI; strictly use a modular **StateMachine** or pattern matching.
- NEVER iterate through the SceneTree for global state changes; strictly use **Signal Groups** (`call_group()`).
- NEVER move `OccluderInstance3D` nodes attached to dynamic characters; this causes CPU BVH rebuild stalls.

---

## Expert Components (scripts/)

> **MANDATORY**: Read the script for the decision below before inventing a CombatController/RPGStats tutorial inline.
> **Do NOT Load** peer genre skills (platformer, racing, etc.) or full inventory/ability deep-dives unless the Skill Chain row requires them — stay on ARPG combat/loot/progression paths.

### Combat & Hit Resolve
- [hitbox_component.gd](scripts/hitbox_component.gd) — **MANDATORY** Area hitbox enable/disable + multi-hit guard.
- [duck_typed_hitbox.gd](scripts/duck_typed_hitbox.gd) — **MANDATORY** `has_method(&"take_damage")` coupling.
- [health_component.gd](scripts/health_component.gd) — HP / death signals as a child component.
- [aoe_physics_query.gd](scripts/aoe_physics_query.gd) — **MANDATORY** PhysicsServer AoE (no Node-per-blast).
- [aoe_group_broadcaster.gd](scripts/aoe_group_broadcaster.gd) — Group fan-out for faction/AoE.
- [combat_event_bus.gd](scripts/combat_event_bus.gd) / [signal_combat_decoupler.gd](scripts/signal_combat_decoupler.gd) / [combat_log_connector.gd](scripts/combat_log_connector.gd) — Decoupled combat buses/logs.
- [damage_label_manager.gd](scripts/damage_label_manager.gd) — **MANDATORY** pooled floating numbers.
- [stat_reduction_solver.gd](scripts/stat_reduction_solver.gd) — Diminishing armor / resist math.

### Stats & Progression
- [base_stat_resource.gd](scripts/base_stat_resource.gd) / [character_stats_resource.gd](scripts/character_stats_resource.gd) — Resource-first attributes.
- [deep_stat_duplicator.gd](scripts/deep_stat_duplicator.gd) / [entity_stat_duplicator.gd](scripts/entity_stat_duplicator.gd) — **MANDATORY** `duplicate(true)` at spawn.
- [leveling_table.gd](scripts/leveling_table.gd) — XP / level curves.
- [cooldown_coroutine.gd](scripts/cooldown_coroutine.gd) — Ability cooldown awaits.

### AI / Animation / Inventory Perf
- [telegraphed_enemy.gd](scripts/telegraphed_enemy.gd) — **MANDATORY** Souls-like wind-ups / AoE tells.
- [hierarchical_state_base.gd](scripts/hierarchical_state_base.gd) — Boss/player combat FSM base.
- [animation_condition_sync.gd](scripts/animation_condition_sync.gd) — AnimationTree Advance Conditions without `!`.
- [high_speed_aggro_broadcaster.gd](scripts/high_speed_aggro_broadcaster.gd) — Localized aggro via groups.
- [threaded_inventory_loader.gd](scripts/threaded_inventory_loader.gd) — **MANDATORY** WorkerThreadPool inventory parse.
- [typed_inventory_storage.gd](scripts/typed_inventory_storage.gd) — Typed item dictionary storage.

---

## Core Loop

`Combat → Loot → Level Up → Build Power → Challenge Harder Content → Repeat`

## Skill Chain

`godot-project-foundations` → `godot-characterbody-2d` → `godot-combat-system` → `godot-rpg-stats` → `godot-inventory-system` → `godot-ability-system` → `godot-quest-system` → `godot-economy-system` → `godot-save-load-systems` → `godot-monte-carlo-balancer`

## Decision Trees (no class dumps)

| Problem | Decision | Script / peer |
|---------|----------|---------------|
| Melee / projectile contact | Area hitbox frames in `_physics_process` | hitbox_component + duck_typed_hitbox |
| Armor stacking feels broken | Diminishing returns, not linear % | stat_reduction_solver |
| Damage numbers hitch | Pool labels | damage_label_manager |
| Shared goblin HP mutates all | Deep duplicate Resources at instance | deep/entity_stat_duplicator |
| Boss nested if/elif | Hierarchical FSM + telegraphs | hierarchical_state_base + telegraphed_enemy |
| AoE costs too much | PhysicsServer queries / groups | aoe_physics_query / aoe_group_broadcaster |
| Late-game bag parse hitch | WorkerThreadPool | threaded_inventory_loader |
| AnimationTree flip flops | Explicit bool Advance Conditions | animation_condition_sync |
| Full loot affix / bag UI | Do NOT re-teach here | godot-inventory-system |
| Hotbar abilities / mana | Do NOT re-teach here | godot-ability-system |
| Modifier stacks / curves | Do NOT re-teach here | godot-rpg-stats |

### Architecture Overview (composition)
Prefer Health/Hitbox child components (godot-composition) over `BaseEnemy` inheritance. UI observes signals; inventory Resources are truth — never the HUD tree.

### Common Pitfalls (short)
- Floaty combat → add hit recovery/stagger.
- Identical loot → rarity beams + SFX (RenderingServer per-instance params OK).
- Frame-rate combat → `_physics_process` only for hit resolve.

## Advanced ARPG Meta-Systems

### 1. Paragon / Infinite Scaling Resource
Keep post-cap power in a duplicated Resource; emit `emit_changed()` on level; never mutate the cached template.

### 2. Shader-Based Loot Beams
Pass rarity color via `RenderingServer.instance_geometry_set_shader_parameter` on a shared shader — avoid material `duplicate()` storms.

### 3. Stat-Snapshot Combat Logging
Buffer Dictionary snapshots; flush periodically to `user://` (never `res://`).

## Reference

> **Progressive disclosure:** Skim Official Documentation only for the APIs you are implementing (Resources, Area/physics queries, signals/groups, AnimationTree, WorkerThreadPool, save). Open Related Skills when wiring combat, stats, inventory, abilities, or balance—do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — ARPG stats, loot affixes, leveling tables, and equipment templates belong in `Resource` assets so designers can author `.tres` data without rewriting combat code.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — Always `duplicate(true)` shared stat/loot templates at spawn so one goblin’s HP or inventory mutation cannot rewrite every instance’s `.tres`.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` / typed Dictionaries drive Inspector-tuned damage, resistances, XP curves, and gear slots that balance without recompiling scripts.
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — Hitbox/hurtbox overlap signals are the engine baseline for real-time melee and projectile contact detection.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — Direct space-state shape/ray queries power high-entity-count AoE and line checks without spawning a Node per blast.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Resolve hitboxes, knockback, telegraphs, and chase ticks in `_physics_process` for fixed-delta combat determinism.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Combat logs, XP grants, boss phases, and HUD damage floats should subscribe to signals instead of hard-referencing fighters.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — Faction aggro and AoE damage should `call_group` / `call_group_flags` rather than walking the SceneTree every frame.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Keep “signals up, calls down”: parents/UI observe combat; managers call into hitboxes and state nodes—never treat the HUD as inventory truth.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — Sync attack/move Advance Conditions with explicit booleans (no `!` in expressions) so combo and stagger states stay reliable.
- [WorkerThreadPool](https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html) — Parse large late-game inventories, loot rolls, and save blobs off the main thread so combat stays at 60 FPS.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist level, gear, skill ranks, and cooldown end timestamps with the rest of progression—never write runtime logs to `res://`.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Autoloads, folder layout, and input/project settings must be solid before stacking combat, inventory, and save systems for an ARPG.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Player/enemy locomotion and `move_and_slide` are the movement substrate under hit recovery, chase, and attack wind-ups.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Stats, affixes, and leveling curves are Resource-first; load this before inventing Node-heavy character sheets.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Combat buses, health_changed, and loot pickup events need clear signal ownership so UI/logs never own combat truth.

#### Complements
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Damage pipelines, hit reactions, and targeting consume hitbox/hurtbox events this genre skill wires into builds and loot.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Exponential damage curves, diminishing armor, and modifier stacks need a dedicated stats/modifier layer.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Equipment slots, rarity tiers, and affix rolls live in inventory data separate from the SceneTree HUD.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Cooldowns, mana costs, and skill-tree grants compose with combat hit resolve for hotbar ARPGs.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Prefer HealthComponent / HitboxComponent children over deep `BaseEnemy` inheritance for modular RPG units.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Boss telegraphs, stagger, and cast/channel states belong in hierarchical FSMs, not nested `if/elif` AI.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After damage curves, loot rarities, and ability costs are tunable, Monte Carlo loadout sims prove DPS/TTK bands before shipping.
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Kill/collect/boss-phase objectives consume the same combat and inventory events this genre loop emits.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Vendor pricing and sink/source loops sit on top of loot rarity and crafting once drops are stable.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Character builds, gear, and skill ranks must round-trip through a durable save schema for long ARPG sessions.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
