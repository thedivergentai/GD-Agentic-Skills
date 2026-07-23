# player_join_manager.gd
extends Node
class_name PlayerJoinManager

# Dynamic Player "Join" System (Local Multiplayer)
# Listens for any controller pressing "Start" and assigns device IDs.

signal player_joined(player_index: int, device_id: int)

var active_players: Dictionary = {} # Maps player_index (0-3) to device_id
var max_players := 4

func _unhandled_input(event: InputEvent) -> void:
    # Pattern: Use raw InputEventJoypadButton to identify the EXACT physical device.
    if event is InputEventJoypadButton and event.is_pressed() and not event.is_echo():
        if not active_players.values().has(event.device):
            if active_players.size() < max_players:
                var next_player_index = active_players.size()
                active_players[next_player_index] = event.device
                player_joined.emit(next_player_index, event.device)
                
                # Mark as handled to prevent multiple joins from one press.
                get_viewport().set_input_as_handled()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_inputeventjoypadbutton.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — raw joypad join vs action polling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — persist slot→device map
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
