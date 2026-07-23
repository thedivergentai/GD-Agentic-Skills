---
name: godot-adapt-single-to-multiplayer
description: "Expert patterns for adding multiplayer to single-player games including client-server architecture, authoritative server design, MultiplayerSynchronizer, lag compensation (client prediction, server reconciliation), input buffering, and anti-cheat measures. Use when retrofitting multiplayer, porting to online play, or designing networked gameplay. Trigger keywords: MultiplayerPeer, ENetMultiplayerPeer, SceneMultiplayer, MultiplayerSynchronizer, rpc, rpc_id, multiplayer_authority, client_prediction, server_reconciliation, lag_compensation, rollback."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Adapt: Single to Multiplayer

Expert guidance for retrofitting multiplayer into single-player games.

## NEVER Do (Expert Multiplayer Rules)

### Security & Authority
- **NEVER trust client-reported state** — Clients own their 'Input', NOT their 'Position' or 'Health'. Server must validate every coordinate and health change.
- **NEVER use `get_tree()` groups for authority checks** — Use `is_multiplayer_authority()`. Group registration is non-deterministic in high-latency joins.
- **NEVER allow unrestricted RPC rates** — A malicious client can call a 'FireWeapon' RPC 10,000 times per second. Always implement rate-limiting (`net_rpc_rate_limiter.gd`).

### Movement & Lag
- **NEVER skip Client-Side Prediction** — Movement without prediction feels 'heavy' and unresponsive. Predict movement locally, then correct only on server disagreement.
- **NEVER sync peers at 60Hz** — Sending entire state every frame will saturate client bandwidth. Use a lower tick-rate (20-30Hz) and interpolate between packets.
- **NEVER snap peer positions** — Abrupt position updates cause 'jitter'. Store a buffer of past states and lerp between them with a 100ms delay.

### Bandwidth & Sync
- **NEVER sync 'Full Floats' if possible** — Quantize Vector3 data (truncating decimals) to save 50%+ bandwidth. Use `MultiplayerSynchronizer` with delta-sync enabled.
- **NEVER ignore 'Late Joiners'** — Players who join mid-game won't see existing environmental changes. Broadcast a full world-state 'Snapshot' on peer connection.
- **NEVER test on 0ms ping** — Everything works on localhost. Use a simulator (`net_latency_simulator.gd`) with 150ms ping to identify sync bugs.

---

## Available Scripts

> **MANDATORY**: Architecture decision tree first, then golden-path scripts. Deep latency workflows → [`references/latency-testing.md`](references/latency-testing.md).

### Authority / transport bridges
### [multiplayer_sync.gd](scripts/multiplayer_sync.gd)
**MANDATORY** when adding `MultiplayerSynchronizer` interpolation for remote peers. Trigger: authority owns transforms; non-authority interpolates.

### [rpc_bridge.gd](scripts/rpc_bridge.gd)
**MANDATORY** signal→RPC bridge. Trigger: gameplay emits local signals; bridge validates authority and fans out RPCs.

### Prediction / lag / lobby
### [net_prediction_reconciliation.gd](scripts/net_prediction_reconciliation.gd)
CharacterBody prediction + input-buffer replay for server reconciliation.

### [net_snapshot_interpolation.gd](scripts/net_snapshot_interpolation.gd)
Snapshot interpolation / jitter buffers for remote peers.

### [net_auth_server_validator.gd](scripts/net_auth_server_validator.gd)
Authoritative validation (position, speed, actions).

### [net_rpc_rate_limiter.gd](scripts/net_rpc_rate_limiter.gd)
RPC flood / macro protection.

### [net_interest_management.gd](scripts/net_interest_management.gd)
Distance-based visibility to cut bandwidth.

### [net_delta_compression_sync.gd](scripts/net_delta_compression_sync.gd)
Quantization + significance checks for delta sync.

### [net_lag_compensation.gd](scripts/net_lag_compensation.gd)
Server-side rewind for hit registration.

### [net_lobby_late_join_sync.gd](scripts/net_lobby_late_join_sync.gd)
Late-joiner world snapshot bootstrap.

### Diagnostics
### [net_latency_simulator.gd](scripts/net_latency_simulator.gd)
**MANDATORY** before ship — see [`references/latency-testing.md`](references/latency-testing.md).

### [net_debug_overlay_monitor.gd](scripts/net_debug_overlay_monitor.gd)
RTT / loss / jitter overlay.

### [net_upnp_discovery_logic.gd](scripts/net_upnp_discovery_logic.gd)
UPNP port mapping for listen-server / P2P hosts.

---

## Architecture Patterns

| Pattern | When | Script golden path |
|---------|------|--------------------|
| Authoritative server | PvP, economies, cheat risk | `rpc_bridge.gd` → `net_auth_server_validator.gd` → prediction/recon |
| P2P lockstep | 2–4 co-op, low cheat risk | Deterministic inputs + `net_upnp_discovery_logic.gd` |
| Hybrid / host authority | Party games 4–8 | Host authority + late-join snapshot |

