class_name RichTextImageScaler
extends Node

## Expert BBCode Image Scaling Helper.
## Ensures [img] tags match the current font size dynamically.

static func get_styled_img(rtl: RichTextLabel, path: String) -> String:
	# Get standard font size from theme
	var font_size = rtl.get_theme_font_size("normal_font_size")
	if font_size <= 0: font_size = 16
	
	# valign=center is crucial for alignment
	return "[img width=%d valign=center]%s[/img]" % [font_size, path]
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — sync [img] size to theme font size
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — prefer TextureRect icons outside BBCode when possible
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md
# =============================================================================
