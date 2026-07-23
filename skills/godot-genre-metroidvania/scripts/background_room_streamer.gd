# background_room_streamer.gd
extends Node
class_name BackgroundRoomStreamer

# Background Room Streaming
# Prevents lag spikes during room transitions by threading the load.

func preload_room(path: String) -> void:
    # Requests the room scene to be loaded on a background thread.
    ResourceLoader.load_threaded_request(path)

func fetch_loaded_room(path: String) -> PackedScene:
    # Retrieves the loaded scene safely without stalling the main thread.
    # Returns null if not ready yet.
    if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
        return ResourceLoader.load_threaded_get(path) as PackedScene
    return null
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — threaded load queues for room graphs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — streamer ownership as Autoload vs scene node
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
