---
name: godot-genre-shooter-fps
description: "Expert blueprint for First-Person Shooters: fps_camera_look, fps_movement_logic, hitscan_weapon_query, weapon_bobbing_system, procedural recoil, and FPS NEVER rules. Shared TPS/cover theory links to godot-genre-shooter. Keywords: FPS, movement physics, weapon bobbing, camera sway, hitscan, viewmodel, air control."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Shooter (FPS)

First-person movement, look, viewmodel, and hitscan feel. Shared TPS/cover/soft-lock ownership lives in [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md).

## MANDATORY script reads (start here)

1. [fps_camera_look.gd](scripts/fps_camera_look.gd) — raw `_input` mouse look (yaw/pitch)  
2. [fps_movement_logic.gd](scripts/fps_movement_logic.gd) — accel/friction/air control  
3. [hitscan_weapon_query.gd](scripts/hitscan_weapon_query.gd) — space-state hitscan  
4. [weapon_bobbing_system.gd](scripts/weapon_bobbing_system.gd) — viewmodel bob/sway  

Also: [procedural_recoil_handler.gd](scripts/procedural_recoil_handler.gd), [hitscan_weapon_logic.gd](scripts/hitscan_weapon_logic.gd), [advanced_fps_controller.gd](scripts/advanced_fps_controller.gd), [weapon_state_machine.gd](scripts/weapon_state_machine.gd), [frame_perfect_input.gd](scripts/frame_perfect_input.gd), [bullet_decal_spawner.gd](scripts/bullet_decal_spawner.gd), [weapon_spread_calc.gd](scripts/weapon_spread_calc.gd), [server_projectile_instance.gd](scripts/server_projectile_instance.gd), [player_anim_bridge.gd](scripts/player_anim_bridge.gd).  
`advanced_weapon_controller.gd` is shared theory — keep FPS feel in the scripts above; genre routing for TPS → sibling skill.

## Core Loop

`Move/Look → Aim → Fire (hitscan) → Recoil recover → Acquire`

## NEVER Do (FPS)

### Gunplay & registration
- **NEVER** hit-detect in `_process` — use `_physics_process` + `intersect_ray`.
- **NEVER** apply recoil only to the gun mesh — kick **camera** + bloom/spread.
- **NEVER** trust client damage — server authority + lag compensation.
- **NEVER** forget `exclude` / `add_exception` for the player RID.
- **NEVER** use `==` on float cooldowns — `is_equal_approx`.

### Input & movement
- **NEVER** poll mouse in `_physics_process` — `_input` / `_unhandled_input` for look.
- **NEVER** accumulate look on a raw `Transform3D` — store yaw/pitch floats.
- **NEVER** multiply velocity by `delta` before `move_and_slide()`.
- **NEVER** use `Transform3D.looking_at` for muzzle forward — use `-transform.basis.z`.

### Polish
- **NEVER** single `AudioStreamPlayer` for gunfire — layer mechanical + shot + tail.
- **NEVER** leave decals forever — fade/pool ([bullet_decal_spawner.gd](scripts/bullet_decal_spawner.gd)).
- **NEVER** hardcode weapon stats — WeaponData Resources.
- **NEVER** use plain Strings for hot weapon states — `StringName`.

## Advanced FPS (keep)

### Viewmodel sway / bob
Procedural sine bob + look sway — [weapon_bobbing_system.gd](scripts/weapon_bobbing_system.gd).

### Step-up
Ray forward/down from `step_height` when `is_on_wall()` after `move_and_slide()`; lift to step top for stairs.

### Tactical lean
Roll camera Z + local X offset from `Input.get_axis("lean_left","lean_right")` with lerp.

## Shared weapon theory

Hitscan vs projectile, spray patterns, and net prediction details that are not FPS-rig specific → [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md) + combat/multiplayer complements. Implement FPS fire path via [hitscan_weapon_query.gd](scripts/hitscan_weapon_query.gd) + [procedural_recoil_handler.gd](scripts/procedural_recoil_handler.gd).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — PhysicsDirectSpaceState3D `intersect_ray` patterns for hitscan registration without Area3D ballistics.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — collision layers/masks, layers for player exclude, and physics tick vs visual frame for gunplay.
- [Using 3D transforms](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html) — basis axes and `-transform.basis.z` forward vectors for aim, recoil, and muzzle direction.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — `_input` vs `_physics_process` so mouse look stays zero-latency while movement stays physics-synced.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — relative mouse motion, capture, and screen-center projection for aim rays.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — analog look axes and deadzones that aim-assist friction/magnetism build on.
- [Using decals](https://docs.godotengine.org/en/stable/tutorials/3d/using_decals.html) — Decal node projection for bullet impacts instead of Sprite3D/QuadMesh stickers.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — RPC authority and fire-event patterns for server-validated hitscan without syncing every bullet.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — blend/state machines for idle/aim/fire/reload without `!` in expressions.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — WeaponData Resource stats (damage, recoil, spread) instead of hardcoded class constants.
- [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html) — layered mechanical/shot/tail streams for gunfire weight.
- [Optimization using Servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — RenderingServer RID paths for high-volume visual projectiles without SceneTree spam.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, InputMap actions, and Resource import basics before FPS controllers and WeaponData wiring.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — mouse capture, action buffering, and look vs move split that frame-perfect fire and camera look depend on.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — physics-synced ray/shape queries and exclude RIDs that hitscan registration builds on.

#### Complements
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — FOV punch, lean pivots, and shake stacks that compose with procedural recoil and weapon bob.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — duck-typed damage application and hit-zone multipliers shared with hitscan/projectile confirm paths.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — bus routing and pooled one-shots for layered gunfire without a single shared AudioStreamPlayer.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — authoritative fire RPCs and unreliable movement transfer modes for competitive hit validation.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — client prediction / server reconciliation shells before lag-compensated shot validation.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — StringName fire/reload/idle machines without stringly-typed weapon states.
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — AnimationTree parameters and blend spaces driven by local velocity bridges.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — pooling, Decal budgets, and RenderingServer RID density for bullet visuals and impacts.
- [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md) — broader TPS/hybrid shooter architecture when the project is not FPS-first.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate weapon asymmetry matrices, TTK bands, and bloom/recoil knobs before shipping balance tables.
- [godot-genre-battle-royale](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md) — large-scale relevancy and lag-compensated combat that reuses FPS hitscan/recoil feel inside BR matches.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting FPS concern.
