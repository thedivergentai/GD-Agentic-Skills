# currency_resource.gd
# Specialized data container for denominations
class_name Currency extends Resource

# EXPERT NOTE: Defining Gold, Gems, and XP as Resources 
# allow for modular wallet logic and distinct UI icons.

@export var id: String = "gold"
@export var display_name: String = "Gold"
@export var icon: Texture2D
@export var is_premium: bool = false
@export var max_limit: int = 999999
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Currency denominations as Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — icon/display_name bind to HUD
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
