---
name: godot-server-architecture
description: "Expert blueprint for dedicated / headless multiplayer hosts: ENet/DTLS, authority validation, safe packet decode, matchmaker handoff, and health telemetry. Use when building authoritative servers, --headless hosts, or hardening host networking. Keywords: dedicated server, headless, ENet, DTLS, authority, safe_packet_decoder, multiplayer host, WebSocketMultiplayerPeer."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Server Architecture (Dedicated Host)

Authoritative **multiplayer host** patterns — headless boot, ENet/DTLS, packet safety, kicks, and telemetry.

> RID SceneTree-bypass rendering/physics swarms belong in [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) (and `physics_server_direct.gd` / `rid_performance_server.gd` only when the host sim truly needs server RIDs). Lobby/RPC gameplay APIs: [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md).

## Skill boundary (Do NOT Load)

| Use **this skill** for | Use **godot-multiplayer-networking** for |
| :--- | :--- |
| `--headless` / dedicated export boot | Lobby UI, matchmaking UX, friend invites |
| ENet/DTLS host peer + safe decode | RPC signatures, `@rpc` gameplay handlers |
| Authority validation on privileged ops | MultiplayerSynchronizer / scene replication |
| Kick, health telemetry, matchmaker handoff | Client prediction, lag compensation |

**Do NOT Load** lobby/RPC tutorial scripts from multiplayer-networking when only booting a host — follow Host Golden Path here first.

## Host Golden Path (MANDATORY)

1. **Headless detect/init** — **MANDATORY** [headless_init_manager.gd](../scripts/server_architecture_headless_init_manager.gd) (`--headless` / `dedicated_server` feature).
2. **Safe decode** — **MANDATORY** [safe_packet_decoder.gd](../scripts/server_architecture_safe_packet_decoder.gd) before any untrusted `get_var`.
3. **Host peer** — [enet_optimized_host.gd](../scripts/server_architecture_enet_optimized_host.gd); add [dtls_secure_server.gd](../scripts/server_architecture_dtls_secure_server.gd) when encrypting UDP.
4. **Authority** — [server_authority_validator.gd](../scripts/server_architecture_server_authority_validator.gd) on every privileged RPC.
5. **Ops** — [peer_kick_manager.gd](../scripts/server_architecture_peer_kick_manager.gd), [server_health_exporter.gd](../scripts/server_architecture_server_health_exporter.gd); matchmaker handoff via [server_matchmaker_client.gd](../scripts/server_architecture_server_matchmaker_client.gd).

## Available Scripts

### [headless_init_manager.gd](../scripts/server_architecture_headless_init_manager.gd)
Detect/initialize dedicated server logic for `--headless` / `dedicated_server`.

### [headless_manager.gd](../scripts/server_architecture_headless_manager.gd)
Headless runtime manager companion patterns.

### [enet_optimized_host.gd](../scripts/server_architecture_enet_optimized_host.gd)
High-performance ENet UDP hosts with bandwidth/client limits.

### [dtls_secure_server.gd](../scripts/server_architecture_dtls_secure_server.gd)
DTLS + X509 hardening for ENet UDP.

### [safe_packet_decoder.gd](../scripts/server_architecture_safe_packet_decoder.gd)
Forbid object decoding on untrusted packets (RCE guard).

### [manual_network_poll.gd](../scripts/server_architecture_manual_network_poll.gd)
Manual `multiplayer.poll()` when auto-poll is disabled.

### [isolated_multiplayer_api.gd](../scripts/server_architecture_isolated_multiplayer_api.gd)
Isolated MultiplayerAPI instances (client+server in one process).

### [server_authority_validator.gd](../scripts/server_architecture_server_authority_validator.gd)
`get_remote_sender_id()` gates for authoritative requests.

### [websocket_server_compat.gd](../scripts/server_architecture_websocket_server_compat.gd)
HTML5-compatible `WebSocketMultiplayerPeer` hosts.

### [peer_kick_manager.gd](../scripts/server_architecture_peer_kick_manager.gd)
Graceful peer termination with reason propagation.

### [server_matchmaker_client.gd](../scripts/server_architecture_server_matchmaker_client.gd)
Load-balancer / matchmaker handoff to game hosts.

### [server_health_exporter.gd](../scripts/server_architecture_server_health_exporter.gd)
Headless telemetry for monitoring stacks.

### [physics_server_direct.gd](../scripts/server_architecture_physics_server_direct.gd) / [rid_performance_server.gd](../scripts/server_architecture_rid_performance_server.gd)
Optional host-side RID sim — **only when** node physics cannot hold tick budget: > ~200 active bodies per tick, or headless host CPU > 70% on physics step with nodes. Criteria: profile first; if SceneTree bodies dominate, prefer [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md). **Do NOT Load** RID scripts for ≤64 entity lobbies.

