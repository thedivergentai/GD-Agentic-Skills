class_name MetaProgression extends Resource

## Global meta-progression data stored separately from session data.
## Prevents wipe of permanent unlocks upon run permadeath.

@export var global_currency: int = 0
@export var unlocked_ability_ids: Array[StringName] = []
@export var permanent_upgrades: Dictionary = {}

const META_PATH = "user://meta_progression.tres"

func save_global() -> Error:
	return ResourceSaver.save(self, META_PATH)

static func load_global() -> MetaProgression:
	if ResourceLoader.exists(META_PATH):
		return load(META_PATH) as MetaProgression
	return MetaProgression.new()

func increment_currency(amount: int) -> void:
	global_currency += amount
	emit_changed()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — permanent unlock Resources separate from run
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — ResourceSaver paths under user://
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
