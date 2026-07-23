# resource_stat_inheritance.gd
# Specialized stat containers (e.g., Elemental Resistances)
class_name ElementalStats extends BaseStats

@export var fire_res: float = 0.0
@export var ice_res: float = 0.0

func get_res(element: String) -> float:
	return get(element + "_res")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — extending BaseStats with elemental fields
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — class_name inheritance for specialized stats
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
