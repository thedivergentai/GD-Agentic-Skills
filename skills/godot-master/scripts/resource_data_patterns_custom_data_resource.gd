# custom_data_resource.gd
# Defining serialized data containers
class_name ItemData extends Resource

# EXPERT NOTE: Resources are pure data. Using class_name allows 
# them to be instantiated in the Inspector as .tres files.

@export var name: String = "Unknown Item"
@export var icon: Texture2D
@export var base_value: int = 10
@export_multiline var description: String = ""

# Constructor with default values is REQUIRED for Inspector support
func _init(p_name: String = "Unknown", p_value: int = 10):
	name = p_name
	base_value = p_value
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — class_name + typed @export on Resource scripts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — ItemData consumed by inventory stacks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
