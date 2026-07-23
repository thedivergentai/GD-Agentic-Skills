# theme_swapper.gd
# Dynamic theme switching (Dark/Light mode) with cascading propagation
extends Node

@export var light_theme: Theme
@export var dark_theme: Theme

func set_dark_mode(is_dark: bool) -> void:
	# Find the root control (usually your main scene root)
	# Applying a theme at the root level updates all children automatically [11].
	var root_control := get_tree().root.get_child(0) as Control
	if root_control:
		root_control.theme = dark_theme if is_dark else light_theme
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html
# - https://docs.godotengine.org/en/stable/classes/class_theme.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — layout before skin polish
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md — seasonal Theme overlays
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md
# =============================================================================
