# dynamic_stylebox_color.gd
# Safely overriding StyleBoxes at runtime without affecting other nodes [10]
extends Button

func set_runtime_color(new_color: Color) -> void:
	# CRITICAL: StyleBoxes are resources and SHARED by default.
	# You MUST duplicate() before modifying or you will change the whole theme.
	var custom_style := get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	
	if custom_style:
		custom_style.bg_color = new_color
		# Apply the unique override to this specific instance only
		add_theme_stylebox_override("normal", custom_style)
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
