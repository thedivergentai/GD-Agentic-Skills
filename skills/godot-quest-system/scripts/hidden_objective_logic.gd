# hidden_objective_logic.gd
# Objectives that aren't visible in the UI
class_name HiddenObjective extends Resource

# EXPERT NOTE: Secret objectives can trigger "Achievement" quests 
# when internal game conditions are met.

signal triggered

@export var required_value: int = 100
var current_value: int = 0

func track_value(val: int):
	current_value += val
	if current_value >= required_value:
		triggered.emit()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — secret counters as Resources outside UI trackers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — triggered emit for achievement unlocks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
