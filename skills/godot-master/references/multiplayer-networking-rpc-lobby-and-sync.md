# RPC, lobby, and sync patterns

> Load when wiring host/join, RPC modes, lobby player info, or puppet interpolation. Golden-path scripts in `scripts/` remain authoritative for production netcode.

## Basic Setup

### Create Multiplayer Peer

```gdscript
extends Node

var peer := ENetMultiplayerPeer.new()

func host_game(port: int = 7777) -> void:
    peer.create_server(port, 4)  # Max 4 players
    multiplayer.multiplayer_peer = peer
    print("Server started on port ", port)

func join_game(ip: String, port: int = 7777) -> void:
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    print("Connecting to ", ip)
```

### Connection Signals

```gdscript
func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected)
    multiplayer.connection_failed.connect(_on_connection_failed)

func _on_peer_connected(id: int) -> void:
    print("Player connected: ", id)

func _on_peer_disconnected(id: int) -> void:
    print("Player disconnected: ", id)

func _on_connected() -> void:
    print("Connected to server!")

func _on_connection_failed() -> void:
    print("Connection failed")
```

## Remote Procedure Calls (RPCs)

### Basic RPC

```gdscript
extends CharacterBody2D

## MultiplayerSpawner

```gdscript

## MultiplayerSynchronizer

```gdscript

## Lobby System

```gdscript

## State Synchronization

```gdscript
extends CharacterBody2D

var puppet_position: Vector2
var puppet_velocity: Vector2

func _physics_process(delta: float) -> void:
    if is_multiplayer_authority():
        # Local player: process input
        _handle_input(delta)
        move_and_slide()
        
        # Send position to others
        sync_position.rpc(global_position, velocity)
    else:
        # Remote player: interpolate
        global_position = global_position.lerp(puppet_position, 10.0 * delta)

@rpc("any_peer", "unreliable")
func sync_position(pos: Vector2, vel: Vector2) -> void:
    puppet_position = pos
    puppet_velocity = vel
```

## Authority

```gdscript

## Best Practices

### 1. Validate on Server

```gdscript
@rpc("any_peer", "call_local")
func player_action(action: String) -> void:
    if not multiplayer.is_server():
        return  # Only server validates
    
    var sender := multiplayer.get_remote_sender_id()
    if not _is_valid_action(sender, action):
        return
    
    _apply_action.rpc(sender, action)
```

### 2. Use Unreliable for Frequent Updates

```gdscript

## Expert Networking Patterns

### 1. Multiplayer Delta-Compression
To minimize bandwidth, only send data that has changed.
- **Native**: Use `MultiplayerSynchronizer` with `REPLICATION_MODE_ON_CHANGE`.
- **Manual**: Store the `last_sent_state` and only broadcast an RPC if the current state differs by a significant threshold.

### 2. Network Simulator UI
Test your game's resilience by artificially degrading the network.
- **Latency**: Buffer outgoing/incoming RPCs in an array and delay execution.
- **Jitter**: Randomize the delay for each packet.
- **Packet Loss**: Use `randf() < loss_rate` to discard packets before they are processed.
