---
name: godot-genre-battle-royale
description: "Expert blueprint for Battle Royale games including shrinking zone/storm mechanics (phase-based, damage scaling), large-scale networking (relevancy, tick rate optimization), deployment systems (plane, freefall, parachute), loot spawning (weighted tables, rarity), and performance optimization (LOD, occlusion culling, object pooling). Use for multiplayer survival games or last-one-standing formats. Trigger keywords: battle_royale, zone_shrink, storm_damage, deployment_system, loot_spawn, networking_optimization, relevancy_system, snapshot_interpolation."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Battle Royale

Expert blueprint for Battle Royale games with zone mechanics, large-scale networking, and survival gameplay.

## NEVER Do (Expert Anti-Patterns)

### Networking & Scale
- NEVER sync all 100 players every frame; strictly use a **Relevancy System** to sync high-freq data only for players within ~100m. Far players sync at ~5Hz.
- NEVER use `TRANSFER_MODE_RELIABLE` for movement data; strictly use **Unreliable** to prevent packet backup and network congestion.
- NEVER focus on client-side hit detection; strictly use **Authoritative Server Validation** where the server confirms "Did it hit?" based on state history.
- NEVER trust the client for game state; strictly validate all movement, looting, and inventory changes exclusively on the authoritative server.
- NEVER run a dedicated server with visuals; strictly use **Headless Mode** (`--headless`) or dummy drivers to save massive CPU/GPU resources.
- NEVER call RPCs before connection; strictly wait for the `connected_to_server` signal before attempting synchronization logic.

### Mechanics & Performance
- NEVER pick a fully random center for the Safe Zone; strictly target centers that ensure the new circle is **completely contained** within the current one.
- NEVER allow "Storm Tunneling"; strictly use a **Distance-to-Center** calculation rather than a simple collision perimeter to prevent skips at low tick rates.
- NEVER spawn loot without **Object Pooling**; strictly pre-instantiate and toggle visibility/collision to avoid GC spikes during dense spawns.
- NEVER ignore `VisibilityNotifier3D`; strictly disable `AnimationPlayer`, `_process()`, and heavy AI logic for players that are not visible to the observer.
- NEVER print in tight server loops; strictly avoid `print()` as console I/O is blocking and will tank server performance in high-player-count matches.

---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### Zone / Storm
### [storm_system.gd](../scripts/genre_battle_royale_storm_system.gd)
**MANDATORY for any zone/storm work** — phase radii, contained next-center selection, distance-to-center damage (anti-tunneling). Do not paste inline zone_manager tutorials.

### Networking & Multiplayer
### [kill_feed_bus.gd](../scripts/genre_battle_royale_kill_feed_bus.gd)
Global elimination signal bus with match stat tracking.

### [headless_branch_logic.gd](../scripts/genre_battle_royale_headless_branch_logic.gd)
Expert dedicated server initialization that branches logic based on `headless` execution and server-specific feature flags.

### [enet_br_server.gd](../scripts/genre_battle_royale_enet_br_server.gd)
High-player-capacity ENet server setup optimized for 100+ concurrent peers over UDP.

### [state_replication_unreliable.gd](../scripts/genre_battle_royale_state_replication_unreliable.gd)
Pattern for synchronizing player transforms via `TRANSFER_MODE_UNRELIABLE` to minimize network congestion in large matches.

### [authoritative_looting.gd](../scripts/genre_battle_royale_authoritative_looting.gd)
Authoritative server-side validation logic for preventing cheat-based item collection and infinite looting.

### [targeted_rpc_relay.gd](../scripts/genre_battle_royale_targeted_rpc_relay.gd)
Optimized communication pattern using `rpc_id()` to target specific peers and reduce wasted packet broadcasts.

### [server_state_buffer.gd](../scripts/genre_battle_royale_server_state_buffer.gd)
Handling network jitter and out-of-order UDP packets via sequential state buffering and tick-based sorting.

### Performance & Optimization
### [rid_loot_spawner.gd](../scripts/genre_battle_royale_rid_loot_spawner.gd)
Bypassing the node hierarchy for massive loot density. Uses `RenderingServer` directly to eliminate CPU overhead for item drops.

### [async_map_loader.gd](../scripts/genre_battle_royale_async_map_loader.gd)
Non-blocking map sector streaming using `ResourceLoader` background threads for seamless open-world exploration.

### [multimesh_vegetation.gd](../scripts/genre_battle_royale_multimesh_vegetation.gd)
Drawing dense foliage and environment assets (100k+ instances) via `MultiMeshInstance3D` to maximize rendering performance.

### [threaded_ai_manager.gd](../scripts/genre_battle_royale_threaded_ai_manager.gd)
Offloading server-side bot behavior and pathfinding logic to the `WorkerThreadPool` to prevent main-thread stalling.

## NEVER Do in Battle Royale

- **NEVER export mobile clients without the INTERNET permission** — Communication will silently fail on Android/iOS if the manifest is missing the networking permission.
- **NEVER use `get_var(true)` on untrusted data** — Deserializing arbitrary objects allows attackers to execute remote code on the server or other clients.
- **NEVER synchronize `Object` or `Resource` types over network** — Use the `MultiplayerSynchronizer` strictly for base types (int, float, vec).
- **NEVER assume `UNRELIABLE` packets arrive in order** — Design state interpolation carefully to handle missing or out-of-order ticks.
- **NEVER leave `multiplayer_poll` false without manual calling** — If using custom threads, failing to call `multiplayer.poll()` freezes all traffic.

---

## Core Loop
Deploy → Loot → Move with storm → Engage → Last standing.

