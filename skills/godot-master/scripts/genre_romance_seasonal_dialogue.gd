# seasonal_dialogue.gd (Resource)
enum Season { SPRING, SUMMER, AUTUMN, WINTER }
@export var season_lines: Dictionary = { Season.WINTER: "Stay warm near the fire." }

# ui_layer.gd
func update_greeting(season: Season):
    var text = dialogue_res.get_seasonal_line(season)
    label.text = text.format({"player_name": Global.player_name})
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md
# =============================================================================
