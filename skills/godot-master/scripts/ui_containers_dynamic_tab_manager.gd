# dynamic_tab_manager.gd
# Expert management of TabContainer with runtime spawning and closing [13]
extends TabContainer

func add_session_tab(content: Control, title: String, icon: Texture2D) -> void:
	add_child(content)
	var idx := get_tab_idx_from_control(content)
	
	# Override default node-name titles with semantic names
	set_tab_title(idx, title)
	set_tab_icon(idx, icon)
	
	# Focus the new tab
	current_tab = idx

func close_focused_tab() -> void:
	var control := get_current_tab_control()
	if control:
		# TabContainer automatically removes the tab when the child is freed
		control.queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tabcontainer.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — tab_changed / close request wiring
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — tab content as packed scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
