# minigame_player_controller.gd
extends CharacterBody3D
class_name MinigamePlayerController

# Raw Device Input Polling
# Reads analog data directly from a specific joypad ID for local multiplayer.

@export var device_id: int = -1
@export var speed := 10.0

func _physics_process(_delta: float) -> void:
    if device_id == -1: return
    
    # Pattern: Bypassing InputMap for precise multi-device polling.
    var x := Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X)
    var y := Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y)
    
    var dir := Vector3(x, 0, y)
    if dir.length() > 0.2: # Deadzone
        velocity = dir * speed
    else:
        velocity = Vector3.ZERO
        
    move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — deadzone + get_joy_axis per device
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — analogous 2D move_and_slide consumers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
