# status_effect_data.gd
# Data definition for buffs and debuffs
class_name StatusEffectData extends Resource

# EXPERT NOTE: Defining effects as Resources makes them 
# strictly data-driven and easy to serialize/save.

enum Type { ADDITIVE, MULTIPLICATIVE, OVERRIDE }

@export var name: String = "Effect"
@export var type: Type = Type.ADDITIVE
@export var attribute: String = "strength"
@export var value: float = 0.0
@export var duration: float = 5.0
@export var icon: Texture2D
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — abilities that spawn StatusEffectData modifiers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — data-only buff/debuff Resources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
