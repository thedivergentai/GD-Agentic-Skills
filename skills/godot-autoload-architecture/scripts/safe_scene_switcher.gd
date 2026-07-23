# safe_scene_switcher.gd
# Robust scene transitioning via Autoload
extends Node

# EXPERT NOTE: Managing scenes in an Autoload prevents data loss 
# during transition and ensures proper cleanup of the current scene.

var current_scene: Node = null

func _ready() -> void:
	# Autoloads are the first children. The active game scene is the last child.
	current_scene = get_tree().root.get_child(-1)

func goto_scene(path: String) -> void:
	# NEVER free the current scene while it's executing (e.g., inside a signal).
	# Use call_deferred to wait until the end of the frame.
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String) -> void:
	# Safety: Free current scene before loading new one
	if is_instance_valid(current_scene):
		current_scene.free()
		
	var next_scene_res = ResourceLoader.load(path) as PackedScene
	current_scene = next_scene_res.instantiate()
	
	get_tree().root.add_child(current_scene)
	# Set as current for get_tree().current_scene access
	get_tree().current_scene = current_scene
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — primary owner of load/unload UX
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — PackedScene / ResourceLoader paths
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — fade wrappers around switch
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
