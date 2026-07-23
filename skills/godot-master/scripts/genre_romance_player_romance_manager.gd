# player_romance_manager.gd
func start_date(npc_name: String):
    # Notify everyone in the group without needing direct references
    get_tree().call_group("romantic_interests", "on_player_date_started", npc_name)

# npc_jealousy.gd
func _ready():
    add_to_group("romantic_interests")

func on_player_date_started(dating_name: String):
    if dating_name != self.name and affection > 30:
        affection -= 10 # Jealousy penalty
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md
# =============================================================================
