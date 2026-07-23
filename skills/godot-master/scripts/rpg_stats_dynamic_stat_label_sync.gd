# dynamic_stat_label_sync.gd
# UI hook for reactive stat displays
extends Label

# EXPERT NOTE: UI should listen for stats_recalculated 
# rather than polling in _process.

@export var stats: StatsComponent
@export var target_attribute: String = "strength"

func _ready():
	if stats:
		stats.stats_recalculated.connect(_update_display)
		_update_display()

func _update_display():
	text = "%s: %d" % [target_attribute.capitalize(), stats.get_attribute(target_attribute)]
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_label.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — character-sheet Labels bound to stats
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — connect once in _ready, no _process poll
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
