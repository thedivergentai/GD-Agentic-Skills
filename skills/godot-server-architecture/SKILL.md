---
name: godot-server-architecture
description: "Expert blueprint for low-level server access (RenderingServer, PhysicsServer2D/3D, NavigationServer) using RIDs for maximum performance. Bypasses scene tree overhead for procedural generation, particle systems, and voxel engines. Use when nodes are too slow OR managing thousands of objects. Keywords RenderingServer, PhysicsServer, NavigationServer, RID, canvas_item, body_create, low-level, performance."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Server Architecture

RID-based server API, direct rendering/physics access, and object pooling define maximum-performance patterns.

## Available Scripts

### [headless_init_manager.gd](scripts/headless_init_manager.gd)
Automatically detecting and initializing dedicated server logic when launched with `--headless` or `dedicated_server` features.

### [enet_optimized_host.gd](scripts/enet_optimized_host.gd)
Expert initialization of high-performance ENet UDP hosts with precise bandwidth and client limits.

### [dtls_secure_server.gd](scripts/dtls_secure_server.gd)
Securing ENet UDP traffic using DTLS and X509 certificates to prevent man-in-the-middle attacks.

### [physics_server_direct.gd](scripts/physics_server_direct.gd)
Massive scale simulation pattern that bypasses the SceneTree by creating bodies directly on the `PhysicsServer3D`.

### [safe_packet_decoder.gd](scripts/safe_packet_decoder.gd)
Crucial network security pattern that explicitly forbids object decoding to prevent Remote Code Execution (RCE) vulnerabilities.

### [manual_network_poll.gd](scripts/manual_network_poll.gd)
Moving networking off the main thread by disabling automatic polling and managing manual `multiplayer.poll()` loops.

### [isolated_multiplayer_api.gd](scripts/isolated_multiplayer_api.gd)
Pattern for running Client and Server branches independently within a single Godot instance via isolated API instances.

### [server_authority_validator.gd](scripts/server_authority_validator.gd)
Authoritative entry point validation using `get_remote_sender_id()` to strictly verify client requests.

### [websocket_server_compat.gd](scripts/websocket_server_compat.gd)
Ensuring compatibility with HTML5/Web browser clients using `WebSocketMultiplayerPeer` architecture.

### [peer_kick_manager.gd](scripts/peer_kick_manager.gd)
Graceful termination and cleanup of peer connections with custom reason propagation.

### [server_matchmaker_client.gd](scripts/server_matchmaker_client.gd)
Client-side handoff logic for connecting to servers via a Load Balancer/Matchmaker.

### [server_health_exporter.gd](scripts/server_health_exporter.gd)
Telemetry exporter for headless servers to monitoring stacks (Prometheus/Grafana).

## NEVER Do in Server Architecture

- **NEVER trust the client** — Validate all state changes, purchases, and damage exclusively on the authoritative server to prevent cheating [28].
- **NEVER use `TRANSFER_MODE_RELIABLE` for continuous data streams** — Synchronizing coordinates every frame using reliable mode causes extreme network congestion; always use `UNRELIABLE` [29].
- **NEVER use `get_var(true)` on untrusted network packets** — Passing `true` allows the engine to deserialize arbitrary objects, creating a critical Remote Code Execution vulnerability [30].
- **NEVER use TCP for fast-paced action games** — TCP's Nagle's algorithm and congestion control cause unacceptable latency; use Godot's built-in ENet (UDP) [31].
- **NEVER run a dedicated server without stripping visuals** — Always export using "Dedicated Server" mode or use the `Dummy` audio/physics drivers to prevent GPU/CPU waste [32].
- **NEVER expect RPCs to work before connection** — Calling an RPC on a client before the `connected_to_server` signal has fired will fail [34].
- **NEVER assume `UNRELIABLE` packets arrive in order** — UDP packets can arrive out of order or be dropped; design state interpolation to handle missing ticks [31].
- **NEVER leave `SceneTree.multiplayer_poll` set to false without manually calling `poll()`** — Disabling auto-polling without manual polling freezes all network traffic [35].
- **NEVER attempt to connect Godot clients and servers running different engine versions** — The high-level multiplayer API protocol is version-specific and breaking [36].
- **NEVER forget to unbind or free RIDs** — `PhysicsServer3D.body_create()` without `free_rid()` causes massive server-side memory leaks over time.

---

Direct access to rendering without nodes.

```gdscript
# Create canvas item (2D sprite equivalent)
var canvas_item := RenderingServer.canvas_item_create()
RenderingServer.canvas_item_set_parent(canvas_item, get_canvas_item())

# Draw texture
var texture_rid := load("res://icon.png").get_rid()
RenderingServer.canvas_item_add_texture_rect(
    canvas_item,
    Rect2(0, 0, 64, 64),
    texture_rid
)
```

## PhysicsServer2D

Create physics bodies without nodes.

```gdscript
# Create body
var body_rid := PhysicsServer2D.body_create()
PhysicsServer2D.body_set_mode(body_rid, PhysicsServer2D.BODY_MODE_RIGID)

# Create shape
var shape_rid := PhysicsServer2D.circle_shape_create()
PhysicsServer2D.shape_set_data(shape_rid, 16.0)  # radius

# Assign shape to body
PhysicsServer2D.body_add_shape(body_rid, shape_rid)
```

## When to Use Servers

**Use servers for:**
- Procedural generation (thousands of objects)
- Particle systems
- Voxel engines
- Custom rendering

**Use nodes for:**
- Regular game objects
- UI
- Prototyping

## Advanced Server Patterns

### 1. Grid-Based Interest Management
In large worlds, don't sync everything. Use `AABB` checks on the server to only sync objects within a player's immediate "interest grid".

- **Logic**: Set `MultiplayerSynchronizer.public_visibility = false`.
- **Filter**: `add_visibility_filter(func(id): return player_aabb.has_point(object_pos))`.

### 2. Server Health Metrics
Monitoring dedicated servers is vital for scaling.
- **FPS**: Drop below 60/30 indicates simulation lag.
- **Memory**: Static memory growth indicates RID leaks.
- **Nodes**: High orphan counts indicate incorrect cleanup.

## Reference
- [Godot Docs: Using Servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html)


### Related
- Master Skill: [godot-master](../godot-master/SKILL.md)