## Skill Chain (GDSkills peers only)

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Net | [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) | Authoritative server, relevancy, RPCs |
| 2. Map | [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md), [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) | Terrain scale, streaming, HLOD |
| 3. Items | [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) | Backpack / attachments / armor |
| 4. Combat | [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md), [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) | Hitscan/projectile + damage validation |
| 5. Zone | **MANDATORY** [storm_system.gd](../scripts/genre_battle_royale_storm_system.gd) | Storm phases / DPS / contained centers |
| 6. Balance | [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) | Zone DPS, loot rarity, TTK bands |

---

## Decision Trees (strip inline deploy/loot/zone tutorials)

### Zone / Storm
| Need | Action |
|------|--------|
| Phase shrink, contained centers, distance DPS | **MANDATORY** [storm_system.gd](../scripts/genre_battle_royale_storm_system.gd) |
| Storm wall VFX | Inverted SphereMesh + unshaded `cull_disabled` shader driven by storm radius |

### Loot
| Need | Action |
|------|--------|
| Dense drops | [rid_loot_spawner.gd](../scripts/genre_battle_royale_rid_loot_spawner.gd) + pooling |
| Anti-cheat pickup | **MANDATORY** [authoritative_looting.gd](../scripts/genre_battle_royale_authoritative_looting.gd) |
| Tables / rarity | Data Resources + peer inventory — not `instantiate()` loops in SKILL.md |

### Deploy
| Need | Action |
|------|--------|
| Plane → freefall → parachute → grounded | Finite state on player controller; server validates landing inventory |
| Map sectors | [async_map_loader.gd](../scripts/genre_battle_royale_async_map_loader.gd) |

### Networking
| Need | Action |
|------|--------|
| 100+ peers | [enet_br_server.gd](../scripts/genre_battle_royale_enet_br_server.gd) + [headless_branch_logic.gd](../scripts/genre_battle_royale_headless_branch_logic.gd) |
| Movement | [state_replication_unreliable.gd](../scripts/genre_battle_royale_state_replication_unreliable.gd) |
| Relevancy | Near ~20Hz+, far ~5Hz; `replication_interval` / interest management |
| Targeted messages | [targeted_rpc_relay.gd](../scripts/genre_battle_royale_targeted_rpc_relay.gd) |
| Jitter buffer | [server_state_buffer.gd](../scripts/genre_battle_royale_server_state_buffer.gd) |

---

## Advanced (keep elite, no deploy/loot re-tutorials)

### Lag Compensation
Server keeps transform history; validate client hit timestamps against rewound poses (authoritative). Pair with shooter/combat peers.

### Delta-Patching
`MultiplayerSynchronizer` + `REPLICATION_MODE_ON_CHANGE` for health/inventory; `ALWAYS` only for hot transforms. Cap with `delta_interval`.

### Zone Visualizer
Unshaded, `cull_disabled` spatial shader on inverted sphere scaled by [storm_system.gd](../scripts/genre_battle_royale_storm_system.gd).

## Common Pitfalls

1. Too much loot → pool + RID spawner
2. Camping → storm forces movement ([storm_system.gd](../scripts/genre_battle_royale_storm_system.gd))
3. Client hit authority → server validate with history

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — RPC authority, peer lifecycle, and visibility-aware sync patterns for 100-player relevancy instead of full-mesh broadcasts.
- [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) — UDP host/client peer sized for high concurrent match populations without TCP head-of-line blocking.
- [MultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html) — Reliable vs unreliable/unordered transfer modes so movement snapshots never back up the channel.
- [MultiplayerSynchronizer](https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html) — Property replication, `replication_interval` / on-change deltas, and per-peer visibility filters for interest management.
- [MultiplayerSpawner](https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html) — Spawn/despawn replication for players, loot drops, and late-join scene graph consistency.
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — `--headless` and multi-instance CLI launches for dedicated match servers.
- [Exporting for dedicated servers](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html) — Server export presets and feature tags that strip client-only rendering/input paths.
- [Occlusion culling](https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html) — Bake occlusion for dense building clusters so large BR maps stay GPU-viable.
- [Mesh level of detail (LOD)](https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html) — Distance LODs for terrain props and structures that dominate draw cost at drop-zone scale.
- [Optimization using MultiMeshes](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — Batch foliage/debris into MultiMesh draw calls instead of per-instance nodes.
- [Optimization using Servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — RenderingServer RID paths for dense loot visuals without SceneTree node overhead.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — Threaded `ResourceLoader` sector streaming for non-blocking open-world map loads.

### Related Skills

#### Prerequisites
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Authoritative server RPCs, transfer modes, and lobby/peer lifecycle that BR relevancy and lag compensation build on.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Autoloads, export feature flags, and project layout for headless dedicated vs client builds.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Large terrain chunking, collision generation, and world streaming prerequisites for storm-scale maps.

#### Complements
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Authority split, prediction shells, and snapshot interpolation before applying BR-scale interest management.
- [godot-server-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md) — Headless host scaffolding and PhysicsServer/RID patterns used by authoritative match simulation.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Dedicated-server presets, INTERNET permissions, and CLI packaging for multi-instance match tests.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Backpacks, attachments, and armor state that authoritative looting must validate server-side.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — LOD, pooling, and CPU budgets when loot density and peer count stress the match server/clients.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Kill-feed and match-event buses that stay local while RPCs carry cross-peer eliminations.
- [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md) — Hitscan/projectile combat patterns and lag-compensated validation used inside the BR engagement loop.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate zone DPS phases, loot rarity tables, and TTK bands so storm/loot pacing stays fair across 100-player matches.
- [godot-ai-navigation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md) — Bot pathfinding and interest-culled AI when filling lobbies with threaded server-side bots.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting BR concern.
