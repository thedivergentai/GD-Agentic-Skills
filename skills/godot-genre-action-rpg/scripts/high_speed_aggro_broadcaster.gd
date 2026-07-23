# high_speed_aggro_broadcaster.gd
extends Node
class_name HighSpeedAggroBroadcaster

# Group Broadcasting for Faction/Aggro
# Alerts a localized faction instantly without nested node iterations.

func alert_faction(faction_id: StringName, threat_pos: Vector3) -> void:
    # Pattern: Use call_group_flags with DEFERRED to avoid re-entering state logic.
    get_tree().call_group_flags(
        SceneTree.GROUP_CALL_DEFERRED,
        faction_id,           # Target Group (e.g. &"guards")
        &"on_threat_detected", # Target Method
        threat_pos            # Arguments
    )
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html — call_group_flags DEFERRED
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — threat alerts vs signals
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — deferred group vs bus tradeoffs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — on_threat_detected state entry
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
