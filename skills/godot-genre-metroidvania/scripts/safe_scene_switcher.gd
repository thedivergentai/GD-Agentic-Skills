# safe_scene_switcher.gd
extends Node
class_name SafeSceneSwitcher

# Safe Deferred Scene Transitions
# Prevents engine crashes by ensuring scene changes happen between frames.

func goto_room(path: String) -> void:
    # Pattern: ALWAYS defer scene switches to avoid flushing nodes mid-execution.
    call_deferred(&"_deferred_goto_room", path)

func _deferred_goto_room(path: String) -> void:
    # Safely dispose of previous world before switching.
    if get_tree().current_scene:
        get_tree().current_scene.free()
        
    var next_scene := ResourceLoader.load(path) as PackedScene
    if next_scene:
        var instance := next_scene.instantiate()
        get_tree().root.add_child(instance)
        get_tree().current_scene = instance
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# - https://docs.godotengine.org/en/stable/classes/class_packedscene.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — deferred swaps and spawn handoff
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist state before room teardown
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
