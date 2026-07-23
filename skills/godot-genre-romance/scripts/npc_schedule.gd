# npc_schedule.gd (Resource)
class_name NPCSchedule extends Resource
@export var daily_routine: Dictionary = {8: "TownSquare", 12: "Tavern", 18: "Home"}

# npc_controller.gd
func _ready():
    TimeManager.hour_changed.connect(_on_hour_changed)

func _on_hour_changed(hour: int):
    var dest = schedule.daily_routine.get(hour, "")
    if dest: _navigate_to(dest)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md
# =============================================================================
