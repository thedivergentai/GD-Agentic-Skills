# frame_advancer.gd
@tool
class_name FrameAdvancer extends Node

@export var current_frame: int = 0:
    set(value):
        current_frame = value
        if Engine.is_editor_hint():
            _sync_animation_to_frame()

@export var step_forward: bool = false:
    set(value):
        if value:
            current_frame += 1
            step_forward = false # Reset toggle

func _sync_animation_to_frame() -> void:
    var anim_player: AnimationPlayer = get_node_or_null("../AnimationPlayer")
    if anim_player:
        anim_player.seek(current_frame * (1.0/60.0), true)
        # Force a redraw of debug shapes
        get_parent().queue_redraw()
