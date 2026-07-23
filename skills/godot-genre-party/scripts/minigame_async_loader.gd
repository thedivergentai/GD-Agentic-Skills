# minigame_async_loader.gd
extends Node
class_name MinigameAsyncLoader

# Asynchronous Minigame Loader
# Preloads scenes in the background to prevent frame-rate drops during transitions.

var _target_path: String

func load_minigame(path: String) -> void:
    _target_path = path
    # Pattern: Request threaded load to keep UI responsive.
    ResourceLoader.load_threaded_request(path)

func _process(_delta: float) -> void:
    if _target_path.is_empty(): return
    
    var status := ResourceLoader.load_threaded_get_status(_target_path)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var scene := ResourceLoader.load_threaded_get(_target_path) as PackedScene
        _target_path = ""
        _swap_scene(scene)

func _swap_scene(scene: PackedScene) -> void:
    # Safely swap the current scene.
    get_tree().current_scene.queue_free()
    var instance := scene.instantiate()
    get_tree().root.add_child(instance)
    get_tree().current_scene = instance
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — threaded preload during instructions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — scene_path from MinigameData
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
