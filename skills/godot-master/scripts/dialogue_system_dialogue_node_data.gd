# dialogue_node_data.gd
# Single step in a conversation
class_name DialogueNode extends Resource

@export var speaker_name: String = ""
@export var portrait: Texture2D
@export_multiline var text: String = ""
@export var options: Array[DialogueOption] = []
@export var event_signal: String = "" # Optional signal to emit
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_texture2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — exported line/node fields
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — speaker text consumed by RTL
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
