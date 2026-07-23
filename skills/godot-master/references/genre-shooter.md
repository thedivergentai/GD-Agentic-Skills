---
name: godot-genre-shooter
description: "Expert blueprint for TPS/hybrid shooters: soft-lock aim assist, cover validation rays, SpringArm TPS camera, and genre routing to FPS sibling for viewmodel/hitscan feel. Use for third-person/cover shooters and hybrids. Keywords: TPS, soft_lock, cover, SpringArm3D, hybrid shooter, aim assist — not FPS-only movement."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Shooter (TPS / Hybrid)

**Ownership:** third-person, hybrid, and shared genre routing (cover, soft-lock, spring-arm camera).  
**Not owned here:** FPS movement, viewmodel bob, FPS camera look, FPS-only hitscan/recoil dumps — use [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md).

## Core Loop

`Engage → Aim (soft-lock/cover) → Fire → Confirm → Acquire Next`

## NEVER Do (TPS / hybrid)

- **NEVER put FPS viewmodel/bob/look recipes in this skill** — route to shooter-fps.
- **NEVER use `_process()` for hit registration** — `_physics_process` + space-state queries.
- **NEVER trust the client for authoritative hits** — server validate / rewind.
- **NEVER use Area3D overlap for bullets** — ray / shape queries.
- **NEVER hardcode weapon stats in logic** — `WeaponData` Resources.
- **NEVER skip excluding the shooter's RID** on queries.
- **NEVER use TCP for shooter net sync** — ENet/UDP.

## MANDATORY scripts (non-FPS paths)

> Read before implementing the matching system:

1. [soft_lock_aim_assist.gd](../scripts/genre_shooter_soft_lock_aim_assist.gd) — controller/hybrid assist & sticky aim  
2. [cover_validator_rays.gd](../scripts/genre_shooter_cover_validator_rays.gd) — cover / peek validity rays  
3. [tps_camera_spring_arm.gd](../scripts/genre_shooter_tps_camera_spring_arm.gd) — SpringArm3D TPS camera collision  

Also available: [advanced_weapon_controller.gd](../scripts/genre_shooter_advanced_weapon_controller.gd) (shared weapon controller — prefer FPS skill for FPS feel), [shooter_patterns.gd](../scripts/genre_shooter_shooter_patterns.gd), [projectile.gd](../scripts/genre_shooter_projectile.gd).

## Decision trees

### Camera / stance
| Need | Action |
|---|---|
| Over-shoulder TPS | [tps_camera_spring_arm.gd](../scripts/genre_shooter_tps_camera_spring_arm.gd) |
| Cover check before peek-fire | [cover_validator_rays.gd](../scripts/genre_shooter_cover_validator_rays.gd) |
| Soft-lock / assist | [soft_lock_aim_assist.gd](../scripts/genre_shooter_soft_lock_aim_assist.gd) |
| True FPS digsite | → [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) |

### Fire mode
| Need | Action |
|---|---|
| Hitscan / projectile theory | Shared WeaponData + space-state; FPS implementation details in shooter-fps |
| Pooled projectiles | [projectile.gd](../scripts/genre_shooter_projectile.gd) / patterns script |
| Explosion radius | ShapeCast3D pattern in [shooter_patterns.gd](../scripts/genre_shooter_shooter_patterns.gd) |

### Net
| Need | Action |
|---|---|
| Client juice | Predict tracers locally |
| Damage | Server authoritative; show no-reg on mismatch |

## Weapon selection (short)

Hitscan for hitscan rifles/SMGs; physical projectiles for rockets/arrows; Resource archetypes for balance — tune in `.tres`, not node scripts.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — `PhysicsDirectSpaceState3D.intersect_ray` hitscan queries, exceptions, and collision masks for frame-rate-independent fire.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — layers/masks, `_physics_process` timing, and body types that keep hit registration deterministic.
- [PhysicsDirectSpaceState3D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html) — direct `intersect_ray` / `intersect_shape` for high-frequency shots without RayCast3D node overhead.
- [PhysicsRayQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html) — from/to, exclude RIDs, and collision_mask for shooter-owned hitscan queries.
- [CharacterBody3D](https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html) — `move_and_collide` projectile bodies with gravity, bounce, and lifetime.
- [SpringArm](https://docs.godotengine.org/en/stable/tutorials/3d/spring_arm.html) — collision-aware TPS camera boom and shoulder offset without clipping into cover.
- [Using decals](https://docs.godotengine.org/en/stable/tutorials/3d/using_decals.html) — perspective-correct bullet holes and impact marks instead of Sprite3D billboards.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — stick look input that aim-assist friction/magnetism modulates.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — RPC authority and unreliable modes for fire events with server-validated hits.
- [Camera3D](https://docs.godotengine.org/en/stable/classes/class_camera3d.html) — FOV punch, aim rays from `-global_basis.z`, and `h_offset` for TPS shoulder swap.
- [PhysicsShapeQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters3d.html) — sphere/shape queries for rocket/grenade AoE without Area3D spam.
- [AudioStreamPlayer3D](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer3d.html) — layered shot/mechanical/tail players for punchy spatial gunfire.

### Related Skills

#### Prerequisites
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — CharacterBody3D/RigidBody3D, collision layers, and direct space queries that hitscan and projectiles depend on.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — look/fire/reload action maps and gamepad stick curves before aim assist and recoil kick.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — FPS/TPS camera rigs, FOV, and SpringArm patterns that weapon kick and soft-lock rotate.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Resource-based WeaponData, scene structure, and import defaults before balancing archetypes.

#### Complements
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — damage events, hit zones, and health pipelines that consume shooter `take_damage` results.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — reusable ray/shape query helpers for cover checks, LOS, and hitscan without duplicating query setup.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — bus routing and 3D attenuation for mechanical + shot + reverb-tail gunfire layers.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — ENet peers, RPC modes, and authority so fire is predicted client-side and damage is server-validated.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — prediction, reconciliation, and lag-compensation shells around hitscan validation.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — muzzle flash, tracers, and impact bursts that sell gunplay without blocking the fire path.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate TTK, spray patterns, and weapon asymmetry matrices so archetype damage/recoil stay competitive.
- [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — FPS-specialized movement and viewmodel polish that builds on this genre gunplay lattice.
- [godot-genre-battle-royale](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md) — large-scale matches that reuse hitscan/projectile combat inside drop/zone loops.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
