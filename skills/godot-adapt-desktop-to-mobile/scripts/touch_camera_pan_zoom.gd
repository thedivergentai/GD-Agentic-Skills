extends Camera2D
class_name TouchPanZoomCamera2D

## Expert Touch Camera Controller
## Handles 1-finger panning and 2-finger pinch zooming simultaneously.

@export var min_zoom := 0.5
@export var max_zoom := 3.0
@export var pan_speed := 1.0

var touches: Dictionary = {}

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            touches[event.index] = event.position
        else:
            touches.erase(event.index)
            
    elif event is InputEventScreenDrag:
        touches[event.index] = event.position
        
        if touches.size() == 1:
            # Panning
            # For Camera2D, we subtract the relative movement to drag the world across the screen
            position -= event.relative * pan_speed * (1.0 / zoom.x)
            
        elif touches.size() == 2:
            # Pinch to Zoom
            var keys = touches.keys()
            var t1 = touches[keys[0]]
            var t2 = touches[keys[1]]
            
            var previous_dist = t1.distance_to(t2)
            
            # Since event.relative is the change this frame, we reconstruct the previous positions
            var prev_t1 = touches[keys[0]]
            var prev_t2 = touches[keys[1]]
            
            if event.index == keys[0]: prev_t1 -= event.relative
            else: prev_t2 -= event.relative
            
            var old_dist = prev_t1.distance_to(prev_t2)
            
            # Ratio of new distance over old distance
            var zoom_factor = previous_dist / max(old_dist, 0.001)
            
            _apply_zoom(zoom_factor)

func _apply_zoom(factor: float) -> void:
    var new_zoom = zoom.x * factor
    new_zoom = clampf(new_zoom, min_zoom, max_zoom)
    zoom = Vector2(new_zoom, new_zoom)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_camera2d.html
# - https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — Camera2D follow/zoom contracts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — two-finger distance ratio
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md
# =============================================================================
