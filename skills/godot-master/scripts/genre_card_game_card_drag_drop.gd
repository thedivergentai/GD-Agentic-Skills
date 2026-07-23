# card_drag_drop.gd
# Native Control node drag-and-drop implementation
extends Control

# EXPERT NOTE: Using Godot's built-in drag API ensures 
# consistency and handles OS-level cursor and window events.

func _get_drag_data(_at_position: Vector2):
	var preview = Label.new()
	preview.text = name
	set_drag_preview(preview)
	return self # Pass card data or node to the drop target

func _can_drop_data(_pos: Vector2, _data):
	return _data is Control # Basic validation
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# - https://docs.godotengine.org/en/stable/tutorials/ui/custom_gui_controls.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — pointer vs shortcut/accessibility drag paths
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — mouse_filter / z_index while dragging
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
