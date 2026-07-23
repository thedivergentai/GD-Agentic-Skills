---
name: godot-combat-system
description: "Expert patterns for combat systems including hitbox/hurtbox architecture, damage calculation (DamageData class), health components, combat state machines, combo systems, ability cooldowns, and damage popups. Use for action games, RPGs, or fighting games. Trigger keywords: Hitbox, Hurtbox, DamageData, HealthComponent, combat_state, combo_system, ability_cooldown, invincibility_frames, damage_popup."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Combat System

Component combat pipeline — DamageData → Hitbox/Hurtbox → HealthComponent — not inline Hitbox/Combo/Ability novels.

## NEVER Do

- **NEVER use direct damage references (`target.health -= 10`)** — Bypass armor, resistances, and i-frames. Always `DamageData` + `HealthComponent.take_damage`.
- **NEVER forget invincibility frames (i-frames)** — Multi-hit shapes otherwise tick every physics frame. Apply a short invuln window after a successful hit.
- **NEVER keep hitboxes active permanently** — Enable/disable with AnimationPlayer tracks or timed code; permanent monitoring causes ghost hits.
- **NEVER use groups for physics-based hit filtering** — Prefer collision layers/masks (C++ filter). Groups are secondary logic, not the physics gate.
- **NEVER emit damage signals without a DamageData object** — Raw numbers lose type, source, knockback, and crit context.
- **NEVER use raw strings for elemental damage types** — Use `enum` / `@export_flags` bitfields. String `"physical"` violates this skill’s own contract.
- **NEVER use try/catch to validate targets** — GDScript has no exceptions. Use `has_method(&"take_damage")` / `is` checks.
- **NEVER hardcode hitstun with `OS.delay_msec()`** — Blocks the OS thread. Use tweens / `Engine.time_scale` + `ignore_time_scale` timers.
- **NEVER apply RigidBody impulses in `_process()`** — Use `_physics_process` / `_integrate_forces`.
- **NEVER couple UI lifebars inside the Player script** — Emit `health_changed`; HUD listens.
- **NEVER leave CollisionShapes active on dead entities** — `set_deferred("disabled", true)` on death.
- **NEVER scale CollisionShapes non-uniformly** — Scale the shape resource (`radius`, `size`), not the node transform unevenly.
- **NEVER use instanced Nodes for base combat stats** — Prefer `Resource` / `RefCounted` containers; `duplicate()` per instance.
- **NEVER use standard strings for high-frequency state names** — Prefer `StringName` (`&"attacking"`).
- **NEVER forget `duplicate()` on shared Resource stats** — Shared templates = shared health pools.

---

## Golden Path (MANDATORY)

1. **[damage_data.gd](../scripts/combat_system_damage_data.gd)** — typed `DamageData` Resource with `enum` / flags for damage types (no String elements).
2. **[health_component.gd](../scripts/combat_system_health_component.gd)** — `take_damage` + i-frame gate + `health_changed` / `died` signals.
3. **[hitbox_hurtbox.gd](../scripts/combat_system_hitbox_hurtbox.gd)** / **[hitbox_component.gd](../scripts/combat_system_hitbox_component.gd)** — Area hit delivery into hurtboxes.
4. **[combat_system_patterns.gd](../scripts/combat_system_combat_system_patterns.gd)** — duck-typing, hit-stop, nodeless AoE, frame sync.

**Do NOT** re-inline Hitbox/Health/Combo/Ability tutorials in scenes. Route abilities to [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md); compose components per [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md); FSMs via [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md).

## Decision Tree

| Task | Load | Do NOT Load |
|------|------|-------------|
| Define damage payload | damage_data.gd | String `damage_type` fields |
| HP + i-frames | health_component.gd | Direct `health -= n` |
| Melee/projectile volumes | hitbox_hurtbox.gd / hitbox_component.gd | Permanent monitoring Areas |
| AoE / hit-stop / duck-type | combat_system_patterns.gd | Spawn temp Areas every tick |
| Ability cooldowns / skill bar | godot-ability-system | Inline AbilityManager novels here |
| Combo buffers | godot-input-handling + state machine | Embedding hit logic in `_input` |

## Damage Type Contract (aligned with NEVER)

```gdscript
# From damage_data.gd — prefer this shape everywhere
enum DamageType { PHYSICAL = 1, FIRE = 2, ICE = 4, LIGHTNING = 8, POISON = 16 }

@export_flags("Physical", "Fire", "Ice", "Lightning", "Poison")
var damage_types: int = DamageType.PHYSICAL
```

