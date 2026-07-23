# rts_group_commander.gd
extends Node
class_name RTSGroupCommander

# Decoupled Group Broadcasting for Mass Commands
# Instantly alerts all units in a control group without hardcoded array iteration.

func order_move_group(group_id: StringName, target_pos: Vector3) -> void:
    # Pattern: Use call_group_flags with DEFERRED and UNIQUE for safety and efficiency.
    var flags := SceneTree.GROUP_CALL_DEFERRED | SceneTree.GROUP_CALL_UNIQUE
    
    get_tree().call_group_flags(
        flags,
        group_id,      # Target group (e.g., &"group_1")
        &"move_to",    # Target method in unit script
        target_pos     # Arg
    )
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — decoupled group command broadcast
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
