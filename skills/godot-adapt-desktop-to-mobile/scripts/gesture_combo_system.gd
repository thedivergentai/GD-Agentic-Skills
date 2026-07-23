extends Node
class_name GestureComboSystem

## Expert Swipe and Pinch Gesture Recognizer
## Tracks touch start/end times and calculates velocity for flicks.

signal swipe_detected(direction: Vector2, velocity: float)
signal zoom_detected(scale_factor: float) # <1 for pinch out, >1 for pinch in

var touches: Dictionary = {}

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            touches[event.index] = {
                "start_pos": event.position,
                "current_pos": event.position,
                "time": Time.get_ticks_msec()
            }
        else:
            _analyze_release(event)
            touches.erase(event.index)
            
    elif event is InputEventScreenDrag:
        if touches.has(event.index):
            touches[event.index]["current_pos"] = event.position
            _analyze_drag()

func _analyze_release(event: InputEventScreenTouch) -> void:
    if touches.size() != 1: return # Ignore single swipes if multiple fingers down
    
    var data = touches[event.index]
    var distance = event.position.distance_to(data.start_pos)
    var duration = (Time.get_ticks_msec() - data.time) / 1000.0
    
    # 50 pixels minimum distance, < 0.3 seconds duration to count as swipe
    if distance > 50.0 and duration < 0.3:
        var direction = (event.position - data.start_pos).normalized()
        var velocity = distance / duration
        swipe_detected.emit(direction, velocity)

func _analyze_drag() -> void:
    if touches.size() == 2:
        var keys = touches.keys()
        var touch1 = touches[keys[0]]
        var touch2 = touches[keys[1]]
        
        var start_dist = touch1.start_pos.distance_to(touch2.start_pos)
        var current_dist = touch1.current_pos.distance_to(touch2.current_pos)
        
        if start_dist > 10.0:
            var scale_factor = current_dist / start_dist
            zoom_detected.emit(scale_factor)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# - https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html
# - https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — swipe/pinch buffers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md — tap/swipe consumers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md
# =============================================================================
