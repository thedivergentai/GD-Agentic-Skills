# rtl_theme_mirroring.gd
# Handling Right-to-Left (RTL) layout mirroring via Themes [19]
extends MarginContainer

func _notification(what: int) -> void:
	if what == NOTIFICATION_THEME_CHANGED or what == NOTIFICATION_TRANSLATION_CHANGED:
		# Detect if the current locale (Arabic, Hebrew) requires RTL
		if is_layout_rtl():
			# Apply mirrored stylebox/font overrides
			var rtl_style := get_theme_stylebox("panel_rtl", "CustomHUD")
			add_theme_stylebox_override("panel", rtl_style)
		else:
			remove_theme_stylebox_override("panel")
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
