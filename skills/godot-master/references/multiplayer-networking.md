---
name: godot-multiplayer-networking
description: "Expert multiplayer for desync, rollback, dedicated --headless servers, interest culling, and bandwidth spikes: ENet/WebRTC choice, authority, secure RPCs, client prediction/reconcile, and adaptive sync. Trigger on rubber-banding, cheat-able clients, peer floods, late join, or profiler Network spikes — not only greenfield online games. Keywords: multiplayer, RPC, ENetMultiplayerPeer, MultiplayerSynchronizer, authority, client prediction, rollback, interest management, headless, desync."
---
## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Multiplayer Networking

Server authority, prediction/reconcile, secure RPCs, and interest culling — not a high-level multiplayer tutorial.

## NEVER Do (Expert Networking Rules)

### Core Architecture
- **NEVER use `Reliable` for high-frequency data (Position/Movement)** — Reliable packets block all following packets until acknowledged (Head-of-Line blocking). Use `UnreliableOrdered`.
- **NEVER trust the client for shared state (Health/Money/Inventory)** — Clients should only suggest actions. The Server MUST validate and broadcast the result.
- **NEVER hardcode the Server IP** — Always allow for discovery (`net_lan_discovery.gd`) or pass the IP via CLI/UI.

### Performance & Bandwidth
- **NEVER send the same data every frame** — Use `net_adaptive_sync_throttle.gd` to only send updates when state changes significantly or at fixed Hz intervals (e.g., 20Hz).
- **NEVER use `JSON` for high-speed synchronization** — String serialization is massive over the wire. Use bit-packing (`net_packet_bit_packer.gd`) to keep packets under 100 bytes.
- **NEVER broadcast to all peers if it's not needed** — In large worlds, use Interest Management (`net_visibility_grid_culling.gd`). A player in the forest doesn't need the position of a player in the city.

### Security
- **NEVER allow unlimited RPC calls per second** — An attacker can flood the server with 1,000 "Attack" RPCs to crash the game. Use `net_packet_rate_limiter.gd`.
- **NEVER expose PeerIDs to the end-user** — PeerIDs are internal. Always map them to persistent `UserIDs` (`net_custom_id_mapper.gd`) from a database.
- **NEVER run a dedicated server with a GUI enabled** — Use `--headless` (`net_headless_server_auto_start.gd`) to save resources and ensure stability.

## Decision Tree (transport / authority / sync Hz)

| Question | Prefer | Script |
|----------|--------|--------|
| Desktop/console LAN or dedicated UDP | ENet | **MANDATORY** [net_enet_expert_config.gd](../scripts/multiplayer_networking_net_enet_expert_config.gd) |
| Browser / NAT-hostile peers | WebRTC (or WebSocket fallback) | Official Docs + peer wrappers; still use secure RPC scripts |
| Who owns gameplay truth? | Server-authoritative | **MANDATORY** [server_authoritative_controller.gd](../scripts/multiplayer_networking_server_authoritative_controller.gd) |
| Dedicated host without GUI | `--headless` | **MANDATORY** [net_headless_server_auto_start.gd](../scripts/multiplayer_networking_net_headless_server_auto_start.gd) / [server_dedicated_host.gd](../scripts/multiplayer_networking_server_dedicated_host.gd) |
| Position @ 10–20 Hz, not every frame | Adaptive throttle | **MANDATORY** [net_adaptive_sync_throttle.gd](../scripts/multiplayer_networking_net_adaptive_sync_throttle.gd) |

> **Do NOT Load** lobby/RPC beginner recipes from memory — use the golden path below and open only matching scripts.

## Golden Path

1. **Host / dedicated** → [server_dedicated_host.gd](../scripts/multiplayer_networking_server_dedicated_host.gd) + [net_headless_server_auto_start.gd](../scripts/multiplayer_networking_net_headless_server_auto_start.gd); clients → [client_network_setup.gd](../scripts/multiplayer_networking_client_network_setup.gd).
2. **Secure RPC** → [secured_rpc_pattern.gd](../scripts/multiplayer_networking_secured_rpc_pattern.gd) + [net_packet_rate_limiter.gd](../scripts/multiplayer_networking_net_packet_rate_limiter.gd) + [secure_variable_synchronizer.gd](../scripts/multiplayer_networking_secure_variable_synchronizer.gd).
3. **Prediction / reconcile** → [client_prediction_synchronizer.gd](../scripts/multiplayer_networking_client_prediction_synchronizer.gd) + [net_anti_desync_reconciler.gd](../scripts/multiplayer_networking_net_anti_desync_reconciler.gd); fighting/rollback → [net_rollback_helper.gd](../scripts/multiplayer_networking_net_rollback_helper.gd).
4. **Interest culling** → [net_visibility_grid_culling.gd](../scripts/multiplayer_networking_net_visibility_grid_culling.gd) before broadcasting positions.

## Available Scripts

### Transport & host
- [net_enet_expert_config.gd](../scripts/multiplayer_networking_net_enet_expert_config.gd) — channels, compression, bandwidth.
- [net_headless_server_auto_start.gd](../scripts/multiplayer_networking_net_headless_server_auto_start.gd) — CLI/`--headless` detect.
- [server_dedicated_host.gd](../scripts/multiplayer_networking_server_dedicated_host.gd) — dedicated host bootstrap.
- [client_network_setup.gd](../scripts/multiplayer_networking_client_network_setup.gd) — client peer join.
- [net_lan_discovery.gd](../scripts/multiplayer_networking_net_lan_discovery.gd) — UDP LAN discovery.
- [network_error_handler.gd](../scripts/multiplayer_networking_network_error_handler.gd) — disconnect/error routing.
- [packet_peer_latency_test.gd](../scripts/multiplayer_networking_packet_peer_latency_test.gd) — latency probes.
- [net_heartbeat_monitor.gd](../scripts/multiplayer_networking_net_heartbeat_monitor.gd) — RTT/jitter.

