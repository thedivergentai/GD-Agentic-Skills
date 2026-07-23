# connection_monitor.gd
extends Node
class_name ConnectionMonitor

# Controller Disconnect Handling
# Pauses the game if a controller battery dies mid-minigame.

func _ready() -> void:
    Input.joy_connection_changed.connect(_on_joy_changed)

func _on_joy_changed(device: int, connected: bool) -> void:
    if not connected:
        # Cross-reference with active tournament players.
        # if TournamentState.active_players.values().has(device):
        get_tree().paused = true
        # Notify UI to show reconnect prompt.
        get_tree().call_group(&"ui_overlays", &"show_reconnect", device)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — reconnect overlay on pause
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — active player device set
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
