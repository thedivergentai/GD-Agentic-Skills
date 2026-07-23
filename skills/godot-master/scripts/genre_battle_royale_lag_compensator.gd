# lag_compensator.gd
class_name LagCompensator extends Node

var _position_history: Dictionary = {} # Timestamp -> Transform3D
const MAX_HISTORY_MS: int = 1000 # Keep 1 second of history

func _physics_process(_delta: float) -> void:
    if multiplayer.is_server():
        var current_time := Time.get_ticks_msec()
        _position_history[current_time] = owner.global_transform
        
        # Cleanup old entries
        for t in _position_history.keys():
            if t < current_time - MAX_HISTORY_MS:
                _position_history.erase(t)

@rpc("any_peer", "call_remote", "reliable")
func server_validate_hit(client_hit_pos: Vector3, client_timestamp: int) -> void:
    if not multiplayer.is_server(): return
    
    # 1. Backtrack to find the transform at the time the client saw it
    var historical_transform := _get_closest_transform(client_timestamp)
    
    # 2. Validate hit against historical state
    var distance := historical_transform.origin.distance_to(client_hit_pos)
    if distance < 2.0: # Tolerance
        apply_damage_authoritative()

func _get_closest_transform(timestamp: int) -> Transform3D:
    # Logic to find exact or interpolated historical transform
    return _position_history.get(timestamp, owner.global_transform)