---

## Migration golden path (no inline host/join tutorials)

1. Separate **input** (client) from **simulation** (authority).
2. Set `multiplayer_authority` per player node; clients send intents only.
3. **MANDATORY** `multiplayer_sync.gd` for property replication / remote interpolation.
4. **MANDATORY** `rpc_bridge.gd` for gameplay events that cross the wire.
5. Add prediction / lag compensation scripts only for the genres that need them.
6. Validate with **latency-testing** reference + `net_latency_simulator.gd` at ~150 ms RTT.

## Decision Tree: Which Architecture?

| Factor | Authoritative Server | P2P Lockstep |
|--------|---------------------|--------------|
| Player count | 8-100+ | 2-4 |
| Cheat prevention | Critical | Not important |
| Server hosting | Available | Not available |
| Gameplay type | PvP, competitive | Co-op, casual |
| Lag tolerance | Medium (prediction helps) | Low (desyncs) |
| Development complexity | High | Medium |


## Advanced Networking Topics

### Peer-to-Peer NAT Traversal (Hole Punching)
In P2P architectures, clients often sit behind firewalls. **UPNP** (Universal Plug and Play) is the first line of defense, allowing the game to request port forwarding from the router automatically using `net_upnp_discovery_logic.gd`.

For cases where UPNP fails:
- **STUN/TURN**: Use a STUN server to discover public IP/port pairings.
- **Relay Servers**: If direct connection is impossible, fallback to a relay server (TURN) to bridge the two peers.

### Network Profiling & Visualization
Visualizing the packet timeline is critical for debugging jitter. Propose an overlay that graphs:
- **Packet Arrival**: A scrolling timeline showing when packets arrive relative to physics frames.
- **Buffer Health**: A visualization of the interpolation jitter buffer size.
- **RTT (Round Trip Time)**: Real-time graph of latency spikes.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — RPC modes, authority, and peer lifecycle you must retrofit before any gameplay state leaves the single-player path.
- [Networking](https://docs.godotengine.org/en/stable/tutorials/networking/index.html) — Transport map (ENet / WebSocket / WebRTC) so host/join choices match platform and NAT constraints.
- [MultiplayerSynchronizer](https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html) — Property replication, delta sync, and visibility filters that replace ad-hoc position RPCs.
- [MultiplayerSpawner](https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html) — Spawn/despawn replication when late joiners need the same scene graph as the host.
- [SceneMultiplayer](https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html) — Default MultiplayerAPI implementation: root path, auth callbacks, and RPC routing under SceneTree.
- [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) — UDP host/client peer used by most LAN and dedicated-server ports of single-player games.
- [MultiplayerAPI](https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html) — `multiplayer` singleton surface: peer IDs, signals, and `rpc` / `rpc_id` entry points.
- [MultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html) — Transfer modes and connection status shared by every concrete peer backend.
- [UPNP](https://docs.godotengine.org/en/stable/classes/class_upnp.html) — Automatic port mapping for listen-server / P2P hosts behind consumer routers.
- [WebRTC](https://docs.godotengine.org/en/stable/tutorials/networking/webrtc.html) — Browser-friendly P2P path when ENet UDP cannot punch through firewalls alone.
- [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) — `set_multiplayer_authority` / `is_multiplayer_authority` ownership rules for input vs state.
- [PhysicsServer3D](https://docs.godotengine.org/en/stable/classes/class_physicsserver3d.html) — Direct RID transforms for server-side hit rewind without SceneTree side effects.

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Split InputMap reads from simulation so clients send intents and the authority owns outcomes.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Local signal graphs that `rpc_bridge.gd` can wrap without coupling gameplay to transport.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Session/lobby Autoloads that outlive scene changes during host/join flow.

#### Complements
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Broader RPC, lobby, and ENet tuning once the single-player→online migration shape is fixed.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Deterministic move_and_slide steps reused by client prediction and reconciliation buffers.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — Body/shape setup that lag-compensation rewind and hit validation query against.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Server-side ray/shape queries for authoritative shots after state rewind.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — RTT/jitter overlays and remote debug habits that catch sync bugs localhost never shows.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Headless/dedicated-server export presets and CLI flags for real multi-instance tests.
- [godot-server-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md) — PhysicsServer/RID patterns and headless host scaffolding used by rewind and dedicated peers.

#### Downstream / consumers
- [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — Hitscan/projectile feel that depends on prediction + lag compensation from this skill.
- [godot-genre-battle-royale](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md) — Large-peer interest management and late-join snapshots at BR scale.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Retune economy/TTK after netcode changes alter effective weapon timings.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Cap replication rate and cull interest when bandwidth/CPU budgets break under peer load.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for this Domain Skill.
