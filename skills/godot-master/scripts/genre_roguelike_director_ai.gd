# director_ai.gd (Autoload)
func _process(_delta):
    # Only evaluate every 60 frames
    if Engine.get_process_frames() % 60 == 0:
        _update_pacing_logic()

func _update_pacing_logic():
    if player_health < 30:
        spawn_rate -= 0.5 # Ease up
    elif player_kills > 100:
        spawn_rate += 1.0 # Challenge more
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
