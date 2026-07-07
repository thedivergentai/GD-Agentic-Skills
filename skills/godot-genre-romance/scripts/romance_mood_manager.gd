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
