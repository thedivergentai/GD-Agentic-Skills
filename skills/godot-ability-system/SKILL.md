---
name: godot-ability-system
description: "Expert patterns for RPG/action ability systems including cooldown strategies, combo systems, ability chaining, skill trees with prerequisites, upgrade paths, and resource management. Use when implementing unlockable abilities, character progression, or complex skill systems. Trigger keywords: PlayerAbility, AbilityManager, cooldown, SkillTree, SkillNode, prerequisites, can_use, execute, ComboSystem, ability_chain, global_cooldown, charge_system, upgrade_path."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Ability System

Resource abilities + scene-scoped managers — not AbilityManager / skill-tree novels.

## Architecture Decision: Where Does the Manager Live?

| Scope | Policy | Script |
|-------|--------|--------|
| Per character / enemy / turret | **Scene-scoped manager as child** (default) | [ability_manager.gd](scripts/ability_manager.gd) or composition [ability_container.gd](scripts/ability_container.gd) on the entity |
| Shared unlock / loadout catalog across scenes | Autoload **catalog / progression only** (ranks, unlock flags) — not live cast state | Thin Autoload data; casts still go through the entity manager |
| Global "cast any ability anywhere" Autoload | **Avoid** | Breaks encapsulation and multiplayer authority |

**Resolved policy:** Live cooldowns, GCD, and `execute()` run on a **scene-scoped** AbilityManager / AbilityContainer under the caster. Autoloads may store unlock ranks; they must not be the combat cast oracle. Skill-tree UI reads/writes progression data, then calls into the caster’s manager — never `/root/AbilityManager.use_*` for combat.

## NEVER Do

- **NEVER tick cooldowns / status durations in `_process()`** — Use `_physics_process(delta)` or one-shot Timers so cooldowns stay deterministic under frame spikes.
- **NEVER forget global cooldown (GCD)** when design needs anti-spam — Small shared lock (0.5–1.5s) between casts when required.
- **NEVER hardcode ability effects in the manager** — Strategy: each ability is a Resource / node with `execute()` ([ability_resource.gd](scripts/ability_resource.gd)).
- **NEVER allow casts during animation lock** — Gate on `is_casting` / anim signals.
- **NEVER save remaining cooldown floats without time normalization** — Persist absolute end timestamps (`Time.get_unix_time_from_system() + remaining`).
- **NEVER put live combat cast state in a global Autoload** — Scene-scoped manager (see decision table). Progression Autoloads are fine.
- **NEVER blindly ban or blindly require object pools** — GDScript refcounting makes pool-optional for light VFX; **do** pool when spawn/despawn of projectiles/AoE is high-frequency or allocation shows up in the profiler. Prefer instantiate/`queue_free` until measured otherwise.
- **NEVER grow deep ability inheritance trees** — Compose Resources + containers ([godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md)).

---

## Golden Path (MANDATORY)

1. [ability_resource.gd](scripts/ability_resource.gd) — data + virtual `execute()`
2. [ability_manager.gd](scripts/ability_manager.gd) **or** [ability_container.gd](scripts/ability_container.gd) — scene-scoped cast/cooldown
3. [buff_stat.gd](scripts/buff_stat.gd) — when buffs/modifiers exist
4. Damage resolution → [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md)

**Do NOT** paste inline AbilityManager / ComboSystem / SkillTreeManager novels into scenes. Skill trees are progression UI + prerequisite graphs that grant Resources to the caster’s container.

## Available Scripts

- [ability_resource.gd](scripts/ability_resource.gd) — **MANDATORY** before new abilities
- [ability_manager.gd](scripts/ability_manager.gd) — **MANDATORY** Resource-driven cooldown registry (scene-scoped)
- [ability_container.gd](scripts/ability_container.gd) — **MANDATORY** alternative: node/Timer composition per ability
- [buff_stat.gd](scripts/buff_stat.gd) — modular buff stats (Do NOT Load if no buffs)

## Cooldown & Status Timing Contract

