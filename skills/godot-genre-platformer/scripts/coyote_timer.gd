# coyote_timer.gd
extends Node
class_name CoyoteTimer

# Coyote Time Logic
# Tracks the precise time since the player left the floor to grant a brief jump window.

var time_left: float = 0.0
const MAX_COYOTE: float = 0.15

func update_coyote(is_on_floor: bool, delta: float) -> void:
    if is_on_floor:
        time_left = MAX_COYOTE
    else:
        time_left -= delta

func can_jump() -> bool:
    # Pattern: Avoid exact floating point equality (== 0.0).
    return time_left > 0.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — is_on_floor grace after leave
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — coyote window fairness
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
