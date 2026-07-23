# dialogue_portrait_manager.gd
# Handling speaker expressions visually
extends TextureRect

func _ready():
	DialogueManager.line_started.connect(_on_line_started)

func _on_line_started(node: DialogueNode):
	if node.portrait:
		texture = node.portrait
		# Add tween for "entry" animation
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_texturerect.html
# - https://docs.godotengine.org/en/stable/classes/class_texture2d.html
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — portrait entry animation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — portrait slot layout
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
