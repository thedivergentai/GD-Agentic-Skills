# frame_perfect_input.gd
extends Node
class_name FramePerfectInput

# Frame-Perfect Input Interception
# Ensures semi-automatic inputs are never missed due to physics/render lag.

var _fire_requested := false

func _unhandled_input(event: InputEvent) -> void:
    # Pattern: Intercept event immediately, then process in next physics tick.
    if event.is_action_pressed(&"fire"):
        _fire_requested = true

func _physics_process(_delta: float) -> void:
    if _fire_requested:
        _fire_requested = false
        perform_shot()

func perform_shot() -> void:
    # Trigger actual weapon logic here.
    pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_inputeventmousemotion.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md - buffered semi-auto fire to avoid dropped shots
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md - fire intent signals without string connects
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
