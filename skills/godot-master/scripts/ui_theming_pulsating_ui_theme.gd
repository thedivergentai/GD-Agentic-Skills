# pulsating_ui_theme.gd
# Animating Theme properties via Tweens (Requires duplication) [10]
extends PanelContainer

var _tween_style: StyleBoxFlat

func trigger_pulsate() -> void:
	# Duplicate stylebox to ensure only THIS button pulsates
	_tween_style = get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	add_theme_stylebox_override("panel", _tween_style)
	
	var tween = create_tween().set_loops()
	# Target the resource property directly
	tween.tween_property(_tween_style, "bg_color", Color.RED, 0.4)
	tween.tween_property(_tween_style, "bg_color", Color.BLACK, 0.4)
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
