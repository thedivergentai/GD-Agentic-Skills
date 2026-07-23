# typebox_effect.gd
# Character-by-character text reveal
extends Label

@export var chars_per_second: float = 30.0

func display_text(new_text: String):
	text = new_text
	visible_ratio = 0.0
	var duration = new_text.length() / chars_per_second
	var tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, duration)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tween.html
# - https://docs.godotengine.org/en/stable/classes/class_label.html
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — skippable reveal Tweens
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — RTL visible_characters alternative
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
