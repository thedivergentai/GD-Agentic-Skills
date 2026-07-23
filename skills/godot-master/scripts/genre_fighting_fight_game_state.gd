# fight_game_state.gd
class_name GameState
extends Resource

# Serialize complete game state for rollback
func save_state() -> Dictionary:
    return {
        "frame": frame_count,
        "fighters": fighters.map(func(f): return f.serialize()),
        "projectiles": projectiles.map(func(p): return p.serialize())
    }

func load_state(state: Dictionary) -> void:
    frame_count = state["frame"]
    for i in fighters.size():
        fighters[i].deserialize(state["fighters"][i])
    # Reconstruct projectiles...
