# scene_transition_manager.gd
# Smooth transitions between scenes using Tweens/Shaders
extends CanvasLayer

@onready var color_rect := $ColorRect

func transition_to(scene_path: String):
	# Fade to black
	var tween = create_tween()
	await tween.tween_property(color_rect, "color:a", 1.0, 0.5).finished
	
	get_tree().change_scene_to_file(scene_path)
	
	# Fade back in
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, 0.5)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — fade/wipe Tweens wrapping scene swaps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — CanvasLayer overlay layout for transition covers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
