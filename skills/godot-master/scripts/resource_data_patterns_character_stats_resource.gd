# character_stats_resource.gd
# Reactive data containers using signals
class_name CharacterStats extends Resource

# EXPERT NOTE: Resources can emit signals! Use this to update 
# UI automatically when a stat value changes.

signal changed(property_name: String, new_val: Variant)

@export var level: int = 1:
	set(val):
		if level != val:
			level = val
			changed.emit("level", val)
			emit_changed() # Native Resource signal
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — Resource changed signals for reactive UI
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — stats tables as balance extract sources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
