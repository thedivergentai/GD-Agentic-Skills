# jump_buffer.gd
extends Node
class_name JumpBuffer

# Frame-Perfect Jump Buffering via Unhandled Input
# Captures input outside the physics tick to ensure fast inputs aren't dropped.

var buffer_time_left: float = 0.0
const MAX_BUFFER: float = 0.1

func _unhandled_input(event: InputEvent) -> void:
    # Pattern: Use StringName (&"jump") for optimized input checks.
    if event.is_action_pressed(&"jump"):
        buffer_time_left = MAX_BUFFER

func _physics_process(delta: float) -> void:
    if buffer_time_left > 0.0:
        buffer_time_left -= delta

func consume_jump() -> bool:
    if buffer_time_left > 0.0:
        buffer_time_left = 0.0
        return true
    return false
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — unhandled jump capture before physics tick
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — buffer window vs mistimed presses
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
