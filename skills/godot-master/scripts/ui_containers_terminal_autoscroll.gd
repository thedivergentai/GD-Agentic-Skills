# terminal_autoscroll.gd
# Safe ScrollContainer management for logs/chat [4, 5]
extends ScrollContainer

@onready var content_vbox: VBoxContainer = $VBoxContainer

func append_log(log_node: Control) -> void:
	var at_bottom := _is_at_bottom()
	content_vbox.add_child(log_node)
	
	# ANTI-PATTERN PREVENTION: The scrollbar doesn't update until the 
	# layout is recalculated. You MUST wait a frame [5].
	await get_tree().process_frame
	
	if at_bottom:
		scroll_vertical = int(get_v_scroll_bar().max_value)

func _is_at_bottom() -> bool:
	var bar := get_v_scroll_bar()
	# Check if the current scroll is near the bottom (max - page)
	return scroll_vertical >= (bar.max_value - bar.page - 10)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_scrollcontainer.html
# - https://docs.godotengine.org/en/stable/classes/class_scrollbar.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md — log/chat lines that grow scroll max
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — debug consoles using autoscroll
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
