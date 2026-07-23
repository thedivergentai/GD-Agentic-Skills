# dialogue_resource.gd
# Data-driven conversation tree
class_name DialogueResource extends Resource

# EXPERT NOTE: Dialogue should be stored in Resources to 
# allow for branching paths and localization keys.

@export var start_node: String = "start"
@export var nodes: Dictionary = {} # node_id -> DialogueNode
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource graph containers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — manager loads these Resources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