Hitboxes must pass `DamageData` (or equivalent AttackData built from the same flags), never `"Physical"` strings.

## Available Scripts

- [damage_data.gd](../scripts/combat_system_damage_data.gd) — **MANDATORY** DamageData Resource + type flags.
- [health_component.gd](../scripts/combat_system_health_component.gd) — **MANDATORY** Health + i-frames golden path.
- [hitbox_hurtbox.gd](../scripts/combat_system_hitbox_hurtbox.gd) — **MANDATORY** before Area combat wiring.
- [hitbox_component.gd](../scripts/combat_system_hitbox_component.gd) — 3D Area hitbox companion (flags-aligned).
- [combat_system_patterns.gd](../scripts/combat_system_combat_system_patterns.gd) — **MANDATORY** for AoE / hit-stop / duck-typing.

## Elite Deltas (keep short)

- **Combat telemetry:** batch JSON flushes of DamageData events to `user://` for balance (source, target, flags, amount).
- **Authoritative damage:** clients request; server validates distance/team then applies `take_damage` ([godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md)).
- **Hitbox debug:** `SceneTree.debug_collisions_hint` + distinct debug colors for attack vs hurt volumes.

## Reference

> **Progressive disclosure:** Skim Official Documentation only for the APIs you are implementing (Areas, layers/masks, Resources, signals, timers, animation hit windows). Open Related Skills when wiring adjacent systems—do not preload the whole lattice.

### Official Documentation
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — Hitbox/hurtbox combat is Area overlap detection (`area_entered` / monitoring), not CharacterBody movement queries.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Prefer collision layers/masks for hit filtering; groups are slower and do not replace physics masks for high-frequency combat.
- [Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html) — 2D hit volumes: `monitoring`/`monitorable`, `area_entered`, and layer/mask bits for team/faction filtering.
- [Area3D](https://docs.godotengine.org/en/stable/classes/class_area3d.html) — 3D `HitboxComponent` / hurtbox volumes use the same Area overlap model with 3D layers and shapes.
- [CollisionShape2D](https://docs.godotengine.org/en/stable/classes/class_collisionshape2d.html) — Enable/disable attack shapes with `set_deferred("disabled", …)` so the physics server is not mutated mid-step; never non-uniform-scale the node.
- [PhysicsShapeQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters3d.html) — Nodeless AoE/explosions via `intersect_shape` on `PhysicsDirectSpaceState3D` without spawning temporary Area nodes.
- [AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html) — Drive hitbox active windows from animation tracks (or method calls) so attacks are not permanently monitoring.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Keep `DamageData` / combat stats as data (`Resource` / `RefCounted`), and `duplicate()` shared templates per instance so enemies do not share one health pool.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `health_changed` / `died` / damage events so HUD and VFX subscribe without coupling lifebars into the player script.
- [SceneTreeTimer](https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html) — Hit-stop after `Engine.time_scale = 0` must use `create_timer(..., ignore_time_scale=true)` or the thaw timer freezes with the world.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Interruptible hitstun/flash VFX: kill and recreate tweens on consecutive hits instead of stacking parallel flash animations.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — Authoritative damage: clients request hits; the server validates and confirms via `@rpc` before applying `take_damage`.

### Related Skills

#### Prerequisites
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Area layers/masks, `CollisionShape2D` deferred disable, and space queries are the physics substrate under hitbox/hurtbox filtering.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Damage, health, and death signals need clear ownership so combat components stay decoupled from UI and AI listeners.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Prefer `HealthComponent` / `HitboxComponent` children over baking combat into a monolithic Character script.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — `DamageData`, elemental flags, and combat stats belong in Resource/`RefCounted` data with safe `duplicate()` on spawn.

#### Complements
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Abilities resolve into this skill’s damage/targeting pipeline; keep ability metadata separate from `DamageData`.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Armor, resistances, crit chance, and modifier stacks feed `take_damage` before health is written.
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — Attack animations own hitbox enable windows, cancel frames, and recovery locks for combos.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — IDLE/ATTACKING/BLOCKING/STUNNED combat states belong in a character FSM that gates `can_act`, not ad-hoc bool soup.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Combo buffers and attack actions should call into combat/combo systems from the action map rather than embedding hit logic in input callbacks.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After DamageData, i-frames, cooldowns, and crit curves are tunable, Monte Carlo sims prove DPS/TTK bands before shipping difficulty.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Predicted hits, lag compensation, and authority checks build on the DamageData + server-validate RPC split.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Action-RPG combat loops assemble hitboxes, abilities, stats, and progression genre glue on top of this skill.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.