### Authority, RPC, sync
- [server_authoritative_controller.gd](../scripts/multiplayer_networking_server_authoritative_controller.gd) — server validates actions.
- [secured_rpc_pattern.gd](../scripts/multiplayer_networking_secured_rpc_pattern.gd) — safe RPC annotations/patterns.
- [secure_variable_synchronizer.gd](../scripts/multiplayer_networking_secure_variable_synchronizer.gd) — server-owned vars.
- [net_packet_rate_limiter.gd](../scripts/multiplayer_networking_net_packet_rate_limiter.gd) — flood protection.
- [net_packet_bit_packer.gd](../scripts/multiplayer_networking_net_packet_bit_packer.gd) — compact payloads (no JSON on hot path).
- [net_adaptive_sync_throttle.gd](../scripts/multiplayer_networking_net_adaptive_sync_throttle.gd) — Hz / change-threshold sync.
- [game_state_sync_manager.gd](../scripts/multiplayer_networking_game_state_sync_manager.gd) — snapshot/state sync.
- [multiplayer_spawner_manager.gd](../scripts/multiplayer_networking_multiplayer_spawner_manager.gd) — spawn authority.
- [network_input_synchronizer.gd](../scripts/multiplayer_networking_network_input_synchronizer.gd) — input frames to server.
- [networked_interpolator.gd](../scripts/multiplayer_networking_networked_interpolator.gd) — remote entity smoothing.
- [net_custom_id_mapper.gd](../scripts/multiplayer_networking_net_custom_id_mapper.gd) — UserID ↔ PeerID.

### Desync / rollback / interest
- [client_prediction_synchronizer.gd](../scripts/multiplayer_networking_client_prediction_synchronizer.gd) — predict + correct.
- [net_anti_desync_reconciler.gd](../scripts/multiplayer_networking_net_anti_desync_reconciler.gd) — forced correction.
- [net_rollback_helper.gd](../scripts/multiplayer_networking_net_rollback_helper.gd) — snapshot re-sim helper.
- [net_visibility_grid_culling.gd](../scripts/multiplayer_networking_net_visibility_grid_culling.gd) — interest management.

## Expert Pointers

- Position/movement: `UnreliableOrdered` + throttle — never reliable every frame.
- Clients suggest; server validates and broadcasts results.
- Large worlds: cull with visibility grid before adding more sync Hz.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — RPC modes, authority, and peer lifecycle for host/join lobbies and server-validated actions.
- [Networking](https://docs.godotengine.org/en/stable/tutorials/networking/index.html) — Transport map (ENet / WebSocket / WebRTC / HTTP) so peer choice matches platform and NAT constraints.
- [MultiplayerAPI](https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html) — `multiplayer` singleton: peer IDs, connection signals, and `rpc` / `rpc_id` entry points.
- [MultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html) — Transfer modes (reliable / unreliable / unordered) and connection status shared by every backend.
- [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) — UDP host/client peer used for LAN, dedicated servers, and most action games.
- [SceneMultiplayer](https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html) — Default MultiplayerAPI: root path, auth callbacks, and scene-tree RPC routing.
- [MultiplayerSpawner](https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html) — Spawn/despawn replication so late joiners share the same networked scene graph.
- [MultiplayerSynchronizer](https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html) — Property replication, on-change deltas, and visibility filters that replace ad-hoc position RPCs.
- [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) — `set_multiplayer_authority` / `is_multiplayer_authority` ownership rules for input vs shared state.
- [PacketPeerUDP](https://docs.godotengine.org/en/stable/classes/class_packetpeerudp.html) — Raw UDP send/receive for LAN discovery broadcasts outside the high-level multiplayer peer.
- [WebRTC](https://docs.godotengine.org/en/stable/tutorials/networking/webrtc.html) — Browser-friendly P2P path when ENet UDP cannot punch through firewalls alone.
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — `--headless` and CLI flags for dedicated-server launches and multi-instance tests.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, Autoloads, and export/feature flags that host/join and dedicated-server builds depend on.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed `@rpc` annotations, Callables, and PackedByteArray patterns used by secure RPCs and bit-packers.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Split InputMap reads from simulation so clients send intents and the authority owns outcomes.

#### Complements
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Migration shape (authority split, prediction shells) before applying this skill’s lobby/RPC/ENet toolkit.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Session/lobby Autoloads that outlive scene changes during host/join and reconnect flows.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Local peer-connected / lobby events that stay decoupled from transport RPCs.
- [godot-server-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md) — Headless host scaffolding and PhysicsServer/RID patterns used by authoritative simulation.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Dedicated-server export presets and CLI packaging for real multi-instance tests.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — RTT/jitter overlays and remote debug habits that catch sync bugs localhost never shows.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Persist UserIDs, lobby prefs, and reconnect tokens without treating PeerIDs as durable identity.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Cap replication Hz and interest culling when bandwidth/CPU budgets break under peer load.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Retune economy/TTK after netcode changes alter effective weapon timings or ability windows.
- [godot-genre-battle-royale](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md) — Large-peer interest management and late-join snapshots at BR scale.
- [godot-genre-moba](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md) — Fixed-tick authority, ability RPCs, and spectator-safe state sync for multiplayer arenas.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting networking concern.
