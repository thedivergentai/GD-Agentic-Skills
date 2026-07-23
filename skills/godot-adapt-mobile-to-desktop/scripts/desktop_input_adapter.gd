# skills/adapt-mobile-to-desktop/scripts/desktop_input_adapter.gd
extends Node

## Desktop Input Adapter Expert Pattern
## Maps standard Desktop inputs (WASD + Mouse) to Mobile actions.

class_name DesktopInputAdapter

## Emitted on PC when FPS/orbit look needs MouseCaptureLook — connect in Player/Orchestrator.
signal mouse_look_bridge_requested

# Configuration -> Action Map
# Maps "mobile_action_name": [Keycodes]
var key_map = {
    "interact": [KEY_E, KEY_SPACE],
    "inventory": [KEY_I, KEY_TAB],
    "pause": [KEY_ESCAPE],
    "map": [KEY_M]
}

func _ready() -> void:
    if OS.has_feature("pc") or OS.has_feature("web_pc") or OS.is_debug_build():
        _inject_input_map()
        _enable_mouse_look()

func _inject_input_map() -> void:
    # Ensure PC keys trigger the same actions as Mobile buttons
    for action in key_map:
        if not InputMap.has_action(action):
            InputMap.add_action(action)
        
        for key in key_map[action]:
            var ev = InputEventKey.new()
            ev.keycode = key
            if not InputMap.action_has_event(action, ev):
                InputMap.action_add_event(action, ev)

func _enable_mouse_look() -> void:
    # Top-down aim: use get_aim_vector() — no capture needed.
    # FPS/orbit: listen for this signal and attach MouseCaptureLook on the camera rig.
    mouse_look_bridge_requested.emit()

func get_aim_vector(current_pos: Vector2) -> Vector2:
    if OS.has_feature("pc") or OS.has_feature("web_pc"):
         # Mouse aim
        return (get_viewport().get_mouse_position() - current_pos).normalized()
    else:
        # Joystick aim (assumes Input Map "aim_x", "aim_y" setup)
        return Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")

## EXPERT USAGE:
## AutoLoad this script. Use `DesktopInputAdapter.get_aim_vector()` in player code
## to support both Joystick (mobile) and Mouse (desktop) seamlessly.
## Connect `mouse_look_bridge_requested` → enable `MouseCaptureLook` when relative motion is required.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_inputmap.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — injecting PC events onto mobile actions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — action names shared with touch controls
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-mobile-to-desktop/SKILL.md
# =============================================================================
