# nested_resource_serialization.gd
# Building complex data hierarchies with Resources
class_name QuestData extends Resource

# EXPERT NOTE: Resources can contain other Resources. 
# Godot handles the nested serialization automatically.

@export var title: String
@export var rewards: Array[ItemData]
@export var start_stats_requirement: CharacterStats
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — nested dialogue Resources serialize the same way
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — ability trees as nested Resource graphs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
