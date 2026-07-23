# base_stats_resource.gd
# Core data container for RPG attributes
class_name BaseStats extends Resource

# EXPERT NOTE: Using a Resource for base stats allows for 
# "Template" creation in the Inspector (e.g., GoblinStats, BossStats).

@export_group("Primary Attributes")
@export var strength: int = 10
@export var dexterity: int = 10
@export var intelligence: int = 10

@export_group("Derived Scaling")
@export var hp_per_strength: float = 5.0
@export var mp_per_intelligence: float = 3.0

func get_max_hp() -> int:
	return int(strength * hp_per_strength)

func get_max_mp() -> int:
	return int(intelligence * mp_per_intelligence)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource templates for attribute containers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed derived getters from exported bases
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