## NEVER Do in Server Architecture (Host)

- **NEVER trust the client** — Validate state, purchases, and damage on the authoritative host.
- **NEVER use `TRANSFER_MODE_RELIABLE` for continuous streams** — Prefer unreliable for high-rate transforms.
- **NEVER use `get_var(true)` on untrusted packets** — Object decode = RCE. **MANDATORY** safe_packet_decoder.
- **NEVER use TCP for fast-paced action** — Prefer ENet UDP (or WebSocket for HTML5 constraints).
- **NEVER run a dedicated server without stripping visuals** — Dedicated Server export / dummy drivers.
- **NEVER expect RPCs before `connected_to_server` / peer ready**.
- **NEVER assume `UNRELIABLE` packets arrive in order**.
- **NEVER leave `SceneTree.multiplayer_poll` false without manual `poll()`**.
- **NEVER mix incompatible engine/multiplayer protocol versions across peers**.
- **NEVER forget `free_rid` on server-created RIDs** if the host uses Physics/RenderingServer pools.

## Host Patterns

### Interest management
Large worlds: `MultiplayerSynchronizer.public_visibility = false` + visibility filters (AABB / grid) so the host does not sync the entire world to every peer.

```gdscript
# Hook on synchronizer — filter peers by grid cell / AABB (no full tutorial)
func _visibility_filter(for_peer: int, node: Node) -> bool:
	return _interest_grid.is_visible_to_peer(for_peer, node.global_position)
# Assign: synchronizer.set_visibility_filter(_visibility_filter)
```

### Health metrics
Watch host FPS, static memory (RID leaks), and orphan counts via [server_health_exporter.gd](../scripts/server_architecture_server_health_exporter.gd).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using Servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — RID-based RenderingServer/PhysicsServer/NavigationServer workflow when SceneTree nodes are too slow.
- [RenderingServer](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html) — `canvas_item_*` / `instance_*` / `free_rid` for procedural draw and mesh swarms without MeshInstance nodes.
- [PhysicsServer3D](https://docs.godotengine.org/en/stable/classes/class_physicsserver3d.html) — `body_create`, space binding, and direct-state queries for headless authoritative simulation.
- [PhysicsServer2D](https://docs.godotengine.org/en/stable/classes/class_physicsserver2d.html) — 2D body/shape RIDs mirroring the same SceneTree-bypass pattern.
- [RID](https://docs.godotengine.org/en/stable/classes/class_rid.html) — opaque server handles; every `*_create()` needs a matching `free_rid` to avoid leaks.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — authority, RPCs, and peer lifecycle for dedicated hosts and isolated MultiplayerAPI branches.
- [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) — UDP host creation, channels/bandwidth limits, and DTLS host setup on `peer.host`.
- [WebSocket multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/websocket.html) — browser-compatible peer path when ENet UDP is unavailable (HTML5 clients).
- [Exporting for dedicated servers](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html) — dedicated-server export presets and stripping visuals/audio for production hosts.
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — `--headless` and CLI flags used by headless init/managers.
- [Binary serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html) — `get_var(false)` / object-decoding rules that block RCE on untrusted packets.
- [DTLSServer](https://docs.godotengine.org/en/stable/classes/class_dtlsserver.html) — DTLS accept path complementary to ENet `dtls_server_setup` with X509/TLSOptions.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — project layout, Autoloads, and feature tags that dedicated-server and headless launches depend on.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed RID arrays, `@rpc` annotations, and safe Variant decoding patterns used across server scripts.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — node-level PhysicsBody3D/space concepts before bypassing them with PhysicsServer3D RIDs.

#### Complements
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — lobby/RPC/synchronizer toolkit that sits on the headless ENet/WebSocket hosts this skill scaffolds.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — authority split and prediction shells before wiring dedicated-server validation and interest filters.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — dedicated-server export presets and CLI packaging for real multi-instance host tests.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — PhysicsServer2D body/shape patterns for 2D authoritative swarms without SceneTree bodies.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationServer RIDs and bake updates when AI agents share the same low-level server path.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — budgets and profiling that decide when RID servers beat nodes under peer/object load.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Performance monitors and remote debug habits for headless FPS/memory/orphan telemetry.
- [godot-platform-web](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md) — HTML5 client constraints that force WebSocketMultiplayerPeer instead of ENet.

#### Downstream / consumers
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — mass object/voxel spawners that consume RenderingServer/PhysicsServer RID pools.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — retune economy/TTK after authoritative server tick rates or validation change effective combat windows.
- [godot-genre-battle-royale](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md) — large-peer dedicated hosts that need interest grids, kick/health exporters, and RID-scale sim.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting server concern.
