# async_scare_loader.gd
extends Node

# Asynchronous Jump-Scare Loading (Performance Optimization)
# Prevents the game thread from freezing right before a scare by pre-loading resources.
const SCARE_PATH := "res://scares/hallway_ghost.tscn"

func preload_jump_scare() -> void:
    # Requests the resource loader to start loading in the background.
    ResourceLoader.load_threaded_request(SCARE_PATH)

func execute_jump_scare() -> void:
    # Retreives the pre-loaded resource without stalling the main thread.
    var scare_scene := ResourceLoader.load_threaded_get(SCARE_PATH) as PackedScene
    if scare_scene:
        var instance = scare_scene.instantiate()
        get_tree().root.add_child(instance)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — threaded scene queues for scare props
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid sync load hitch spikes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — ResourceLoader status polling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
