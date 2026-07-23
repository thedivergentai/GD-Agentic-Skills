# container_size_flags_pro.gd
# Expertly managing flexible sizing using Stretch Ratios [17]
extends HBoxContainer

func add_weighted_panels() -> void:
	var sidebar := Panel.new()
	var main_content := Panel.new()
	
	# Sidebar: fixed minimum width, no expansion
	sidebar.custom_minimum_size.x = 200
	sidebar.size_flags_horizontal = Control.SIZE_FILL
	
	# Main Content: Expands to fill, taking 4x the remaining space
	main_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_content.size_flags_stretch_ratio = 4.0
	
	add_child(sidebar)
	add_child(main_content)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
# - https://docs.godotengine.org/en/stable/classes/class_hboxcontainer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — sidebar/main chrome with weighted ratios
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — app shell split layouts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md
# =============================================================================