- Cooldown registry updates and status `process_tick` must use **physics-frame** delta (`_physics_process`) or `Timer` nodes owned by the container.
- Hit detection from abilities stays on the physics tick when applying impulses / queries.
- UI may read cooldown progress in `_process`; it must not own the truth.

## Expert Techniques (short)

- **Dependency injection:** parents inject caster context; abilities do not `get_node("/root/Player")`.
- **Duck-typed hits:** `has_method(&"take_damage")` / combat DamageData — see combat skill.
- **AoE:** `call_group` or space queries; do not scan the whole tree each cast.
- **Networking:** predict locally, authority validates `can_use` + costs ([godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md)).
- **Skill-tree visualizer:** `@tool` GraphEdit for design-time graphs; runtime still grants Resources to scene managers.

## Reference

> **Progressive disclosure:** Skim Official Documentation only for the APIs you are implementing (Resources, timers, signals, save, multiplayer). Open Related Skills when wiring adjacent systems—do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Ability definitions, buffs, and status effects should be `Resource` data (not hardcoded manager switches) so designers can author and share assets.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — Use `duplicate(true)` when applying a status/buff template at runtime so one character’s ticking state cannot mutate the shared `.tres` for everyone.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` / `@export_group` power Inspector-tuned costs, cooldowns, prerequisites, and effect arrays on ability Resources.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `ability_cast`, `ability_ready`, and cooldown lifecycle signals so UI and VFX subscribe without coupling to AbilityManager internals.
- [Scene organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html) — Keep “signals up, calls down”: parents/UI listen; managers call into ability Resources/nodes rather than reaching globally for combat state.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Tick cooldowns and GCD in `_physics_process` (fixed delta); avoid `_process` for cooldown math that desyncs under frame spikes.
- [Timer](https://docs.godotengine.org/en/stable/classes/class_timer.html) — One-shot `Timer` children are a clean composition pattern for per-ability cooldowns in container-style managers.
- [SceneTreeTimer](https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html) — `create_timer()` / await patterns fit cast times and short buff durations without adding persistent Timer nodes for every cast.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — AoE abilities should `call_group` (or query groups) instead of hand-rolled scene scans for every hit target.
- [Time](https://docs.godotengine.org/en/stable/classes/class_time.html) — Persist cooldown *end* timestamps (`get_unix_time_from_system()` + remaining), not raw remaining floats, across save/load.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Serialize ability unlock ranks and absolute cooldown end times with the rest of player progression data.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — Authoritative cast validation + `@rpc` confirmation/cancel is the engine baseline for predicted ability casts.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Abilities, buffs, and skill-tree nodes are Resource-first; load this before inventing custom serialization or inheritance trees for ability data.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Cast/ready/cooldown signals and UI hooks depend on disciplined signal ownership so AbilityManager stays decoupled from characters and HUD.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Prefer AbilityContainer / component nodes over deep `BaseAbility → MagicAbility → FireAbility` inheritance for runtime behavior.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Virtual `execute()` / `can_cast()`, typed Resources, and await-on-timer cast flows assume solid GDScript patterns.

#### Complements
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Damage, hit reactions, and targeting pipelines consume ability `execute()` results; keep DamageData separate from ability metadata.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Mana/stamina costs, stat bonuses from skill ranks, and buff multipliers need a consistent stats/modifier layer.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Hotbar / action-map input should call `can_use` / `use_ability` rather than embedding cooldown logic in input callbacks.
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — Animation lock and cast telegraphs gate ability spam; wire AnimationPlayer start/finish into `is_casting`.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Cast, channel, and interrupt states belong in a character state machine that asks the ability manager, not the other way around.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Skill ranks, unlock flags, and absolute cooldown end times must round-trip through the project save schema.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After cooldowns, costs, and damage/effect Resources are tunable, Monte Carlo loadout sims prove ability DPS/uptime bands before shipping curves.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Predicted casts, authority checks, and rollback of failed RPCs build on the ability manager’s can_use / execute split.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Action-RPG skill bars, skill trees, and ability chaining assemble this skill with combat, stats, and progression genre glue.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Consumable scrolls, skill books, and equipment that grants abilities bridge inventory grants into AbilityManager registration.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
