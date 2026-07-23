# theme_isolation.gd
# Forcing a node to ignore parent themes and use the Project default [15]
extends Control

func _ready() -> void:
	# If a parent customizes the theme, but this HUD needs absolute consistency:
	var baseline_theme := ThemeDB.get_project_theme()
	
	# Explicitly setting the theme resource halts the upward tree search.
	# This ensures the HUD pulls only from the Project Settings theme.
	self.theme = baseline_theme
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
