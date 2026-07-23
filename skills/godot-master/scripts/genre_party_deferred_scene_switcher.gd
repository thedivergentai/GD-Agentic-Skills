# deferred_scene_switcher.gd
extends Node
class_name DeferredSceneSwitcher

# Safe Deferred Scene Switcher
# Transitions between minigames without crashing due to logic mid-execution.

func switch_to_hub(path: String) -> void:
    # NEVER free a scene immediately during its own logic execution.
    call_deferred(&"_deferred_switch", path)

func _deferred_switch(path: String) -> void:
    if get_tree().current_scene:
        get_tree().current_scene.free()
        
    var next := ResourceLoader.load(path) as PackedScene
    var inst := next.instantiate()
    get_tree().root.add_child(inst)
    get_tree().current_scene = inst
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — call_deferred free before instantiate
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — hub path from party singleton
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
