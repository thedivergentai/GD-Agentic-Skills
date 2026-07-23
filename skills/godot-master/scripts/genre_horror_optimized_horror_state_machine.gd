# optimized_horror_state_machine.gd
extends Node

# Advanced State Machine Pattern Matching (Monster AI)
# Uses Godot 4's high-speed Enum/StringName matching for monster behavior.
var _active_state: StringName = &"patrol"

func _physics_process(_delta: float) -> void:
    match _active_state:
        # StringNames are pointer-compared, far faster than standard string hashing.
        &"patrol":
            _handle_patrol()
        &"chase":
            _handle_chase()
        &"search":
            _handle_search()
        _:
            # Fallback for undefined states.
            pass

func _handle_patrol() -> void: pass
func _handle_chase() -> void: pass
func _handle_search() -> void: pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — StringName states for hot-path AI
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — chase/search path retargets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md — higher-level agent behavior stacks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
