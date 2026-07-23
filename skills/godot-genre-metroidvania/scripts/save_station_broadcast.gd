# save_station_broadcast.gd
extends Area2D
class_name SaveStationBroadcast

# Broadcasting Save Station Events
# Uses Godot groups to reset enemies and world state without manual iteration.

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group(&"player"):
        _trigger_save_routine(body)

func _trigger_save_routine(player: Node2D) -> void:
    # 1. Broadly reset all entities in the 'enemies' group.
    get_tree().call_group(&"enemies", &"respawn")
    
    # 2. Heal the player via duck-typing to avoid hard dependencies.
    if player.has_method(&"heal_to_full"):
        player.call(&"heal_to_full")
    
    # 3. Trigger persistent save logic.
    # SaveManager.save_game()
    pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — save-triggered heal/respawn events
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — checkpoint write on station interact
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
