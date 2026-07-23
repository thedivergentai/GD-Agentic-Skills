# procedural_theme_safe.gd
# Ensuring safe theme lookups for procedurally generated UI [13]
extends PanelContainer

func _notification(what: int) -> void:
	# NOTIFICATION_THEME_CHANGED is the most reliable hook for 
	# dynamic theming as it catches tree entry and theme swaps.
	if what == NOTIFICATION_THEME_CHANGED:
		if not is_node_ready():
			await ready
			
		# Safely match a procedural element's color to the theme's core Button text
		var fallback_color := get_theme_color("font_color", "Button")
		$Label.add_theme_color_override("font_color", fallback_color)
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
