# server_minion_sync.gd
extends Node
class_name ServerMinionSync

# Centralized Server-Authoritative Minion Sync
# Batches hundreds of minion positions into a single byte array for low-overhead sync.

func _physics_process(_delta: float) -> void:
    # Only the server should broadcast state.
    if multiplayer.is_server():
        var minion_data := PackedFloat32Array()
        var minions := get_tree().get_nodes_in_group(&"minions")
        
        for minion in minions:
            # Sync core transform data to minimal primitives.
            minion_data.push_back(minion.global_position.x)
            minion_data.push_back(minion.global_position.y)
        
        # Bypasses high-overhead RPCs, sending raw bytes unreliably for maximum speed.
        multiplayer.send_bytes(minion_data.to_byte_array(), 0, MultiplayerPeer.TRANSFER_MODE_UNRELIABLE)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — batch sync and authority
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — lifting solo prototypes online
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
