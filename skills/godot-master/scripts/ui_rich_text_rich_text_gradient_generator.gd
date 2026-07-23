class_name RichTextGradientGenerator
extends RefCounted

## Expert Multi-Stop Gradient BBCode Generator.
## Wraps a string in granular [color] tags to create a smooth gradient.

static func generate(text: String, color_start: Color, color_end: Color) -> String:
	var result := ""
	var length := text.length()
	
	for i in range(length):
		var t := float(i) / float(length - 1) if length > 1 else 0.5
		var col := color_start.lerp(color_end, t)
		result += "[color=#%s]%s[/color]" % [col.to_html(false), text[i]]
		
	return result
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — pull gradient stops from theme colors
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — cache generated BBCode strings
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
