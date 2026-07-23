# interactive_rich_text.gd
# Handling hyperlink clicks in educational content
extends RichTextLabel

# EXPERT NOTE: RichTextLabel meta_clicked signal allows for 
# interactive glossaries or pop-up definitions within text.

func _on_meta_clicked(meta):
	# meta can be a URL or a custom string tag
	if str(meta).begins_with("glossary:"):
		_show_definition(str(meta).split(":")[1])

func _show_definition(_term):
	# Display popup logic here
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
# - https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — meta_clicked glossary patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — popup definition layout
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — glossary open signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
