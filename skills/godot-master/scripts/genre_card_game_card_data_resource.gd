# card_data_resource.gd
# Defining cards as lightweight data-driven Resources
class_name CardData extends Resource

# EXPERT NOTE: Resources allow designers to edit card stats 
# in the Godot Inspector, saving them as .tres files.

@export var card_name: String = "Blank"
@export var mana_cost: int = 1
@export var attack: int = 0
@export var health: int = 1

# Setter with changed emission for reactive UI
func update_stats(new_atk, new_hp):
	attack = new_atk
	health = new_hp
	emit_changed()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — duplicate-before-mutate for match buffs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — Resource.changed → reactive card faces
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
