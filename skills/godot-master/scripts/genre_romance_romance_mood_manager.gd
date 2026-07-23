extends CanvasLayer
class_name RomanceMoodManager

## Expert Mood Orchestrator (Godot 4.7).
## Manages atmospheric filters and character transitions.

@export var mood_overlay: ColorRect
@export var portrait_node: TextureRect

func transition_to_mood(color: Color, time: float = 1.0) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(mood_overlay, "color", color, time)

func crossfade_portrait(new_tex: Texture2D, time: float = 0.5) -> void:
	var tween = create_tween().set_parallel(true)
	# Fade out old, Fade in new
	tween.tween_property(portrait_node, "modulate:a", 0.0, time / 2)
	tween.chain().tween_callback(func(): portrait_node.texture = new_tex)
	tween.tween_property(portrait_node, "modulate:a", 1.0, time / 2)

## [SKILL NOTICE]: Use a 'ColorRect' as a screen-space overlay to instantly 
## shift the emotional tone (sad, romantic, intense) of 2D narrative scenes.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_colorrect.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — mood overlay and portrait crossfade
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — mood-driven BGM / stingers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md — portrait layers in VN scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md
# =============================================================================
