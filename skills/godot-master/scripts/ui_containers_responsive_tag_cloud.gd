# responsive_tag_cloud.gd
# Wrapping item lists using HFlowContainer [8, 15]
extends HFlowContainer

func populate_tags(tags: Array[String]) -> void:
	# Clear existing
	for child in get_children(): child.queue_free()
	
	# HFlowContainer automatically wraps items to next line 
	# based on available width.
	last_wrap_alignment = FlowContainer.LAST_WRAP_ALIGNMENT_BEGIN
	
	for tag_text in tags:
		var lbl = Label.new()
		lbl.text = "#" + tag_text
		add_child(lbl)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_hflowcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_flowcontainer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — Label/chip theme for tags
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — rich tags vs plain Label chips
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
